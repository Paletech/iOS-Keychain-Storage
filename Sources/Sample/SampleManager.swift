//
//  File.swift
//  
//
//  Created by LEMIN DAHOVICH on 07.03.2023.
//

import Foundation
import KeychainStorage

struct Keys {
    static let one = "Example1"
    static let two = "Example2"
}

public final class SampleManager {
    
    @KeychainWrapper(key: Keys.one)
    private var one: String?
    
    @KeychainWrapper(key: Keys.two)
    private var two: Bool?
    
    private let keychainService: KeychainService
    
    public init(keychainService: KeychainService = KeychainService()) {
        self.keychainService = keychainService
    }
}

extension SampleManager {
    public func delete(_ key: String) -> Bool {
        keychainService.delete(key)
    }
    
    public func allKeys() -> [String] {
        return keychainService.allKeys()
    }
    
    public func clear() -> Bool {
        keychainService.clear()
    }
    
    public func getString() -> String? {
        one
    }
    
    public func setString(_ string: String) {
        one = string
    }
    
    public func setBool(_ bool: Bool) {
        two = bool
    }
    
    public func getBool() -> Bool?{
        two
    }
}
