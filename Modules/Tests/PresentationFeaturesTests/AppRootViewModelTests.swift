//
//  AppRootViewModelTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import PresentationFeatures
import XCTest

@MainActor
final class AppRootViewModelTests: XCTestCase {
    func test_bootstrapIfNeeded_restoresExistingSessionOnlyOnce() async {
        let session = AuthSession(
            token: "restored-token",
            user: UserProfile(
                id: "restored-user",
                displayName: "Taylor Architect",
                emailAddress: "architect@example.com"
            ),
            issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
        let useCase = SpyRestoreSessionUseCase(result: .success(session))
        let viewModel = AppRootViewModel(restoreSessionUseCase: useCase)

        await viewModel.bootstrapIfNeeded()
        await viewModel.bootstrapIfNeeded()

        XCTAssertEqual(useCase.invocationCount, 1)
        XCTAssertFalse(viewModel.isBootstrapping)
        XCTAssertEqual(viewModel.session, session)
    }

    func test_bootstrapIfNeeded_clearsLoadingStateWhenRestoreFails() async {
        let viewModel = AppRootViewModel(
            restoreSessionUseCase: SpyRestoreSessionUseCase(
                result: .failure(AuthenticationError.missingSession)
            )
        )

        await viewModel.bootstrapIfNeeded()

        XCTAssertFalse(viewModel.isBootstrapping)
        XCTAssertNil(viewModel.session)
    }

    func test_acceptAuthenticatedSession_andClearSession_updateState() {
        let session = AuthSession(
            token: "active-token",
            user: UserProfile(
                id: "active-user",
                displayName: "Taylor Architect",
                emailAddress: "architect@example.com"
            ),
            issuedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
        let viewModel = AppRootViewModel(
            restoreSessionUseCase: SpyRestoreSessionUseCase(result: .success(nil))
        )

        viewModel.acceptAuthenticatedSession(session)
        XCTAssertEqual(viewModel.session, session)

        viewModel.clearSession()
        XCTAssertNil(viewModel.session)
    }
}

private final class SpyRestoreSessionUseCase: RestoreSessionUseCase, @unchecked Sendable {
    private let result: Result<AuthSession?, Error>
    private(set) var invocationCount = 0

    init(result: Result<AuthSession?, Error>) {
        self.result = result
    }

    func execute() async throws -> AuthSession? {
        invocationCount += 1
        return try result.get()
    }
}
