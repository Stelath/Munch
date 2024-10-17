//
//  ID.swift
//  Munch
//
//  Created by Alexander Korte on 10/16/24.
//


import Foundation
import CryptoKit

func generateDummyID() -> String {
    // Get the current timestamp (4 bytes)
    var timestamp = UInt32(Date().timeIntervalSince1970).bigEndian
    var objectIdData = Data()
    objectIdData.append(Data(bytes: &timestamp, count: 4))
    
    // Generate 5 random bytes for the machine identifier
    let randomBytes = [UInt8](randomBytes(count: 5))
    objectIdData.append(contentsOf: randomBytes)
    
    // Generate 3 bytes counter (use random values to simplify)
    var counter = UInt32.random(in: 0...0xFFFFFF).bigEndian
    objectIdData.append(Data(bytes: &counter, count: 3))
    
    // Convert to a hex string
    return objectIdData.map { String(format: "%02x", $0) }.joined()
}

func randomBytes(count: Int) -> [UInt8] {
    var bytes = [UInt8](repeating: 0, count: count)
    let result = SecRandomCopyBytes(kSecRandomDefault, count, &bytes)
    precondition(result == errSecSuccess, "Error generating random bytes")
    return bytes
}

