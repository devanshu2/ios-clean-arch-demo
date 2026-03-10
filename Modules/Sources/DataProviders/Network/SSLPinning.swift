//
//  SSLPinning.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public struct SSLPinningConfiguration: Sendable, Equatable {
    public let pinnedSPKIHashesByHost: [String: Set<String>]

    public init(pinnedSPKIHashesByHost: [String: Set<String>] = [:]) {
        self.pinnedSPKIHashesByHost = pinnedSPKIHashesByHost
    }
}

public struct NetworkSecurityPolicy: Sendable, Equatable {
    public let sslPinning: SSLPinningConfiguration

    public init(sslPinning: SSLPinningConfiguration = .init()) {
        self.sslPinning = sslPinning
    }

    public static let relaxed = NetworkSecurityPolicy()
}

public extension NetworkSecurityPolicy {
    static let productionTemplate = NetworkSecurityPolicy(
        sslPinning: SSLPinningConfiguration(
            pinnedSPKIHashesByHost: [
                "api.open-meteo.com": [
                    "replace-with-production-spki-sha256"
                ]
            ]
        )
    )
}
