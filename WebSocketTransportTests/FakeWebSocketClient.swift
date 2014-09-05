//
//  FakeWebSocketClient.swift
//  WebSocketTransport
//
//  Created by Paul Young on 02/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

class FakeWebSocketClient: NSObject, SRWebSocketDelegate {
    
    private let webSocket: SRWebSocket
    
    typealias WebSocketDidOpenHandler = (webSocket: FakeWebSocketClient) -> Void
    typealias WebSocketDidReceiveMessageHandler = (message: AnyObject!) -> Void
    
    let webSocketDidOpenHandler: WebSocketDidOpenHandler
    let webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler
    
    init(webSocketDidOpenHandler: WebSocketDidOpenHandler = { (webSocket) in }, webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler = { (message) in } ) {
        let url = NSURL.URLWithString("ws://localhost:3569")
        self.webSocket = SRWebSocket(URL: url)
        self.webSocketDidOpenHandler = webSocketDidOpenHandler
        self.webSocketDidReceiveMessageHandler = webSocketDidReceiveMessageHandler
        super.init()
        self.webSocket.delegate = self
        self.webSocket.open()
    }
    
    func webSocketDidOpen(webSocket: SRWebSocket!) {
        self.webSocketDidOpenHandler(webSocket: self)
    }
    
    func webSocket(webSocket: SRWebSocket!, didFailWithError error: NSError!) {
        if (error != nil) {
            println(error)
        }
    }
    
    func webSocket(webSocket: SRWebSocket!, didReceiveMessage message: AnyObject!) {
        self.webSocketDidReceiveMessageHandler(message: message)
    }
    
    func send(data: String) {
        self.webSocket.send(data)
    }
    
    func close() {
        self.webSocket.close()
    }
}
