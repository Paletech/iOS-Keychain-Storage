//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 04.03.2023.
//

import Foundation
import Security

final public class KeychainService {
    
    public var queryParametersOfLastOperation: [String: Any]?
    public var resultCodeOfLastOperation: OSStatus = noErr
    public var accessGroup: String?
    public var isSynchronizable = false
    
    private let lock = NSLock()
    public init() { }
    
    @discardableResult
    public func setString(_ value: String, forKey key: String,
                          withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        guard let valueData = value.data(using: .utf8) else { return false }
        return setData(valueData, forKey: key, withAccessibility: accessibility)
    }
    
    public func getString(_ key: String) -> String? {
        lock.lock()
            defer { lock.unlock() }
            guard let data = getData(key),
                  let currentString = String(data: data, encoding: .utf8) else {
                resultCodeOfLastOperation = -67853
                return nil
            }
            return currentString
        
    }
    
    @discardableResult
    public func setData(_ value: Data, forKey key: String,
                        withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        delete(key)
        
        let accessible = accessibility.value
        var query = query(withKey: key)
        query[kSecValueData as String] = value
        query[kSecAttrAccessible as String] = accessible
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        queryParametersOfLastOperation = query
        resultCodeOfLastOperation = SecItemAdd(query as CFDictionary, nil)
        
        return resultCodeOfLastOperation == noErr
    }
    
    public func getData(_ key: String) -> Data? {
        var query = query(withKey: key)
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        queryParametersOfLastOperation = query
        var result: AnyObject?
        resultCodeOfLastOperation = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        return resultCodeOfLastOperation == noErr ? result as? Data : nil
    }
    
    @discardableResult
    public func setBool(_ value: Bool, forKey key: String,
                        withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        let valueData = value ? Data([1]) : Data([0])
        return setData(valueData, forKey: key, withAccessibility: accessibility)
    }
    
    public func getBool(_ key: String) -> Bool? {
        guard let data = getData(key) else { return nil }
        return data.first == 1 ? true : false
    }
    
    @discardableResult
    public func delete(_ key: String) -> Bool {
        var query = self.query(withKey: key)
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        queryParametersOfLastOperation = query
        resultCodeOfLastOperation = SecItemDelete(query as CFDictionary)
        
        return resultCodeOfLastOperation == errSecSuccess
    }
    
    @discardableResult
    public func clear() -> Bool {
        lock.lock()
            defer { lock.unlock() }
            var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
            
            if let accessGroup = accessGroup {
                query[kSecAttrAccessGroup as String] = accessGroup
            }
            
            if isSynchronizable {
                query[kSecAttrSynchronizable as String] = kCFBooleanTrue
            }
            
            queryParametersOfLastOperation = query
            resultCodeOfLastOperation = SecItemDelete(query as CFDictionary)
            
            return resultCodeOfLastOperation == noErr
    }
    
    private func query(withKey key: String) -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String      : kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
        
        if isSynchronizable {
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue
        }
        
        return query
    }
    
    private func addAccessGroupWhenPresent(_ query: inout [String: Any]) {
        if let accessGroup = accessGroup {
            query[kSecAttrAccessGroup as String] = accessGroup
        }
    }
    
    private func addSynchronizableIfRequired(_ query: inout [String: Any]) {
        if isSynchronizable {
            query[kSecAttrSynchronizable as String] = kCFBooleanTrue
        }
    }
}
