//
//  HomeView.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import CoreDomain
import SwiftUI

public struct HomeView<ViewModel: HomeViewModelProtocol>: View {
    @State private var hasLoaded = false
    private let viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            content
                .navigationTitle("Weather")
                .task {
                    guard hasLoaded == false else { return }
                    hasLoaded = true
                    await viewModel.loadWeather()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView("Loading New York weather...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ContentUnavailableView(
                "Weather Unavailable",
                systemImage: "cloud.slash",
                description: Text(message)
            )
        case .loaded(let snapshot):
            List {
                Section(snapshot.locationName) {
                    MetricRow(title: "Condition", value: snapshot.summary)
                    MetricRow(title: "Temperature", value: temperature(snapshot.temperatureCelsius))
                    MetricRow(title: "Feels Like", value: temperature(snapshot.apparentTemperatureCelsius))
                    MetricRow(title: "Humidity", value: "\(snapshot.relativeHumidity)%")
                    MetricRow(title: "Wind", value: "\(Int(snapshot.windSpeedKilometersPerHour.rounded())) km/h")
                    MetricRow(
                        title: "Updated",
                        value: snapshot.observedAt.formatted(
                            date: .abbreviated,
                            time: .shortened
                        )
                    )
                }
            }
            .refreshable {
                await viewModel.loadWeather()
            }
        }
    }

    private func temperature(_ value: Double) -> String {
        "\(value.formatted(.number.precision(.fractionLength(1)))) C"
    }
}

private struct MetricRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    let previewUseCase = PreviewWeatherUseCase(
        snapshot: WeatherSnapshot(
            locationName: "New York",
            temperatureCelsius: 18.2,
            apparentTemperatureCelsius: 16.4,
            windSpeedKilometersPerHour: 12,
            relativeHumidity: 64,
            summary: "Partly Cloudy",
            observedAt: .now
        )
    )
    return HomeView(
        viewModel: HomeViewModel(
            getCurrentWeatherUseCase: previewUseCase,
            initialState: .loaded(previewUseCase.snapshot)
        )
    )
}

private struct PreviewWeatherUseCase: GetCurrentWeatherUseCase {
    let snapshot: WeatherSnapshot

    func execute(for location: WeatherLocation) async throws -> WeatherSnapshot {
        snapshot
    }
}
