//
//  AuthSession.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public struct AuthSession: Sendable, Codable, Equatable {
    public let token: String
    public let user: UserProfile
    public let issuedAt: Date

    public init(token: String, user: UserProfile, issuedAt: Date) {
        self.token = token
        self.user = user
        self.issuedAt = issuedAt
    }
}
