//
//  FakeMessageReceiver.swift
//  WebSocketTransport
//
//  Created by Paul Young on 03/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Foundation
import MessageTransfer
import JSONLib

class FakeMessageReceiver: MessageReceiverWorkaround {
    
    typealias Verification = (channel: String, topic: String, payload: JSON) -> Void
    
    private let verify: Verification
    var messageSender: MessageSender?
    
    init(_ verify: Verification = { (channel, topic, payload) in }) {
        self.verify = verify
    }
    
    func send(channel: String, _ topic: String, _ payload: JSON) {
        if let sender = self.messageSender {
            sender.send(channel, topic, payload)
        }
    }
    
    func receive(channel: String, _ topic: String, _ payload: JSON) {
        self.verify(channel: channel, topic: topic, payload: payload)
    }
}
