//
//  LiveAuthenticationRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Foundation

public struct LiveAuthenticationRepository: LoginPerformingRepository, SessionReadingRepository, SessionClearingRepository, Sendable {
    private let sessionStore: any SessionStoring
    private let validCredentials: Credentials
    private let demoUser: UserProfile

    public init(
        sessionStore: any SessionStoring,
        validCredentials: Credentials = Credentials(
            username: "architect@example.com",
            password: "clean-swift"
        ),
        demoUser: UserProfile = UserProfile(
            id: "primary-user",
            displayName: "Taylor Architect",
            emailAddress: "architect@example.com"
        )
    ) {
        self.sessionStore = sessionStore
        self.validCredentials = validCredentials
        self.demoUser = demoUser
    }

    public func login(with credentials: Credentials) async throws -> AuthSession {
        guard credentials == validCredentials else {
            throw AuthenticationError.invalidCredentials
        }

        let session = AuthSession(
            token: "mock-session-token",
            user: demoUser,
            issuedAt: Date()
        )
        try await sessionStore.save(session: session)
        return session
    }

    public func loadSession() async throws -> AuthSession? {
        try await sessionStore.loadSession()
    }

    public func clearSession() async throws {
        try await sessionStore.clearSession()
    }
}
