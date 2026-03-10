//
//  ProfileRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol UserProfileReadingRepository: Sendable {
    func fetchCurrentUserProfile() async throws -> UserProfile
}
