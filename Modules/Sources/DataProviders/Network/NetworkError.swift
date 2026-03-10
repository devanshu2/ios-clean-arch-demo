//
//  NetworkError.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public enum NetworkError: LocalizedError, Sendable, Equatable {
    case invalidResponse
    case httpStatus(Int)
    case decodingFailed

    public var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "The server response was invalid."
        case .httpStatus(let statusCode):
            return "The server returned HTTP \(statusCode)."
        case .decodingFailed:
            return "The response payload could not be decoded."
        }
    }
}
