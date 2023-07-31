//
//  KeyChainModel.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/31.
//

import Foundation

class KeyChainModel: ObservableObject {
    
    let SERVICE = "StayWatchBeaconForiOS"
    let ACCOUNT = "stayer"
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    func save(
        token: String
    ) throws {
        // service, account, password, class, data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SERVICE as AnyObject,
            kSecAttrAccount as String: ACCOUNT as AnyObject,
            kSecValueData as String: token.data(using: .utf8) as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // 既に保存されている場合更新（削除、新規作成する）
        guard status != errSecDuplicateItem else {
            SecItemDelete(query as CFDictionary)
            print("keychainを削除したどん")
            SecItemAdd(query as CFDictionary, nil)
            print("keychainを更新したドン")
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saveしたどん")
    }
    
    func get() -> Data? {
        // service, account, password, class, data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SERVICE as AnyObject,
            kSecAttrAccount as String: ACCOUNT as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(
            query as CFDictionary,
            &result
        )
        
        print("getした Read status: \(status)")
        
        return result as? Data
    }
    
    func delete() throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: SERVICE as AnyObject,
            kSecAttrAccount as String: ACCOUNT as AnyObject,
        ]
        
        // データの削除を試みる
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
        
        print("deleteしたどん")
    }
}
