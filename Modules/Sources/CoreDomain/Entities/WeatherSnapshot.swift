//
//  WeatherSnapshot.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import Foundation

public struct WeatherSnapshot: Sendable, Equatable {
    public let locationName: String
    public let temperatureCelsius: Double
    public let apparentTemperatureCelsius: Double
    public let windSpeedKilometersPerHour: Double
    public let relativeHumidity: Int
    public let summary: String
    public let observedAt: Date

    public init(
        locationName: String,
        temperatureCelsius: Double,
        apparentTemperatureCelsius: Double,
        windSpeedKilometersPerHour: Double,
        relativeHumidity: Int,
        summary: String,
        observedAt: Date
    ) {
        self.locationName = locationName
        self.temperatureCelsius = temperatureCelsius
        self.apparentTemperatureCelsius = apparentTemperatureCelsius
        self.windSpeedKilometersPerHour = windSpeedKilometersPerHour
        self.relativeHumidity = relativeHumidity
        self.summary = summary
        self.observedAt = observedAt
    }
}
