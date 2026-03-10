//
//  AppRootView.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import SwiftUI

public struct AppRootView: View {
    @State private var appViewModel: AppRootViewModel
    @State private var loginViewModel: LoginViewModel
    @State private var homeViewModel: HomeViewModel
    @State private var profileViewModel: ProfileViewModel

    public init(container: AppContainer) {
        _appViewModel = State(
            initialValue: AppRootViewModel(
                restoreSessionUseCase: container.restoreSessionUseCase
            )
        )
        _loginViewModel = State(
            initialValue: LoginViewModel(
                loginUseCase: container.loginUseCase
            )
        )
        _homeViewModel = State(
            initialValue: HomeViewModel(
                getCurrentWeatherUseCase: container.getCurrentWeatherUseCase
            )
        )
        _profileViewModel = State(
            initialValue: ProfileViewModel(
                getCurrentUserProfileUseCase: container.getCurrentUserProfileUseCase,
                logoutUseCase: container.logoutUseCase
            )
        )
    }

    public var body: some View {
        Group {
            if appViewModel.isBootstrapping {
                ProgressView("Restoring session...")
            } else if appViewModel.session == nil {
                LoginView(viewModel: loginViewModel)
            } else {
                MainTabView(
                    homeViewModel: homeViewModel,
                    profileViewModel: profileViewModel
                )
            }
        }
        .task {
            await appViewModel.bootstrapIfNeeded()
        }
        .onChange(of: loginViewModel.authenticatedSession) { _, newValue in
            guard let session = newValue else { return }
            appViewModel.acceptAuthenticatedSession(session)
            loginViewModel.consumeAuthenticatedSession()
        }
        .onChange(of: profileViewModel.didLogout) { _, didLogout in
            guard didLogout else { return }
            appViewModel.clearSession()
            loginViewModel.clearTransientState()
            profileViewModel.consumeLogout()
        }
    }
}

#Preview {
    AppRootView(container: .live())
}
