//
//  LiveProfileRepositoryTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import DataProviders
import XCTest

final class LiveProfileRepositoryTests: XCTestCase {
    func test_fetchCurrentUserProfile_returnsProfileFromStoredSession() async throws {
        let expectedUser = UserProfile(
            id: "profile-user",
            displayName: "Taylor Architect",
            emailAddress: "architect@example.com"
        )
        let store = InMemoryProfileSessionStore(
            session: AuthSession(
                token: "token",
                user: expectedUser,
                issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
            )
        )
        let repository = LiveProfileRepository(sessionStore: store)

        let profile = try await repository.fetchCurrentUserProfile()

        XCTAssertEqual(profile, expectedUser)
    }

    func test_fetchCurrentUserProfile_throwsWhenSessionIsMissing() async {
        let repository = LiveProfileRepository(
            sessionStore: InMemoryProfileSessionStore(session: nil)
        )

        do {
            _ = try await repository.fetchCurrentUserProfile()
            XCTFail("Expected missing session error")
        } catch let error as AuthenticationError {
            XCTAssertEqual(error, .missingSession)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

private actor InMemoryProfileSessionStore: SessionStoring {
    private var session: AuthSession?

    init(session: AuthSession?) {
        self.session = session
    }

    func save(session: AuthSession) async throws {
        self.session = session
    }

    func loadSession() async throws -> AuthSession? {
        session
    }

    func clearSession() async throws {
        session = nil
    }
}
