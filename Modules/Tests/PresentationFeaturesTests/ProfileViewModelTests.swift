//
//  ProfileViewModelTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import PresentationFeatures
import XCTest

@MainActor
final class ProfileViewModelTests: XCTestCase {
    func test_loadProfile_populatesPublishedUserFields() async {
        let profile = UserProfile(
            id: "profile-user",
            displayName: "Taylor Architect",
            emailAddress: "architect@example.com"
        )
        let viewModel = ProfileViewModel(
            getCurrentUserProfileUseCase: StubProfileUseCase(profile: profile),
            logoutUseCase: SpyLogoutUseCase()
        )

        await viewModel.loadProfile()

        XCTAssertEqual(viewModel.displayName, profile.displayName)
        XCTAssertEqual(viewModel.emailAddress, profile.emailAddress)
        XCTAssertNil(viewModel.errorMessage)
    }

    func test_logout_marksStateAndInvokesUseCase() async {
        let logoutUseCase = SpyLogoutUseCase()
        let viewModel = ProfileViewModel(
            getCurrentUserProfileUseCase: StubProfileUseCase(
                profile: UserProfile(id: "profile-user", displayName: "Taylor", emailAddress: "a@b.com")
            ),
            logoutUseCase: logoutUseCase
        )

        await viewModel.logout()

        XCTAssertTrue(viewModel.didLogout)
        XCTAssertEqual(logoutUseCase.invocationCount, 1)
    }
}

private struct StubProfileUseCase: GetCurrentUserProfileUseCase {
    let profile: UserProfile

    func execute() async throws -> UserProfile {
        profile
    }
}

private final class SpyLogoutUseCase: LogoutUseCase, @unchecked Sendable {
    private(set) var invocationCount = 0

    func execute() async throws {
        invocationCount += 1
    }
}
