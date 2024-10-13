////
////  CirclesAPIHandler.swift
////  Munch
////
////  Created by Alexander Korte on 7/23/24.
////
//
//class CirclesAPIHandler {
//    static let shared = APIHandler()
//    let baseURL = URL(string: "http://localhost:3000")!
//
//    private init() {}
//
//    // Get a circle by ID
//    func getCircle(by id: String, completion: @escaping (Result<Circle, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/circles/\(id)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                let circle = try JSONDecoder().decode(Circle.self, from: data)
//                completion(.success(circle))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    // Update a circle by ID
//    func updateCircle(by id: String, with updates: CirclePartialUpdate, completion: @escaping (Result<Circle, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/circles/\(id)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "PATCH"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            request.httpBody = try JSONEncoder().encode(updates)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                let updatedCircle = try JSONDecoder().decode(Circle.self, from: data)
//                completion(.success(updatedCircle))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    // Add user to a circle
//    func addUser(toCircle id: String, userID: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/circles/\(id)/join")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let requestBody = ["userID": userID]
//
//        do {
//            request.httpBody = try JSONEncoder().encode(requestBody)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let httpResponse = response as? HTTPURLResponse else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
//                return
//            }
//
//            if httpResponse.statusCode == 200 {
//                completion(.success(()))
//            } else {
//                completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to add user"])))
//            }
//        }.resume()
//    }
//
//    // Create a new circle
//    func createCircle(_ circle: Circle, completion: @escaping (Result<String, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/circles")
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        do {
//            request.httpBody = try JSONEncoder().encode(circle)
//        } catch {
//            completion(.failure(error))
//            return
//        }
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
//                   let id = json["id"] as? String {
//                    completion(.success(id))
//                } else {
//                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid response format"])))
//                }
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    // Get a code by value
//    func getCode(by value: String, completion: @escaping (Result<Code, Error>) -> Void) {
//        let url = baseURL.appendingPathComponent("/codes/\(value)")
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//
//            do {
//                let code = try JSONDecoder().decode(Code.self, from: data)
//                completion(.success(code))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//}
