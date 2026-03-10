//
//  ProfileViewModel.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

@MainActor
@Observable
public final class ProfileViewModel: ProfileViewModelProtocol {
    public private(set) var displayName = ""
    public private(set) var emailAddress = ""
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?
    public private(set) var didLogout = false

    private let getCurrentUserProfileUseCase: any GetCurrentUserProfileUseCase
    private let logoutUseCase: any LogoutUseCase

    public init(
        getCurrentUserProfileUseCase: any GetCurrentUserProfileUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.getCurrentUserProfileUseCase = getCurrentUserProfileUseCase
        self.logoutUseCase = logoutUseCase
    }

    public func loadProfile() async {
        guard isLoading == false else { return }
        isLoading = true
        errorMessage = nil

        do {
            let profile = try await getCurrentUserProfileUseCase.execute()
            displayName = profile.displayName
            emailAddress = profile.emailAddress
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func logout() async {
        guard isLoading == false else { return }
        isLoading = true
        errorMessage = nil

        do {
            try await logoutUseCase.execute()
            didLogout = true
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func consumeLogout() {
        didLogout = false
        displayName = ""
        emailAddress = ""
    }
}
