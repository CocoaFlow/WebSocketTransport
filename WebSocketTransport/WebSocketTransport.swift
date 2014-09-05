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
    public var messageReceiver: MessageReceiver?
    
    // TODO: Make port option in protocol
    public init(var _ messageReceiver: MessageReceiverWorkaround) {
        self.messageReceiver = messageReceiver
        messageReceiver.messageSender = self
        
        self.webSocketServer.setHandleRequestBlock { (data) -> NSData! in
            
            if let receiver = self.messageReceiver {
                let jsonString = NSString(data: data, encoding: UInt())

                if let json = JSON.parse(jsonString).value {
                    let channel = json["protocol"].string
                    let topic = json["command"].string
                    let jsonPayload: JSON = json["payload"]
                    let payload = jsonPayload.object
                    
                    switch (channel, topic, payload) {
                    case let (.Some(channel), .Some(topic), .Some(payload)):
                        receiver.receive(channel, topic, jsonPayload)
                    default:
                        break
                    }
                }
            }
            
            // TODO: Determine if returning nil is valid - "Attempt to write empty data on the websocket"
            return nil
        }
        
        self.webSocketServer.startListeningOnPort(3569, withProtocolName: nil) { (error) in
            if (error != nil) {
                println(error)
            }
        }
    }
    
    public func send(channel: String, _ topic: String, _ payload: JSON) {
        // TODO
    }
}
