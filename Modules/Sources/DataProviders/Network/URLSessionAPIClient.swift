//
//  URLSessionAPIClient.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public actor URLSessionAPIClient: APIClient {
    private let session: URLSession
    private let decoder: JSONDecoder
    private let securityPolicy: NetworkSecurityPolicy

    public init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        securityPolicy: NetworkSecurityPolicy = .relaxed
    ) {
        self.session = session
        self.decoder = decoder
        self.securityPolicy = securityPolicy
    }

    public func fetch<T: Decodable & Sendable>(_ endpoint: Endpoint, as type: T.Type) async throws -> T {
        var request = URLRequest(url: endpoint.url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard 200 ..< 300 ~= httpResponse.statusCode else {
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw NetworkError.decodingFailed
        }
    }

    public var configuredSecurityPolicy: NetworkSecurityPolicy {
        securityPolicy
    }
}
