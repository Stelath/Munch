//
//  SSEService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//
// Munch/Services/SSE/SSEService.swift

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
        sessionConfig.timeoutIntervalForRequest = .infinity
        sessionConfig.timeoutIntervalForResource = .infinity

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
        guard let eventString = String(data: data, encoding: .utf8) else { return }

        let events = parseEventString(eventString)
        for event in events {
            eventHandler?(event.name, event.data)
        }
    }

    private func parseEventString(_ eventString: String) -> [(name: String, data: String?)] {
        var events: [(name: String, data: String?)] = []
        var currentEventName = "message"
        var currentData = ""

        let lines = eventString.components(separatedBy: .newlines)
        for line in lines {
            if line.hasPrefix("event:") {
                currentEventName = line.replacingOccurrences(of: "event: ", with: "")
            } else if line.hasPrefix("data:") {
                let dataLine = line.replacingOccurrences(of: "data: ", with: "")
                currentData += dataLine + "\n"
            } else if line.isEmpty {
                if !currentData.isEmpty {
                    events.append((name: currentEventName, data: currentData.trimmingCharacters(in: .whitespacesAndNewlines)))
                    currentData = ""
                    currentEventName = "message"
                }
            }
        }
        return events
    }

    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        if let error = error {
            print("SSE session invalidated with error: \(error.localizedDescription)")
        } else {
            print("SSE session invalidated")
        }
        // attempt to reconnect
        if let url = url, let eventHandler = eventHandler {
            startListening(url: url, eventHandler: eventHandler)
        }
    }
}
