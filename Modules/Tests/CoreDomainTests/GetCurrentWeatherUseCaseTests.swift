//
//  GetCurrentWeatherUseCaseTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import XCTest

final class GetCurrentWeatherUseCaseTests: XCTestCase {
    func test_execute_returnsSnapshotFromStubbedRepository() async throws {
        let expectedSnapshot = WeatherSnapshot(
            locationName: "New York",
            temperatureCelsius: 22.4,
            apparentTemperatureCelsius: 21.0,
            windSpeedKilometersPerHour: 14.0,
            relativeHumidity: 58,
            summary: "Clear",
            observedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
        let repository = StubWeatherRepository(snapshot: expectedSnapshot)
        let useCase = DefaultGetCurrentWeatherUseCase(repository: repository)

        let result = try await useCase.execute(for: .newYork)

        XCTAssertEqual(result, expectedSnapshot)
    }

    func test_execute_passesRequestedLocationToSpyRepository() async throws {
        let repository = SpyWeatherRepository()
        let useCase = DefaultGetCurrentWeatherUseCase(repository: repository)
        let expectedLocation = WeatherLocation(
            name: "Tokyo",
            latitude: 35.6764,
            longitude: 139.6500
        )

        _ = try await useCase.execute(for: expectedLocation)

        let capturedLocations = await repository.capturedLocations
        let invocationCount = await repository.invocationCount
        XCTAssertEqual(invocationCount, 1)
        XCTAssertEqual(capturedLocations, [expectedLocation])
    }
}

private struct StubWeatherRepository: WeatherFetchingRepository {
    let snapshot: WeatherSnapshot

    func fetchCurrentWeather(for location: WeatherLocation) async throws -> WeatherSnapshot {
        snapshot
    }
}

private actor SpyWeatherRepository: WeatherFetchingRepository {
    private(set) var capturedLocations: [WeatherLocation] = []
    private(set) var invocationCount = 0

    func fetchCurrentWeather(for location: WeatherLocation) async throws -> WeatherSnapshot {
        invocationCount += 1
        capturedLocations.append(location)

        return WeatherSnapshot(
            locationName: location.name,
            temperatureCelsius: 18.0,
            apparentTemperatureCelsius: 17.0,
            windSpeedKilometersPerHour: 10.0,
            relativeHumidity: 65,
            summary: "Partly Cloudy",
            observedAt: Date(timeIntervalSince1970: 1_710_100_000)
        )
    }
}
