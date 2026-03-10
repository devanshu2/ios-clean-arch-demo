//
//  HomeViewModelProtocol.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Observation

@MainActor
public protocol HomeViewModelProtocol: AnyObject, Observable {
    var state: HomeViewState { get }

    func loadWeather() async
}
