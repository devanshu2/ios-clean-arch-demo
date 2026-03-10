//
//  WeatherLocation.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

public struct WeatherLocation: Sendable, Equatable {
    public let name: String
    public let latitude: Double
    public let longitude: Double

    public init(name: String, latitude: Double, longitude: Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
}

public extension WeatherLocation {
    static let newYork = WeatherLocation(
        name: "New York",
        latitude: 40.7128,
        longitude: -74.0060
    )
}
