//
//  AuthenticationRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol LoginPerformingRepository: Sendable {
    func login(with credentials: Credentials) async throws -> AuthSession
}

public protocol SessionReadingRepository: Sendable {
    func loadSession() async throws -> AuthSession?
}

public protocol SessionClearingRepository: Sendable {
    func clearSession() async throws
}
