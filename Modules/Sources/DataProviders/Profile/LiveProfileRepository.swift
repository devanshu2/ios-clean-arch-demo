//
//  LiveProfileRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain

public struct LiveProfileRepository: UserProfileReadingRepository, Sendable {
    private let sessionStore: any SessionStoring

    public init(sessionStore: any SessionStoring) {
        self.sessionStore = sessionStore
    }

    public func fetchCurrentUserProfile() async throws -> UserProfile {
        guard let session = try await sessionStore.loadSession() else {
            throw AuthenticationError.missingSession
        }
        return session.user
    }
}
