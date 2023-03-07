//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 04.03.2023.
//

import Foundation
import Security

open class KeychainService {
    
    public var queryParametersOfLastOperation: [String: Any]?
    public var resultCodeOfLastOperation: OSStatus = noErr
    public var accessGroup: String?
    public var isSynchronizable = false
    
    private let lock = NSLock()
    public init() { }
    
    @discardableResult
    open func setString(_ value: String, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
        do {
            guard let valueData = value.data(using: .utf8) else {
                throw KeychainError.encodingError(statusCode: -1)
            }
            return setData(valueData, forKey: key, withAccessibility: accessibility)
        } catch {
            print(error.localizedDescription)
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
                let error = KeychainError.decodingError(statusCode: -67853)
                throw error
            }
            return currentString
        } catch {
            print(error.localizedDescription)
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
                throw KeychainError.securityError(statusCode: resultCodeOfLastOperation)
            }
            return true
        } catch {
            print(error.localizedDescription)
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
                throw KeychainError.securityError(statusCode: resultCodeOfLastOperation)
            }
            return result as? Data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    @discardableResult
    open func setBool(_ value: Bool, forKey key: String, withAccessibility accessibility: Accessibility = .whenUnlocked) -> Bool {
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
                throw KeychainError.noDataError
            default:
                throw KeychainError.securityError(statusCode: resultCodeOfLastOperation)
            }
        } catch {
            return false
        }
    }
    
    @discardableResult
    open func clear() -> Bool {
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
    
    open func allKeys() -> [String] {
        var query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecReturnAttributes as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitAll
        ]
        
        addAccessGroupWhenPresent(&query)
        addSynchronizableIfRequired(&query)
        
        var result: AnyObject?
        var keys = [String]()
        do {
            resultCodeOfLastOperation = withUnsafeMutablePointer(to: &result) {
                SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
            }
            
            guard resultCodeOfLastOperation == noErr else {
                throw KeychainError.securityError(statusCode: resultCodeOfLastOperation)
            }
            
            if let items = result as? [[String: Any]] {
                for item in items {
                    if let key = item[kSecAttrAccount as String] as? String {
                        keys.append(key)
                    }
                }
            }
        } catch {
            print("Error retrieving all keys from Keychain: \(error)")
        }
        
        return keys
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
