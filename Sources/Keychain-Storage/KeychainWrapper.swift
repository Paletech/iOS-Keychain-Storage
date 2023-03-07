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
        get {
            switch T.self {
            case is Bool.Type:
                return keychainOperation {
                    try keychain.getBool(key) as? T
                }
            case is String.Type:
                return keychainOperation {
                    try keychain.getString(key) as? T
                }
            case is Data.Type:
                return keychainOperation {
                    try keychain.getData(key) as? T
                }
            default:
                fatalError("Unsupported value type")
            }
        }
        set {
            keychainOperation {
                switch newValue {
                case let newValue as String:
                    try keychain.setString(newValue, forKey: key)
                case let newValue as Bool:
                    try keychain.setBool(newValue, forKey: key)
                case let newValue as Data:
                    try keychain.setData(newValue, forKey: key)
                default:
                    fatalError("Unsupported value type")
                }
            }
        }
    }
    
    private func keychainOperation<U>(_ operation: () throws -> U?) -> U? {
        do {
            return try operation()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
