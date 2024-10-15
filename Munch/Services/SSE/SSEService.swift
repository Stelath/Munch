//
//  SSEService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine

import Foundation
import Combine


class SSEService: NSObject, URLSessionDataDelegate {
    private var task: URLSessionDataTask?
    private var eventHandler: ((String) -> Void)?

    func startListening(url: URL, eventHandler: @escaping (String) -> Void) {
        self.eventHandler = eventHandler
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        task = session.dataTask(with: request)
        task?.resume()
    }

    func stopListening() {
        task?.cancel()
        task = nil
        eventHandler = nil
    }

    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let eventString = String(data: data, encoding: .utf8) {
            eventHandler?(eventString)
        }
    }
}

struct CircleUpdate: Decodable {
    let type: String
    let user: User
}
