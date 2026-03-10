# Modules Architecture

This package implements a strict Clean Architecture split with local Swift Package targets:

- `CoreDomain`: pure business rules, entities, repository abstractions, and use case contracts.
- `DataProviders`: infrastructure adapters that implement domain repository contracts.
- `PresentationFeatures`: SwiftUI views, protocol-backed `@Observable` view models, and the composition root used by the app target.

## Dependency Rules

- `CoreDomain` depends on nothing.
- `DataProviders` depends only on `CoreDomain`.
- `PresentationFeatures` depends on `CoreDomain` for business-facing contracts and `DataProviders` only at the composition root.
- The Xcode app target imports only `PresentationFeatures`.

## SOLID Mapping

- SRP: each use case encapsulates one business action such as `GetCurrentWeatherUseCase` or `LogoutUseCase`.
- OCP: repositories and use cases are protocol-driven so new adapters can be added without modifying domain rules.
- LSP: mocks, stubs, and spies conform to the same repository and view model protocols as production implementations.
- ISP: repository contracts are split into narrow capabilities such as `WeatherFetchingRepository`, `LoginPerformingRepository`, and `SessionClearingRepository`.
- DIP: view models depend on use case protocols; use cases depend on repository protocols.

## Concurrency

- Domain entities are `Sendable`.
- Stateful infrastructure such as Keychain storage and HTTP access is actor-isolated.
- Presentation state is isolated to `@MainActor` view models.

## Security

- Auth session storage uses Keychain with `kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly`.
- SSL pinning is represented as a policy template in `DataProviders/Network/SSLPinning.swift`; production certificates or SPKI hashes should be injected per environment.

## Test Strategy

- `CoreDomainTests` covers use case behavior with repository stubs and spies.
- `DataProvidersTests` validates mapping and repository side effects without real network access.
- `PresentationFeaturesTests` exercises view model state transitions using use case test doubles.

## Coverage Map

- `GetCurrentWeatherUseCase`: success path and repository interaction verification.
- `LiveAuthenticationRepository`: valid login persistence and invalid credential rejection.
- `LiveProfileRepository`: session-backed profile reads and missing-session failure.
- `OpenMeteoWeatherRepository`: DTO-to-domain mapping and endpoint construction.
- `AppRootViewModel`: session bootstrap, one-time restore semantics, and explicit session transitions.
- `LoginViewModel`, `HomeViewModel`, `ProfileViewModel`: success and failure state transitions with injected doubles.

## Remaining Gaps

- `KeychainSessionStore` is not unit tested because it talks to platform security APIs; treat it as an integration-test candidate.
- SwiftUI view rendering itself is not snapshot tested yet, but the generic protocol-backed view models are designed so preview and snapshot fixtures can be injected directly.

## Verification

- Run package tests: `swift test --package-path Modules`
- Build the app target: `xcodebuild -project ios-clean-demo.xcodeproj -scheme ios-clean-demo -destination 'generic/platform=iOS Simulator' build`
- Run the native Xcode test bundle: `xcodebuild test -project ios-clean-demo.xcodeproj -scheme ios-clean-demo -destination 'id=<simulator-udid>'`

## Xcode Test Flow

- Open [ios-clean-demo.xcodeproj](/Users/devanshu/Documents/workshop/ios-clean-arch-demo/ios-clean-demo.xcodeproj)
- Select the `ios-clean-demo` scheme
- Choose a concrete simulator device, not `Any iOS Simulator Device`
- Press `Cmd-U`

`Cmd-U` runs the native [AppSchemeSmokeTests.swift](/Users/devanshu/Documents/workshop/ios-clean-arch-demo/ios-clean-demoTests/AppSchemeSmokeTests.swift) target. The deeper package suite remains available through `swift test --package-path Modules`.
