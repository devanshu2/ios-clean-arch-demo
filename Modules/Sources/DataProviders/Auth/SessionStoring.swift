//
//  SessionStoring.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain

public protocol SessionStoring: Sendable {
    func save(session: AuthSession) async throws
    func loadSession() async throws -> AuthSession?
    func clearSession() async throws
}
