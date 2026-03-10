//
//  AppContainer.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import DataProviders

public struct AppContainer: Sendable {
    public let restoreSessionUseCase: any RestoreSessionUseCase
    public let loginUseCase: any LoginUseCase
    public let getCurrentWeatherUseCase: any GetCurrentWeatherUseCase
    public let getCurrentUserProfileUseCase: any GetCurrentUserProfileUseCase
    public let logoutUseCase: any LogoutUseCase

    public init(
        restoreSessionUseCase: any RestoreSessionUseCase,
        loginUseCase: any LoginUseCase,
        getCurrentWeatherUseCase: any GetCurrentWeatherUseCase,
        getCurrentUserProfileUseCase: any GetCurrentUserProfileUseCase,
        logoutUseCase: any LogoutUseCase
    ) {
        self.restoreSessionUseCase = restoreSessionUseCase
        self.loginUseCase = loginUseCase
        self.getCurrentWeatherUseCase = getCurrentWeatherUseCase
        self.getCurrentUserProfileUseCase = getCurrentUserProfileUseCase
        self.logoutUseCase = logoutUseCase
    }
}

public extension AppContainer {
    static func live() -> AppContainer {
        let sessionStore = KeychainSessionStore(service: "com.devanshu.ios-clean-demo.auth")
        let authenticationRepository = LiveAuthenticationRepository(sessionStore: sessionStore)
        let weatherRepository = OpenMeteoWeatherRepository(apiClient: URLSessionAPIClient())
        let profileRepository = LiveProfileRepository(sessionStore: sessionStore)

        return AppContainer(
            restoreSessionUseCase: DefaultRestoreSessionUseCase(repository: authenticationRepository),
            loginUseCase: DefaultLoginUseCase(repository: authenticationRepository),
            getCurrentWeatherUseCase: DefaultGetCurrentWeatherUseCase(repository: weatherRepository),
            getCurrentUserProfileUseCase: DefaultGetCurrentUserProfileUseCase(repository: profileRepository),
            logoutUseCase: DefaultLogoutUseCase(repository: authenticationRepository)
        )
    }
}
