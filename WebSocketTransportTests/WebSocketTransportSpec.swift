//
//  WebSocketTransportSpec.swift
//  WebSocketTransportSpec
//
//  Created by Paul Young on 28/08/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Quick
import Nimble
import WebSocketTransport
import JSONLib

class WebSocketTransportSpec: QuickSpec {
    
    override func spec() {
        
        describe("WebSocket transport") {
                        
            describe("receiving a message") {
            
                it("should receive a message in the message receiver") {
                    let transportChannel = "channel"
                    let transportTopic = "topic"
                    let transportPayload = "{\"key\":\"value\"}"
                    let transportData = "{\"protocol\":\"\(transportChannel)\",\"command\":\"\(transportTopic)\",\"payload\":\(transportPayload)}"
                    
                    var receiverChannel: String!
                    var receiverTopic: String!
                    var receiverPayload: JSON!
                    
                    let fakeMessageReceiver = FakeMessageReceiver() { (channel, topic, payload) in
                        receiverChannel = channel
                        receiverTopic = topic
                        receiverPayload = payload
                    }
                    
                    let port: Int32 = 3569
                    let protocolName = "CocoaFlow"
                    let transport = WebSocketTransport(port, protocolName, fakeMessageReceiver)
                    
                    let fakeWebSocketClient = FakeWebSocketClient(port, protocolName) { webSocket in
                        webSocket.send(transportData)
                    }
                    
                    expect(receiverChannel).toEventually(equal(transportChannel))
                    expect(receiverTopic).toEventually(equal(transportTopic))
                    expect(receiverPayload).toEventually(equal(JSON.parse(transportPayload).value))
                }
            }
            
            describe("sent a message by the message receiver") {
                
                it("should send a message") {
                    let receiverChannel = "channel"
                    let receiverTopic = "topic"
                    let receiverPayload = "{\"key\":\"value\"}"

                    let expectedMessage = "{\"protocol\":\"\(receiverChannel)\",\"command\":\"\(receiverTopic)\",\"payload\":\(receiverPayload)}"
                    
                    var jsonExpectedMessage = JSON.parse(expectedMessage).value
                    var jsonTransportMessage: JSON!
                    
                    let fakeMessageReceiver = FakeMessageReceiver()
                    let port: Int32 = 3569
                    let protocolName = "CocoaFlow"
                    let transport = WebSocketTransport(port, protocolName, fakeMessageReceiver)
                    
                    let fakeWebSocketClient = FakeWebSocketClient(port, protocolName, { webSocket in
                        fakeMessageReceiver.messageSender = transport
                        fakeMessageReceiver.send(receiverChannel, receiverTopic, JSON.parse(receiverPayload).value!)
                    }, { message in
                        jsonTransportMessage = JSON.parse(message).value
                    })
                    
                    expect(jsonTransportMessage).toEventually(equal(jsonExpectedMessage))
                }
            }
        }
    }
}
