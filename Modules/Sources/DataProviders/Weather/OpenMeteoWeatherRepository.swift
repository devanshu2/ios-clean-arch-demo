//
//  OpenMeteoWeatherRepository.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Foundation

public struct OpenMeteoWeatherRepository: WeatherFetchingRepository, Sendable {
    private let apiClient: any APIClient

    public init(apiClient: any APIClient) {
        self.apiClient = apiClient
    }

    public func fetchCurrentWeather(for location: WeatherLocation) async throws -> WeatherSnapshot {
        let endpoint = try makeEndpoint(for: location)
        let response = try await apiClient.fetch(endpoint, as: OpenMeteoWeatherDTO.self)
        return try response.toDomain(location: location)
    }

    private func makeEndpoint(for location: WeatherLocation) throws -> Endpoint {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(location.latitude)),
            URLQueryItem(name: "longitude", value: String(location.longitude)),
            URLQueryItem(
                name: "current",
                value: "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m"
            ),
            URLQueryItem(name: "timezone", value: "GMT")
        ]

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        return Endpoint(url: url)
    }
}
