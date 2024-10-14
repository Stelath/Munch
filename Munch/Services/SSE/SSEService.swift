//
//  SSEService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine

class SSEService {
    private var eventSourceTask: URLSessionDataTask?
//    var voteUpdates = PassthroughSubject<VoteUpdate, Never>()
    
//    func startListening(to url: URL) {
//        var request = URLRequest(url: url)
//        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
//        
//        eventSourceTask = URLSession.shared.dataTask(with: request) { [weak self] data, _, _ in
//            guard let self = self, let data = data else { return }
//            if let eventString = String(data: data, encoding: .utf8),
//               let update = self.parseVoteUpdate(eventString) {
//                self.voteUpdates.send(update)
//            }
//        }
//        eventSourceTask?.resume()
//    }
//    
//    func stopListening() {
//        eventSourceTask?.cancel()
//    }
//
//    private func parseVoteUpdate(_ eventString: String) -> VoteUpdate? {
//        // Implement logic to parse the event data and convert it to VoteUpdate model
//        return nil
//    }
}
