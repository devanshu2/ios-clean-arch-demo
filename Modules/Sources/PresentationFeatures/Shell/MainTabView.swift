//
//  MainTabView.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import SwiftUI

public struct MainTabView<HomeVM: HomeViewModelProtocol, ProfileVM: ProfileViewModelProtocol>: View {
    private let homeViewModel: HomeVM
    private let profileViewModel: ProfileVM

    public init(
        homeViewModel: HomeVM,
        profileViewModel: ProfileVM
    ) {
        self.homeViewModel = homeViewModel
        self.profileViewModel = profileViewModel
    }

    public var body: some View {
        TabView {
            HomeView(viewModel: homeViewModel)
                .tabItem {
                    Label("Home", systemImage: "cloud.sun")
                }

            ProfileView(viewModel: profileViewModel)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
        }
    }
}
