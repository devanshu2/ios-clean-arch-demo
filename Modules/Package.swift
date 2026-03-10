// swift-tools-version: 6.2
//
//  Package.swift
//  Modules
//
//  Created by Devanshu Saini on 11/03/26.
//

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "CoreDomain", targets: ["CoreDomain"]),
        .library(name: "DataProviders", targets: ["DataProviders"]),
        .library(name: "PresentationFeatures", targets: ["PresentationFeatures"])
    ],
    targets: [
        .target(
            name: "CoreDomain"
        ),
        .target(
            name: "DataProviders",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .target(
            name: "PresentationFeatures",
            dependencies: [
                "CoreDomain",
                "DataProviders"
            ]
        ),
        .testTarget(
            name: "CoreDomainTests",
            dependencies: [
                "CoreDomain"
            ]
        ),
        .testTarget(
            name: "DataProvidersTests",
            dependencies: [
                "CoreDomain",
                "DataProviders"
            ]
        ),
        .testTarget(
            name: "PresentationFeaturesTests",
            dependencies: [
                "CoreDomain",
                "PresentationFeatures"
            ]
        )
    ],
    swiftLanguageModes: [
        .v6
    ]
)
