//
//  WeatherRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public protocol WeatherFetchingRepository: Sendable {
    func fetchCurrentWeather(for location: WeatherLocation) async throws -> WeatherSnapshot
}
