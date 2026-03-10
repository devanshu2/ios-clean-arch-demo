//
//  HomeViewModelTests.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import PresentationFeatures
import XCTest

@MainActor
final class HomeViewModelTests: XCTestCase {
    func test_loadWeather_transitionsToLoadedState() async throws {
        let snapshot = WeatherSnapshot(
            locationName: "New York",
            temperatureCelsius: 19.5,
            apparentTemperatureCelsius: 18.1,
            windSpeedKilometersPerHour: 9.0,
            relativeHumidity: 61,
            summary: "Clear",
            observedAt: Date(timeIntervalSince1970: 1_710_000_000)
        )
        let useCase = SpyWeatherUseCase(snapshot: snapshot)
        let viewModel = HomeViewModel(getCurrentWeatherUseCase: useCase)

        await viewModel.loadWeather()

        XCTAssertEqual(useCase.requestedLocations, [.newYork])
        XCTAssertEqual(viewModel.state, .loaded(snapshot))
    }

    func test_loadWeather_failure_transitionsToFailedState() async {
        let viewModel = HomeViewModel(getCurrentWeatherUseCase: FailingWeatherUseCase())

        await viewModel.loadWeather()

        XCTAssertEqual(viewModel.state, .failed("Weather service unavailable."))
    }
}

private final class SpyWeatherUseCase: GetCurrentWeatherUseCase, @unchecked Sendable {
    private let snapshot: WeatherSnapshot
    private(set) var requestedLocations: [WeatherLocation] = []

    init(snapshot: WeatherSnapshot) {
        self.snapshot = snapshot
    }

    func execute(for location: WeatherLocation) async throws -> WeatherSnapshot {
        requestedLocations.append(location)
        return snapshot
    }
}

private struct FailingWeatherUseCase: GetCurrentWeatherUseCase {
    func execute(for location: WeatherLocation) async throws -> WeatherSnapshot {
        throw TestError.serviceUnavailable
    }
}

private enum TestError: LocalizedError {
    case serviceUnavailable

    var errorDescription: String? {
        "Weather service unavailable."
    }
}
