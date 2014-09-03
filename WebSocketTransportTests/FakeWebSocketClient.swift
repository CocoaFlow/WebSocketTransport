//
//  FakeWebSocketClient.swift
//  WebSocketTransport
//
//  Created by Paul Young on 02/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

class FakeWebSocketClient: NSObject, SRWebSocketDelegate {
    
    private let webSocket: SRWebSocket
    
    typealias Handler = (webSocket: FakeWebSocketClient) -> Void
    let didOpenHandler: Handler
    
    init(didOpenHandler: Handler) {
        let url = NSURL.URLWithString("ws://localhost:3569")
        self.webSocket = SRWebSocket(URL: url)
        self.didOpenHandler = didOpenHandler
        super.init()
        self.webSocket.delegate = self
        self.webSocket.open()
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        // TODO
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        self.didOpenHandler(webSocket: self)
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        if (error != nil) {
            println(error)
        }
    }
    
    func send(data: String) {
        self.webSocket.send(data)
    }
    
    func close() {
        self.webSocket.close()
    }
}
