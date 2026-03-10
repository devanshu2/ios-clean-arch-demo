//
//  Credentials.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public struct Credentials: Sendable, Equatable {
    public let username: String
    public let password: String

    public init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}
