//
//  OpenMeteoWeatherDTO.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import Foundation

public struct OpenMeteoWeatherDTO: Decodable, Sendable {
    public struct CurrentWeatherDTO: Decodable, Sendable {
        public let time: String
        public let temperature_2m: Double
        public let apparent_temperature: Double
        public let relative_humidity_2m: Int
        public let wind_speed_10m: Double
        public let weather_code: Int

        public init(
            time: String,
            temperature_2m: Double,
            apparent_temperature: Double,
            relative_humidity_2m: Int,
            wind_speed_10m: Double,
            weather_code: Int
        ) {
            self.time = time
            self.temperature_2m = temperature_2m
            self.apparent_temperature = apparent_temperature
            self.relative_humidity_2m = relative_humidity_2m
            self.wind_speed_10m = wind_speed_10m
            self.weather_code = weather_code
        }
    }

    public let current: CurrentWeatherDTO

    public init(current: CurrentWeatherDTO) {
        self.current = current
    }

    public func toDomain(location: WeatherLocation) throws -> WeatherSnapshot {
        WeatherSnapshot(
            locationName: location.name,
            temperatureCelsius: current.temperature_2m,
            apparentTemperatureCelsius: current.apparent_temperature,
            windSpeedKilometersPerHour: current.wind_speed_10m,
            relativeHumidity: current.relative_humidity_2m,
            summary: WeatherCodeMapper.description(for: current.weather_code),
            observedAt: try OpenMeteoDateParser.parse(current.time)
        )
    }
}

enum OpenMeteoDateParser {
    private static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()

    static func parse(_ rawValue: String) throws -> Date {
        guard let date = formatter.date(from: rawValue) else {
            throw NetworkError.decodingFailed
        }
        return date
    }
}

enum WeatherCodeMapper {
    static func description(for code: Int) -> String {
        switch code {
        case 0:
            return "Clear"
        case 1, 2, 3:
            return "Partly Cloudy"
        case 45, 48:
            return "Fog"
        case 51, 53, 55, 56, 57:
            return "Drizzle"
        case 61, 63, 65, 66, 67:
            return "Rain"
        case 71, 73, 75, 77:
            return "Snow"
        case 80, 81, 82:
            return "Rain Showers"
        case 95, 96, 99:
            return "Thunderstorm"
        default:
            return "Unspecified"
        }
    }
}
