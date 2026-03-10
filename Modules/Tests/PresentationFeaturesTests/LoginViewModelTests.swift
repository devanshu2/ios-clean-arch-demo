//
//  LoginViewModelTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import PresentationFeatures
import XCTest

@MainActor
final class LoginViewModelTests: XCTestCase {
    func test_login_usesProtocolBoundUseCaseAndPublishesSession() async {
        let useCase = SpyLoginUseCase()
        let viewModel = LoginViewModel(loginUseCase: useCase)

        await viewModel.login()

        XCTAssertEqual(useCase.recordedUsernames, ["architect@example.com"])
        XCTAssertEqual(useCase.recordedPasswords, ["clean-swift"])
        XCTAssertEqual(viewModel.authenticatedSession?.token, "spy-token")
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_login_failure_exposesErrorMessage() async {
        let useCase = FailingLoginUseCase()
        let viewModel = LoginViewModel(loginUseCase: useCase)

        await viewModel.login()

        XCTAssertEqual(viewModel.errorMessage, "The supplied credentials are invalid.")
        XCTAssertNil(viewModel.authenticatedSession)
    }
}

private final class SpyLoginUseCase: LoginUseCase, @unchecked Sendable {
    private(set) var recordedUsernames: [String] = []
    private(set) var recordedPasswords: [String] = []

    func execute(username: String, password: String) async throws -> AuthSession {
        recordedUsernames.append(username)
        recordedPasswords.append(password)

        return AuthSession(
            token: "spy-token",
            user: UserProfile(
                id: "spy-user",
                displayName: "Test User",
                emailAddress: username
            ),
            issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
    }
}

private struct FailingLoginUseCase: LoginUseCase {
    func execute(username: String, password: String) async throws -> AuthSession {
        throw AuthenticationError.invalidCredentials
    }
}
