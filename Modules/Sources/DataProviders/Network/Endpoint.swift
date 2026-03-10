//
//  Endpoint.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public struct Endpoint: Sendable {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }
}
