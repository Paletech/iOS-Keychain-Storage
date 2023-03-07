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
    case securityError(statusCode: OSStatus)
}

extension KeychainError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .decodingError:
            return NSLocalizedString("Problem occured in decoding task", comment: "")
        case .encodingError(statusCode: let statusCode):
            return NSLocalizedString("Problem occured in encoding task. Code: \(statusCode)", comment: "")
        case .noDataError:
            return NSLocalizedString("No data found", comment: "")
        case .securityError(statusCode: let statusCode):
            return NSLocalizedString("SecurityError: \(statusCode)", comment: "")
        }
    }
}
