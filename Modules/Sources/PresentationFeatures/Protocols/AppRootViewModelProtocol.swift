//
//  AppRootViewModelProtocol.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

@MainActor
public protocol AppRootViewModelProtocol: AnyObject, Observable {
    var isBootstrapping: Bool { get }
    var session: AuthSession? { get }

    func bootstrapIfNeeded() async
    func acceptAuthenticatedSession(_ session: AuthSession)
    func clearSession()
}
