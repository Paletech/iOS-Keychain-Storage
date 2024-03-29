//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 04.03.2023.
//

import Foundation
import OSLog
import Security

open class KeychainService {
    
    public var queryParametersOfLastOperation: [String: Any]?
    public var resultCodeOfLastOperation: OSStatus = noErr
    public var accessGroup: String?
    public var isSynchronizable = false
    
    private let lock = NSLock()
    
    public init() { }
    
    @discardableResult
    open func setString(_ value: String, forKey key: String,
                        withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        do {
            guard let valueData = value.data(using: .utf8) else {
                throw KeychainError.encodingError(statusCode: KeychainErrorCodes.encodingError)
            }
            return setData(valueData, forKey: key, withAccessibility: accessibility)
        } catch {
            os_log("%s", error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    open func getString(_ key: String) -> String? {
        lock.lock()
        defer { lock.unlock() }
        
        do {
            guard let data = getData(key) else { return nil }
            guard let currentString = String(data: data, encoding: .utf8) else {
                let error = KeychainError.decodingError(statusCode: KeychainErrorCodes.decodingError)
                throw error
            }
            return currentString
        } catch {
            os_log("%s", error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    open func setData(_ value: Data, forKey key: String,
                      withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        do {
            delete(key)
            
            let accessible = accessibility.value
            var query = query(withKey: key)
            query[kSecValueData as String] = value
            query[kSecAttrAccessible as String] = accessible
            addAccessGroupWhenPresent(&query)
            addSynchronizableIfRequired(&query)
            
            queryParametersOfLastOperation = query
            resultCodeOfLastOperation = SecItemAdd(query as CFDictionary, nil)
            
            guard resultCodeOfLastOperation == noErr else {
                throw KeychainError.securityError(statusCode: KeychainErrorCodes.securityError)
            }
            return true
        } catch {
            os_log("%s", error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    open func getData(_ key: String) -> Data? {
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
        
        do {
            guard resultCodeOfLastOperation == noErr else {
                throw KeychainError.noDataError
            }
            return result as? Data
        } catch {
            os_log("%s", error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    open func setBool(_ value: Bool, forKey key: String,
                      withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        let valueData = value ? Data([1]) : Data([0])
        return setData(valueData, forKey: key, withAccessibility: accessibility)
    }
    
    @discardableResult
    open func getBool(_ key: String) -> Bool? {
        guard let data = getData(key) else { return nil }
        return data.first == 1 ? true : false
    }
    
    @discardableResult
    open func delete(_ key: String) -> Bool {
        var query = query(withKey: key)
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        queryParametersOfLastOperation = query
        resultCodeOfLastOperation = SecItemDelete(query as CFDictionary)
        
        do {
            switch resultCodeOfLastOperation {
            case noErr:
                return true
            case errSecItemNotFound:
                throw KeychainError.noDataToDeleteError
            default:
                throw KeychainError.securityError(statusCode: KeychainErrorCodes.securityError)
            }
        } catch {
            os_log("%s", error.localizedDescription)
            return false
        }
    }
    
    @discardableResult
    open func clear() -> Bool {
        lock.lock()
        defer { lock.unlock() }
        
        let keys = try? getItems(query: keychainQuery())
            .compactMap { $0[kSecAttrAccount as String] as? String }
        
        for key in keys ?? [] {
            delete(key)
        }
        
        return keys?.isEmpty == true
    }
    
    open func allKeys() -> [String] {
        var keys: [String] = []
        try? getItems(query: keychainQuery()).forEach { item in
            if let key = item[kSecAttrAccount as String] as? String {
                keys.append(key)
            }
        }
        
        return keys
    }
}

extension KeychainService {
    private func keychainQuery() -> [String: Any] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnAttributes as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        return query
    }
    
    private func getItems(query: [String: Any]) throws -> [[String: Any]] {
        var result: AnyObject?
        
        resultCodeOfLastOperation = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }
        
        guard resultCodeOfLastOperation == noErr else {
            throw KeychainError.noKeysData(statusCode: KeychainErrorCodes.noKeysData)
        }
        
        guard let items = result as? [[String: Any]] else {
            throw KeychainError.noDataError
        }
        
        return items
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
