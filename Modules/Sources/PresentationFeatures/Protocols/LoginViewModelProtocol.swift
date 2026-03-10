//
//  LoginViewModelProtocol.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

@MainActor
public protocol LoginViewModelProtocol: AnyObject, Observable {
    var username: String { get set }
    var password: String { get set }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var authenticatedSession: AuthSession? { get }

    func login() async
    func consumeAuthenticatedSession()
    func clearTransientState()
}
