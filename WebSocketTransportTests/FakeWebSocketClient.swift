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
    
    private let webSocketDidConnectHandler: WebSocketDidConnectHandler?
    private let webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler?
    
    init(webSocketDidConnectHandler: WebSocketDidConnectHandler?, webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler?) {
        let url = NSURL.URLWithString("ws://localhost:3569")
        self.webSocket = Websocket(url: url)
        super.init()
        webSocket.headers = ["Sec-WebSocket-Protocol": ""]
        self.webSocketDidConnectHandler = webSocketDidConnectHandler
        self.webSocketDidReceiveMessageHandler = webSocketDidReceiveMessageHandler
        println(self.webSocketDidReceiveMessageHandler)
        self.webSocket.delegate = self
        self.webSocket.connect()
    }
    
    convenience init(webSocketDidConnectHandler: WebSocketDidConnectHandler) {
        self.init(webSocketDidConnectHandler, nil)
    }
    
    convenience init(webSocketDidReceiveMessageHandler: WebSocketDidReceiveMessageHandler) {
        println(webSocketDidReceiveMessageHandler)
        self.init(nil, webSocketDidReceiveMessageHandler)
    }
    
    func send(message: String) {
        self.webSocket.writeString(message)
    }
    
    func disconnect() {
        self.webSocket.disconnect()
    }
    
    // MARK: - WebsocketDelegate
    
    func websocketDidConnect() {
        if let handler = self.webSocketDidConnectHandler {
            handler(webSocket: self)
        }
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
        println(text)
        println (self.webSocketDidReceiveMessageHandler)
        if let handler = self.webSocketDidReceiveMessageHandler {
            handler(message: text)
        }
    }
    
    func websocketDidReceiveData(data: NSData) {}
}
