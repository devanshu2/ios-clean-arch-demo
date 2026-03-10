//
//  HomeViewModel.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Observation

public enum HomeViewState: Equatable, Sendable {
    case idle
    case loading
    case loaded(WeatherSnapshot)
    case failed(String)
}

@MainActor
@Observable
public final class HomeViewModel: HomeViewModelProtocol {
    public private(set) var state: HomeViewState

    private let getCurrentWeatherUseCase: any GetCurrentWeatherUseCase
    private let location: WeatherLocation

    public init(
        getCurrentWeatherUseCase: any GetCurrentWeatherUseCase,
        location: WeatherLocation = .newYork,
        initialState: HomeViewState = .idle
    ) {
        self.getCurrentWeatherUseCase = getCurrentWeatherUseCase
        self.location = location
        self.state = initialState
    }

    public func loadWeather() async {
        guard state != .loading else { return }
        state = .loading

        do {
            let weather = try await getCurrentWeatherUseCase.execute(for: location)
            state = .loaded(weather)
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
