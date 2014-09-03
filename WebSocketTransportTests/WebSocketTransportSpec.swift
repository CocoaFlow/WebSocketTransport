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
            
            describe("when receiving a message") {
            
                it("should be received in the runtime") {
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

                    // TODO: Receive a message in the transport
                    
                    expect(runtimeChannel).to(equal(transportChannel))
                    expect(runtimeTopic).to(equal(transportTopic))
                    
                    let json = JSON.parse(transportPayload).value
                    expect(runtimePayload).to(equal(json))
                }
            }
            
            describe("when sent a message by the runtime") {
                
                pending("should send a message") {
                    
                }
            }
        }
    }
}
