//
//  LoginView.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import SwiftUI

public struct LoginView<ViewModel: LoginViewModelProtocol>: View {
    @Bindable private var viewModel: ViewModel

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            Form {
                Section("Credentials") {
                    TextField("Email", text: $viewModel.username)
                    SecureField("Password", text: $viewModel.password)
                }

                Section {
                    Button {
                        Task {
                            await viewModel.login()
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Login")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }

                Section("Demo Access") {
                    LabeledContent("Username", value: "architect@example.com")
                    LabeledContent("Password", value: "clean-swift")
                }

                if let errorMessage = viewModel.errorMessage {
                    Section("Error") {
                        Text(errorMessage)
                            .foregroundStyle(.red)
                    }
                }
            }
            .navigationTitle("Secure Login")
        }
    }
}
