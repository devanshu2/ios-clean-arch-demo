//
//  UserProfile.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public struct UserProfile: Sendable, Codable, Equatable {
    public let id: String
    public let displayName: String
    public let emailAddress: String

    public init(id: String, displayName: String, emailAddress: String) {
        self.id = id
        self.displayName = displayName
        self.emailAddress = emailAddress
    }
}
