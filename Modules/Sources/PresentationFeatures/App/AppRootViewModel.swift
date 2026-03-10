//
//  AppRootViewModel.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

@MainActor
@Observable
public final class AppRootViewModel: AppRootViewModelProtocol {
    public private(set) var isBootstrapping = true
    public private(set) var session: AuthSession?

    private let restoreSessionUseCase: any RestoreSessionUseCase
    private var hasBootstrapped = false

    public init(
        restoreSessionUseCase: any RestoreSessionUseCase,
        initialSession: AuthSession? = nil
    ) {
        self.restoreSessionUseCase = restoreSessionUseCase
        self.session = initialSession
        self.isBootstrapping = initialSession == nil
    }

    public func bootstrapIfNeeded() async {
        guard hasBootstrapped == false else { return }
        hasBootstrapped = true
        do {
            session = try await restoreSessionUseCase.execute()
        } catch {
            session = nil
        }
        isBootstrapping = false
    }

    public func acceptAuthenticatedSession(_ session: AuthSession) {
        self.session = session
        isBootstrapping = false
    }

    public func clearSession() {
        session = nil
    }
}
