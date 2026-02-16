//
//  KeychainManager.swift
//  Adelaide Prod
//
//  Created by Prit  on 04/02/26.
//


import Foundation
import Security

final class KeychainManager {
    static let shared = KeychainManager()
    
    private let service = "com.adelaideprod.helloalfred"
    
    private init() { }
    
    // MARK: - Save
    func save(key: String, value: String) {
        guard let data = value.data(using: .utf8) else {
            print("🔴 Failed to convert value to Data for key: \(key)")
            return
        }
        
        // First, delete any existing item
        delete(key: key)
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            print("✅ Successfully saved value for key: \(key)")
        } else {
            print("🔴 Failed to save value to Keychain for key: \(key), status: \(status)")
        }
    }
    
    // MARK: - Retrieve
    func retrieve(for key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status == errSecSuccess,
              let data = result as? Data,
              let value = String(data: data, encoding: .utf8) else {
            if status == errSecItemNotFound {
                print("⚠️ Value for key '\(key)' not found in Keychain")
            } else {
                print("🔴 Failed to retrieve value from Keychain for key: \(key), status: \(status)")
            }
            return nil
        }
        
        if value.isEmpty {
            print("⚠️ Value for key '\(key)' is empty")
        } else {
            print("✅ Successfully retrieved value for key: \(key)")
        }
        
        return value
    }
    
    // MARK: - Remove
    func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("🗑️ Successfully deleted key: \(key) from Keychain")
        } else if status == errSecItemNotFound {
            print("⚠️ Key: \(key) not found in Keychain (nothing to delete)")
        } else {
            print("🔴 Failed to delete key: \(key) from Keychain, status: \(status)")
        }
    }
    
    // MARK: - Clear All (Use with caution)
    func clearAll() {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess {
            print("🧹 All Keychain entries cleared for service: \(service)")
        } else if status == errSecItemNotFound {
            print("⚠️ No Keychain entries found for service: \(service)")
        } else {
            print("🔴 Failed to clear Keychain, status: \(status)")
        }
    }
}
