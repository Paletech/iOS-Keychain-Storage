//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 04.03.2023.
//

import Foundation

@propertyWrapper
public struct KeychainWrapper<T> {
    
    private let key: String
    private lazy var keychain = KeychainService()
    
    init(key: String) {
        self.key = key
    }
    
    public var wrappedValue: T? {
        mutating get {
            switch T.self {
            case is Bool.Type:
                return keychain.getBool(key) as? T
            case is String.Type:
                return keychain.getString(key) as? T
            case is Data.Type:
                return keychain.getData(key) as? T
            default:
                fatalError("Unsupported value type")
            }
        }
        set {
            switch newValue {
            case let newValue as String:
                keychain.setString(newValue, forKey: key)
            case let newValue as Bool:
                keychain.setBool(newValue, forKey: key)
            case let newValue as Data:
                keychain.setData(newValue, forKey: key)
            default:
                fatalError("Unsupported value type")
            }
        }
    }
}
