//
//  GetCurrentWeatherUseCase.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol GetCurrentWeatherUseCase: Sendable {
    func execute(for location: WeatherLocation) async throws -> WeatherSnapshot
}

public struct DefaultGetCurrentWeatherUseCase: GetCurrentWeatherUseCase, Sendable {
    private let repository: any WeatherFetchingRepository

    public init(repository: any WeatherFetchingRepository) {
        self.repository = repository
    }

    public func execute(for location: WeatherLocation) async throws -> WeatherSnapshot {
        try await repository.fetchCurrentWeather(for: location)
    }
}
