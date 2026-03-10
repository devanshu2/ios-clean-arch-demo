//
//  KeychainSessionStore.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Foundation
import Security

public actor KeychainSessionStore: SessionStoring {
    private let service: String
    private let account: String
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    public init(
        service: String,
        account: String = "auth-session"
    ) {
        self.service = service
        self.account = account
    }

    public func save(session: AuthSession) async throws {
        let data = try encoder.encode(session)
        let query = baseQuery()

        SecItemDelete(query as CFDictionary)

        var payload = query
        payload[kSecValueData as String] = data
        payload[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly

        let status = SecItemAdd(payload as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.unhandledStatus(status)
        }
    }

    public func loadSession() async throws -> AuthSession? {
        var query = baseQuery()
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = true

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)

        switch status {
        case errSecSuccess:
            guard let data = item as? Data else {
                throw KeychainError.invalidPayload
            }
            return try decoder.decode(AuthSession.self, from: data)
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unhandledStatus(status)
        }
    }

    public func clearSession() async throws {
        let status = SecItemDelete(baseQuery() as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.unhandledStatus(status)
        }
    }

    private func baseQuery() -> [String: Any] {
        [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
    }
}

public enum KeychainError: LocalizedError, Sendable, Equatable {
    case invalidPayload
    case unhandledStatus(OSStatus)

    public var errorDescription: String? {
        switch self {
        case .invalidPayload:
            return "The stored session payload is invalid."
        case .unhandledStatus(let status):
            return "Keychain operation failed with status \(status)."
        }
    }
}
