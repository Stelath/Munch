//
//  CircleService.swift
//  Munch
//
//  Created by Mac Howe on 10/14/24.
//

import Foundation
import Combine

class CircleService {
    func createCircle(name: String) -> AnyPublisher<Circle, Error> {
        let endpoint = Endpoint.createCircle(name: name)
        return APIClient.shared.request(endpoint)
    }
    
    func joinCircle(code: String) -> AnyPublisher<Circle, Error> {
        let endpoint = Endpoint.joinCircle(code: code)
        return APIClient.shared.request(endpoint)
    }

//    func startCircle(circleId: String) -> AnyPublisher<Void, Error> {
//        let endpoint = Endpoint.startCircle(circleId: circleId)
//        return APIClient.shared.request(endpoint)
//            .map { _ in () }  // Mapping the response to Void
//            .eraseToAnyPublisher()
//    }
}
