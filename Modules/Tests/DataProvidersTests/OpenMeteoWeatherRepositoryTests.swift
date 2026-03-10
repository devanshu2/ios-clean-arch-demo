//
//  OpenMeteoWeatherRepositoryTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import DataProviders
import Foundation
import XCTest

final class OpenMeteoWeatherRepositoryTests: XCTestCase {
    func test_fetchCurrentWeather_mapsDTOIntoDomainEntity() async throws {
        let apiClient = StubAPIClient(
            payload: OpenMeteoWeatherDTO(
                current: .init(
                    time: "2026-03-10T09:00",
                    temperature_2m: 11.2,
                    apparent_temperature: 8.7,
                    relative_humidity_2m: 72,
                    wind_speed_10m: 18.4,
                    weather_code: 3
                )
            )
        )
        let repository = OpenMeteoWeatherRepository(apiClient: apiClient)

        let snapshot = try await repository.fetchCurrentWeather(for: WeatherLocation.newYork)
        let expectedDate = Calendar(identifier: .gregorian).date(
            from: DateComponents(
                timeZone: TimeZone(secondsFromGMT: 0),
                year: 2026,
                month: 3,
                day: 10,
                hour: 9,
                minute: 0
            )
        )
        let endpoint = await apiClient.lastEndpoint

        XCTAssertEqual(snapshot.locationName, "New York")
        XCTAssertEqual(snapshot.temperatureCelsius, 11.2)
        XCTAssertEqual(snapshot.apparentTemperatureCelsius, 8.7)
        XCTAssertEqual(snapshot.relativeHumidity, 72)
        XCTAssertEqual(snapshot.windSpeedKilometersPerHour, 18.4)
        XCTAssertEqual(snapshot.summary, "Partly Cloudy")
        XCTAssertEqual(snapshot.observedAt, expectedDate)
        XCTAssertEqual(endpoint?.url.host, "api.open-meteo.com")
    }
}

private actor StubAPIClient: APIClient {
    let payload: OpenMeteoWeatherDTO
    private(set) var lastEndpoint: Endpoint?

    init(payload: OpenMeteoWeatherDTO) {
        self.payload = payload
    }

    func fetch<T>(_ endpoint: Endpoint, as type: T.Type) async throws -> T where T : Decodable, T : Sendable {
        lastEndpoint = endpoint
        guard let payload = payload as? T else {
            throw StubAPIClientError.unexpectedRequestedType
        }
        return payload
    }
}

private enum StubAPIClientError: Error {
    case unexpectedRequestedType
}
