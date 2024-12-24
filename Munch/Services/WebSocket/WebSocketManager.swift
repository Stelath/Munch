//
//  WebSocketManager.swift
//  Munch
//
//  Created by Mac on 12/23/2024
//

import Foundation
import Combine

/// An enum to represent messages from the server.
/// Adjust the structure to match your actual event payloads.
enum MunchWebSocketEvent {
    case userJoined(user: User)
    case circleStarted(circleId: String)
    case voteUpdated(RestaurantVoteResult)
    case unknown(raw: String)
}

/// A single shared manager that maintains one WebSocket connection for the whole app.
@MainActor
final class WebSocketManager: ObservableObject {
    
    // MARK: - Public Publishers
    /// Any VM can subscribe to this publisher to receive WebSocket events.
    let eventPublisher = PassthroughSubject<MunchWebSocketEvent, Never>()
    
    // MARK: - Private State
    private var webSocketTask: URLSessionWebSocketTask?
    private var session: URLSession?
    private var isConnected: Bool = false
    private var baseURL: URL
    
    
    
    // MARK: - Init
    /// You can pass a base URL or environment-based URL if needed.
    init(baseURL: URL = URL(string: "ws://localhost:3000")!) {
        self.baseURL = baseURL
    }
    
    // MARK: - Public Methods
    
    /// Connect once for the entire app. If already connected, do nothing.
    func connect() {
        guard !isConnected else { return }
        
        // Adjust path as needed: if your server expects ws://host:3000/socket
        let socketURL = baseURL.appendingPathComponent("socket")
        
        let request = URLRequest(url: socketURL)
        let config = URLSessionConfiguration.default
        
        // If you have token-based auth, set request headers here:
        // request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        // Create our URLSession
        session = URLSession(configuration: config)
        
        // Create a WebSocket task
        webSocketTask = session?.webSocketTask(with: request)
        webSocketTask?.resume()
        isConnected = true
        
        // Start listening
        receiveMessages()
        
        print("[WebSocketManager] Connected to \(socketURL.absoluteString)")
    }
    
    /// Disconnect the socket, e.g., on sign-out or app shutdown.
    func disconnect() {
        guard isConnected else { return }
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        webSocketTask = nil
        session = nil
        isConnected = false
        
        print("[WebSocketManager] Disconnected")
    }
    
    func retryConnection() async{
        let time = 1
        try? await Task.sleep(nanoseconds: UInt64(time * 1_000_000_000))
        disconnect()
        connect()
        
    }
    
    /// Send a message to the server, if needed.
    func send(_ message: String) async throws {
        guard let webSocketTask else {
            throw NSError(domain: "MunchWebSocketManager", code: -1, userInfo: [
                NSLocalizedDescriptionKey: "WebSocket not connected"
            ])
        }
        try await webSocketTask.send(.string(message))
    }
    
    // MARK: - Private Methods
    
    /// Continuously receive messages from the WebSocket.
    private func receiveMessages() {
        guard let webSocketTask else { return }

        webSocketTask.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("[WebSocketManager] Error receiving message: \(error.localizedDescription)")
                
                Task { @MainActor in
                    await self.retryConnection()
                }
                
            case .success(let message):
                Task { @MainActor [weak self] in
                    guard let self = self else { return }
                    switch message {
                    case .string(let text):
                        // Parse the incoming JSON text into typed events
                        self.handleIncomingText(text)
                    case .data(let data):
                        // If your server sends binary data, handle it here
                        if let text = String(data: data, encoding: .utf8) {
                            self.handleIncomingText(text)
                        }
                    @unknown default:
                        break
                    }
                }
            }
            
            // Keep listening
            Task { @MainActor in
                if self.isConnected {
                    self.receiveMessages()
                }
            }
        }
    }
    
    /// Parse JSON text from the server into a known event, then publish it.
    private func handleIncomingText(_ text: String) {
        guard let data = text.data(using: .utf8) else { return }
        
        do {
            // Suppose the server always wraps events in JSON with "event" and "data" fields, e.g.:
            // {"event":"user_joined","data":{"userID":"123", "userName":"Alice"}}
            if let jsonObj = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let eventName = jsonObj["event"] as? String,
               let eventData = jsonObj["data"] {
                
                switch eventName {
                case "user_joined":
                    if let dict = eventData as? [String: Any],
                       let userID = dict["userID"] as? String,
                       let userName = dict["userName"] as? String {
                        let newUser = User(id: userID, name: userName)
                        eventPublisher.send(.userJoined(user: newUser))
                    }
                    
                case "circle_started":
                    if let dict = eventData as? [String: Any],
                       let circleId = dict["circleId"] as? String {
                        eventPublisher.send(.circleStarted(circleId: circleId))
                    }
                    
                case "vote_updated":
                    // If the server sends the entire RestaurantVoteResult object as "data"
                    let nestedData = try JSONSerialization.data(withJSONObject: eventData)
                    let decoded = try JSONDecoder().decode(RestaurantVoteResult.self, from: nestedData)
                    eventPublisher.send(.voteUpdated(decoded))
                    
                default:
                    // Unknown or unhandled event
                    eventPublisher.send(.unknown(raw: text))
                }
                
            } else {
                // If there's no "event" field, treat as unknown
                eventPublisher.send(.unknown(raw: text))
            }
        } catch {
            print("[WebSocketManager] Failed to parse incoming message: \(error.localizedDescription)")
            eventPublisher.send(.unknown(raw: text))
        }
    }
}
