//
//  FakeWebSocketClient.swift
//  WebSocketTransport
//
//  Created by Paul Young on 02/09/2014.
//  Copyright (c) 2014 CocoaFlow. All rights reserved.
//

class FakeWebSocketClient: NSObject, WebsocketDelegate {
    
    private let webSocket: Websocket
    
    typealias WebSocketDidConnectHandler = (webSocket: FakeWebSocketClient) -> Void
    typealias WebSocketDidReceiveMessageHandler = (message: String) -> Void
    
    let webSocketDidConnectHandler: WebSocketDidConnectHandler
    let webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler
    
    init(webSocketDidConnectHandler: WebSocketDidConnectHandler = { (webSocket) in }, webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler = { (message) in } ) {
        let url = NSURL.URLWithString("ws://localhost:3569")
        self.webSocket = Websocket(url: url)
        self.webSocketDidConnectHandler = webSocketDidConnectHandler
        self.webSocketDidReceiveMessageHandler = webSocketDidReceiveMessageHandler
        super.init()
        self.webSocket.delegate = self
        self.webSocket.connect()
    }
    
    func send(message: String) {
        self.webSocket.writeString(message)
    }
    
    func disconnect() {
        self.webSocket.disconnect()
    }
    
    // MARK: - WebsocketDelegate
    
    func websocketDidConnect() {
        self.webSocketDidConnectHandler(webSocket: self)
    }
    
    func websocketDidDisconnect(error: NSError?) {
        if let maybeError = error {
            println(error)
        }
    }
    
    func websocketDidWriteError(error: NSError?) {
        if let maybeError = error {
            println(error)
        }
    }
    
    func websocketDidReceiveMessage(text: String) {
        self.webSocketDidReceiveMessageHandler(message: text)
    }
    
    func websocketDidReceiveData(data: NSData) {}
}
