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
            
            describe("creating an instance") {
                
                pending("should set the message receiver") {
                    let fakeMessageReceiver = FakeMessageReceiver()
                    let transport = WebSocketTransport(fakeMessageReceiver)
//                    expect(transport.messageReceiver).to(beIdenticalTo(fakeMessageReceiver))
                }
                
                pending("should set itself as the message sender") {
                    let fakeMessageReceiver = FakeMessageReceiver()
                    let transport = WebSocketTransport(fakeMessageReceiver)
//                    expect(fakeMessageReceiver.messageSender).to(beIdenticalTo(transport))
                }
            }
            
            describe("receiving a message") {
            
                it("should receive a message in the runtime") {
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

                    let transport = WebSocketTransport(fakeMessageReceiver)
                    
                    let fakeWebSocketClient = FakeWebSocketClient { webSocket in
                        webSocket.send(transportData)
                    }
                    
                    expect(receiverChannel).toEventually(equal(transportChannel))
                    expect(receiverTopic).toEventually(equal(transportTopic))
                    expect(receiverPayload).toEventually(equal(JSON.parse(transportPayload).value))
                }
            }
            
            describe("sent a message by the runtime") {
                
                pending("should send a message") {
                    
                }
            }
        }
    }
}
