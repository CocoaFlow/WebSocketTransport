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
                
                it("should set the message receiver") {
                    let fakeMessageReceiver = FakeMessageReceiver()
                    let transport = WebSocketTransport(fakeMessageReceiver)
                    expect(transport.messageReceiver).to(beIdenticalTo(fakeMessageReceiver))
                }
                
                it("should set itself as the message sender") {
                    let fakeMessageReceiver = FakeMessageReceiver()
                    let transport = WebSocketTransport(fakeMessageReceiver)
                    expect(fakeMessageReceiver.messageSender).to(beIdenticalTo(transport))
                }
            }
            
            describe("receiving a message") {
            
                it("should receive a message in the runtime") {
                    let transport = WebSocketTransport()
                    
                    let transportChannel = "channel"
                    let transportTopic = "topic"
                    let transportPayload = "{\"key\":\"value\"}"
                    let transportData = "{\"protocol\":\"\(transportChannel)\",\"command\":\"\(transportTopic)\",\"payload\":\(transportPayload)}"
                    
                    var runtimeChannel: String!
                    var runtimeTopic: String!
                    var runtimePayload: JSON!
                    
                    let runtime = FakeRuntime(transport) { (channel, topic, payload) in
                        runtimeChannel = channel
                        runtimeTopic = topic
                        runtimePayload = payload
                    }
                    
                    let fakeWebSocketClient = FakeWebSocketClient { webSocket in
                        webSocket.send(transportData)
                    }
                    
                    expect(runtimeChannel).toEventually(equal(transportChannel))
                    expect(runtimeTopic).toEventually(equal(transportTopic))
                    expect(runtimePayload).toEventually(equal(JSON.parse(transportPayload).value))
                }
            }
            
            describe("sent a message by the runtime") {
                
                pending("should send a message") {
                    
                }
            }
        }
    }
}
