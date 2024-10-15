//
//  SSEService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation

class SSEService: NSObject {
    private var task: URLSessionDataTask?
    private var eventHandler: ((String, String?) -> Void)?
    private var urlSession: URLSession?
    private var url: URL?

    func startListening(url: URL, eventHandler: @escaping (String, String?) -> Void) {
        self.url = url
        self.eventHandler = eventHandler
        let sessionConfig = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = TimeInterval(INT_MAX)
        sessionConfig.timeoutIntervalForResource = TimeInterval(INT_MAX)
        urlSession = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        task = urlSession?.dataTask(with: request)
        task?.resume()
    }

    func stopListening() {
        task?.cancel()
        task = nil
        eventHandler = nil
        urlSession = nil
    }
}

extension SSEService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        // Parse the SSE data
        guard let eventString = String(data: data, encoding: .utf8) else { return }

        let lines = eventString.components(separatedBy: .newlines)
        var eventName: String?
        var eventData: String?

        for line in lines {
            if line.hasPrefix("event:") {
                eventName = line.replacingOccurrences(of: "event: ", with: "")
            } else if line.hasPrefix("data:") {
                let dataLine = line.replacingOccurrences(of: "data: ", with: "")
                if let existingData = eventData {
                    eventData = existingData + "\n" + dataLine
                } else {
                    eventData = dataLine
                }
            }
        }

        if let eventName = eventName {
            eventHandler?(eventName, eventData)
        } else if let eventData = eventData {
            eventHandler?("message", eventData)
        }
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        // Handle session invalidation
        if let error = error {
            print("SSE session invalidated with error: \(error.localizedDescription)")
        } else {
            print("SSE session invalidated")
        }
        // Attempt to reconnect
        if let url = url, let eventHandler = eventHandler {
            startListening(url: url, eventHandler: eventHandler)
        }
    }
}
