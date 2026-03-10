//
//  AuthenticationError.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public enum AuthenticationError: LocalizedError, Sendable, Equatable {
    case invalidCredentials
    case missingSession

    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The supplied credentials are invalid."
        case .missingSession:
            return "No active session is available."
        }
    }
}
