//
//  WebSocketTransport.swift
//  WebSocketTransport
//
//  Created by Paul Young on 28/08/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import Transport
import MessageTransfer
import JSONLib

public struct WebSocketTransport: Transport {
    
    private let webSocketServer = BLWebSocketsServer.sharedInstance()
    
    private let channelKey = "protocol"
    private let topicKey = "command"
    private let payloadKey = "payload"
    
    public var messageReceiver: MessageReceiver?
    
    public init(_ port: Int32, _ protocolName: String, var _ messageReceiver: MessageReceiverWithSender) {
        
        self.messageReceiver = messageReceiver
        messageReceiver.messageSender = self
        
        self.webSocketServer.setHandleRequestBlock { (data) -> NSData! in
            
            if let receiver = self.messageReceiver {
                let jsonString = NSString(data: data, encoding: UInt())

                if let json = JSON.parse(jsonString).value {
                    let channel = json[self.channelKey].string
                    let topic = json[self.topicKey].string
                    let jsonPayload: JSON = json[self.payloadKey]
                    let payload = jsonPayload.object
                    
                    switch (channel, topic, payload) {
                    case let (.Some(channel), .Some(topic), .Some(payload)):
                        receiver.receive(channel, topic, jsonPayload)
                    default:
                        break
                    }
                }
            }

            return nil
        }
        
        self.webSocketServer.startListeningOnPort(port, withProtocolName: protocolName) { (error) in
            if (error != nil) {
                println(error)
            }
        }
    }
    
    public func send(channel: String, _ topic: String, _ payload: JSON) {

        let messageJson: JSON = [
            self.channelKey: JSValue(channel),
            self.topicKey: JSValue(topic),
            self.payloadKey: payload
        ]
        
        let message = messageJson.stringify(indent: "") as NSString
        let messageData = message.dataUsingEncoding(NSUTF8StringEncoding)
        
        self.webSocketServer.pushToAll(messageData)
    }
}
