//
//  LogoutUseCase.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol LogoutUseCase: Sendable {
    func execute() async throws
}

public struct DefaultLogoutUseCase: LogoutUseCase, Sendable {
    private let repository: any SessionClearingRepository

    public init(repository: any SessionClearingRepository) {
        self.repository = repository
    }

    public func execute() async throws {
        try await repository.clearSession()
    }
}
