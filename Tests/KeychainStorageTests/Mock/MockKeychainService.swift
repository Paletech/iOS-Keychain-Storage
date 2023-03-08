//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 08.03.2023.
//

import KeychainStorage
import Foundation

class MockKeychainService: KeychainService {
    
    var storedData: [String: Data] = [:]
    
    override func setString(_ value: String, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        if let data = value.data(using: .utf8) {
            storedData[key] = data
            return true
        } else {
            return false
        }
    }
    
    override func getString(_ key: String) -> String? {
        return storedData[key].flatMap { String(data: $0, encoding: .utf8) }
    }
    
    override func setData(_ value: Data, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        storedData[key] = value
        return true
    }
    
    override func getData(_ key: String) -> Data? {
        return storedData[key]
    }
    
    override func delete(_ key: String) -> Bool {
        storedData.removeValue(forKey: key) != nil
    }
    
    override func clear() -> Bool {
        storedData.removeAll()
        return true
    }
    
    override func allKeys() -> [String] {
        return Array(storedData.keys)
    }
}
