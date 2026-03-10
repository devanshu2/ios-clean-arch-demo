//
//  LiveAuthenticationRepositoryTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import DataProviders
import XCTest

final class LiveAuthenticationRepositoryTests: XCTestCase {
    func test_login_persistsSessionIntoStore() async throws {
        let store = InMemorySessionStore()
        let repository = LiveAuthenticationRepository(sessionStore: store)

        let session = try await repository.login(
            with: Credentials(
                username: "architect@example.com",
                password: "clean-swift"
            )
        )

        let persisted = try await store.loadSession()
        XCTAssertEqual(persisted, session)
    }

    func test_login_rejectsInvalidCredentials() async {
        let store = InMemorySessionStore()
        let repository = LiveAuthenticationRepository(sessionStore: store)

        do {
            _ = try await repository.login(
                with: Credentials(
                    username: "wrong@example.com",
                    password: "bad-password"
                )
            )
            XCTFail("Expected invalid credentials error")
        } catch let error as AuthenticationError {
            XCTAssertEqual(error, .invalidCredentials)
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}

private actor InMemorySessionStore: SessionStoring {
    private var session: AuthSession?

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
