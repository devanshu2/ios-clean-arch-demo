//
//  ProfileViewModelProtocol.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Observation

@MainActor
public protocol ProfileViewModelProtocol: AnyObject, Observable {
    var displayName: String { get }
    var emailAddress: String { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var didLogout: Bool { get }

    func loadProfile() async
    func logout() async
    func consumeLogout()
}
