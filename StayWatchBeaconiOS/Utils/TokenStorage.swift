//
//  KeyChainHelper.swift
//  StayWatchBeaconiOS
//
//  Created by 戸川浩汰 on 2023/07/12.
//

import Foundation

class TokenStorage: ObservableObject {
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    func save(
        service: String,
        account: String,
        token: Data
    ) throws {
        // service, account, password, class, data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecValueData as String: token as AnyObject,
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // 既に保存されている場合更新
        guard status != errSecDuplicateItem else {
            let attributes: [String: AnyObject] = [
                kSecValueData as String: token as AnyObject
            ]
            SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            print("updateしたどん")
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saveしたどん")
    }
    
    func get(
        service: String,
        account: String
    ) -> Data? {
        // service, account, password, class, data
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
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
    
    func delete(
        service: String,
        account: String
    ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
        ]
        
        // データの削除を試みる
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unknown(status)
        }
        
        print("deleteしたどん")
    }
}
