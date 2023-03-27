//
//  KeychainStorage.swift
//  UpcomingMoviesData
//
//  Created by LEMIN DAHOVICH on 08.12.2022.
//

import Foundation

@propertyWrapper
public struct KeychainWrapper<T> {
    
    private let key: String
    private let keychain = KeychainService()
    
    public init(key: String) {
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
                fatalError("Unsupported type")
            }
        }
        set {
            switch newValue {
            case let newValue as String?:
                if let value = newValue {
                    keychain.setString(value, forKey: key)
                } else {
                    keychain.delete(key)
                }
            case let newValue as Bool?:
                if let value = newValue {
                    keychain.setBool(value, forKey: key)
                } else {
                    keychain.delete(key)
                }
            case let newValue as Data?:
                if let value = newValue {
                    keychain.setData(value, forKey: key)
                } else {
                    keychain.delete(key)
                }
            default:
                fatalError("Unsupported type")
            }
        }
    }
}
