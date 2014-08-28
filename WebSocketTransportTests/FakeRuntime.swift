//
//  FakeRuntime.swift
//  WebSocketTransport
//
//  Created by Paul Young on 28/08/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Transport
import JSONLib

struct FakeRuntime {
    
    typealias Verification = (channel: String, topic: String, payload: JSON) -> Void
    
    private let transport: Transport
    private let verify: Verification
    
    init(_ transport: Transport, _ verify: Verification = { (channel, topic, payload) in }) {
        self.transport = transport
        self.verify = verify
    }
    
    func receive(channel: String, _ topic: String, _ payload: JSON) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}
