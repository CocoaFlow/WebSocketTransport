//
//  WebSocketTransport.swift
//  WebSocketTransport
//
//  Created by Paul Young on 28/08/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

import Transport
import JSONLib

public struct WebSocketTransport: Transport {

    public init() {}
    
    public func send(channel: String, _ topic: String, _ payload: JSON) {
        // FIXME
    }
}
