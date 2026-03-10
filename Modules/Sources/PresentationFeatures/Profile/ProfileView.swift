//
//  ProfileView.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import SwiftUI

public struct ProfileView<ViewModel: ProfileViewModelProtocol>: View {
    @State private var hasLoaded = false
    private let viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            List {
                Section("User") {
                    if viewModel.isLoading && viewModel.displayName.isEmpty {
                        ProgressView("Loading profile...")
                    } else {
                        LabeledContent("Name", value: viewModel.displayName)
                        LabeledContent("Email", value: viewModel.emailAddress)
                    }
                }

                Section {
                    Button("Logout", role: .destructive) {
                        Task {
                            await viewModel.logout()
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                if let errorMessage = viewModel.errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Profile")
            .task {
                guard hasLoaded == false else { return }
                hasLoaded = true
                await viewModel.loadProfile()
            }
        }
    }
}
