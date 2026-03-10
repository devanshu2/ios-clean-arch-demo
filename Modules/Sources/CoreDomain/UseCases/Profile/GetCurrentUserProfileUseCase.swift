//
//  GetCurrentUserProfileUseCase.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol GetCurrentUserProfileUseCase: Sendable {
    func execute() async throws -> UserProfile
}

public struct DefaultGetCurrentUserProfileUseCase: GetCurrentUserProfileUseCase, Sendable {
    private let repository: any UserProfileReadingRepository

    public init(repository: any UserProfileReadingRepository) {
        self.repository = repository
    }

    public func execute() async throws -> UserProfile {
        try await repository.fetchCurrentUserProfile()
    }
}
