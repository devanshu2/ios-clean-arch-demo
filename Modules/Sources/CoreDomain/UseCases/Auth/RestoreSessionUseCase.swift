//
//  RestoreSessionUseCase.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol RestoreSessionUseCase: Sendable {
    func execute() async throws -> AuthSession?
}

public struct DefaultRestoreSessionUseCase: RestoreSessionUseCase, Sendable {
    private let repository: any SessionReadingRepository

    public init(repository: any SessionReadingRepository) {
        self.repository = repository
    }

    public func execute() async throws -> AuthSession? {
        try await repository.loadSession()
    }
}
