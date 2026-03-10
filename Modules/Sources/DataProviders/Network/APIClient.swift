//
//  APIClient.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public protocol APIClient: Sendable {
    func fetch<T: Decodable & Sendable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T
}
