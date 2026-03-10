//
//  LoginViewModel.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

@MainActor
@Observable
public final class LoginViewModel: LoginViewModelProtocol {
    public var username: String
    public var password: String
    public private(set) var isLoading = false
    public private(set) var errorMessage: String?
    public private(set) var authenticatedSession: AuthSession?

    private let loginUseCase: any LoginUseCase

    public init(
        loginUseCase: any LoginUseCase,
        username: String = "architect@example.com",
        password: String = "clean-swift"
    ) {
        self.loginUseCase = loginUseCase
        self.username = username
        self.password = password
    }

    public func login() async {
        guard isLoading == false else { return }
        isLoading = true
        errorMessage = nil

        do {
            authenticatedSession = try await loginUseCase.execute(
                username: username,
                password: password
            )
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }

    public func consumeAuthenticatedSession() {
        authenticatedSession = nil
    }

    public func clearTransientState() {
        errorMessage = nil
        authenticatedSession = nil
    }
}
