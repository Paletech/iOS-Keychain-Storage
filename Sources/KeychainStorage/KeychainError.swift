//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 07.03.2023.
//

import Foundation

public enum KeychainError: Error {
    case decodingError(statusCode: OSStatus)
    case encodingError(statusCode: OSStatus)
    case noDataError
    case noDataToDeleteError
    case securityError(statusCode: OSStatus)
    case noKeysData(statusCode: OSStatus)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError(statusCode: let statusCode):
            return NSLocalizedString("Decoding task failed in the Keychain. Code: \(statusCode)", comment: "")
        case .encodingError(statusCode: let statusCode):
            return NSLocalizedString("Encoding task failed in the Keychain. Code: \(statusCode)", comment: "")
        case .noDataError:
            return NSLocalizedString("No data found by provided key in the Keychain", comment: "")
        case .securityError(statusCode: let statusCode):
            return NSLocalizedString("SecurityError in the Keychain. Check your entitlements. Code:  \(statusCode)", comment: "")
        case .noKeysData(statusCode: let statusCode):
            return NSLocalizedString("Error retrieving all keys from Keychain. Keychain is empty: \(statusCode)", comment: "")
        case .noDataToDeleteError:
            return NSLocalizedString("No data to delete by this provided key", comment: "")
        }
    }
}

struct KeychainErrorCodes {
    static let encodingError: OSStatus = -1
    static let decodingError: OSStatus = -67853
    static let noKeysData: OSStatus = -25307
    static let securityError: OSStatus = -34018
}
