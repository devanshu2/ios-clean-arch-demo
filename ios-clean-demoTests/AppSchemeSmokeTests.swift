//
//  AppSchemeSmokeTests.swift
//  ios-clean-demo
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import PresentationFeatures
import XCTest

@MainActor
final class AppSchemeSmokeTests: XCTestCase {
    func test_loginViewModel_publishesSession() async {
        let viewModel = LoginViewModel(loginUseCase: StubLoginUseCase())

        await viewModel.login()

        XCTAssertEqual(viewModel.authenticatedSession?.token, "xcode-scheme-token")
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_appRootViewModel_restoresInjectedSession() async {
        let expectedSession = AuthSession(
            token: "restored-from-scheme-test",
            user: UserProfile(
                id: "scheme-user",
                displayName: "Taylor Architect",
                emailAddress: "architect@example.com"
            ),
            issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
        let viewModel = AppRootViewModel(
            restoreSessionUseCase: StubRestoreSessionUseCase(session: expectedSession)
        )

        await viewModel.bootstrapIfNeeded()

        XCTAssertEqual(viewModel.session, expectedSession)
        XCTAssertFalse(viewModel.isBootstrapping)
    }
}

private struct StubLoginUseCase: LoginUseCase {
    func execute(username: String, password: String) async throws -> AuthSession {
        AuthSession(
            token: "xcode-scheme-token",
            user: UserProfile(
                id: "scheme-user",
                displayName: "Taylor Architect",
                emailAddress: username
            ),
            issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
    }
}

private struct StubRestoreSessionUseCase: RestoreSessionUseCase {
    let session: AuthSession

    func execute() async throws -> AuthSession? {
        session
    }
}
