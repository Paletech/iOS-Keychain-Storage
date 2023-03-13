//
//  File.swift
//
//
//  Created by LEMIN DAHOVICH on 07.03.2023.
//

import Foundation

public enum Accessibility {
    case firstUnlock
    case firstUnlockThisDeviceOnly
    case whenUnlocked
    case whenUnlockedThisDeviceOnly
    case afterFirstUnlock
    case afterPasscodeSetThisDeviceOnly
    
    var value: CFString {
        switch self {
        case .firstUnlock:
            return kSecAttrAccessibleAfterFirstUnlock
        case .firstUnlockThisDeviceOnly:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .whenUnlocked:
            return kSecAttrAccessibleWhenUnlocked
        case .whenUnlockedThisDeviceOnly:
            return kSecAttrAccessibleWhenUnlockedThisDeviceOnly
        case .afterFirstUnlock:
            return kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        case .afterPasscodeSetThisDeviceOnly:
            return kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly
        }
    }
}
