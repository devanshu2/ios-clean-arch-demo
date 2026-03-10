//
//  LoginUseCase.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol LoginUseCase: Sendable {
    func execute(username: String, password: String) async throws -> AuthSession
}

public struct DefaultLoginUseCase: LoginUseCase, Sendable {
    private let repository: any LoginPerformingRepository

    public init(repository: any LoginPerformingRepository) {
        self.repository = repository
    }

    public func execute(username: String, password: String) async throws -> AuthSession {
        let credentials = Credentials(username: username, password: password)
        return try await repository.login(with: credentials)
    }
}
