# AGENTS.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Development Commands

```bash
flutter run                    # Run the app (debug mode)
flutter analyze                # Run static analysis (linter)
flutter pub get                # Fetch dependencies
flutter test                   # Run all tests
flutter test test/path_test.dart  # Run a specific test file
```

## Architecture

**BookingKu** is a Flutter mobile app for reserving mini soccer fields, using Clean Architecture with feature-based organization.

### Directory Structure

```
lib/
├── core/                      # Shared infrastructure
│   ├── constants/             # App constants, API endpoints
│   ├── network/               # ApiClient, ApiException, ApiResponse
│   ├── routes/                # GoRouter configuration (app_router.dart)
│   ├── services/              # StorageService, ImagePickerService
│   ├── theme/                 # AppTheme, colors, typography, spacing
│   └── utils/                 # Formatters, validators
├── features/                  # Feature modules (auth, booking, home, etc.)
│   └── [feature]/
│       ├── data/              # Repository implementations, models, datasources
│       ├── domain/            # Entities, repository interfaces
│       └── presentation/      # Pages, providers, widgets
└── shared/                    # Cross-feature widgets, extensions, models
```

### Key Patterns

**State Management**: Provider with ChangeNotifier. Each feature has a `*Provider` class that manages UI state. Providers are initialized in `main.dart` and injected via `MultiProvider`.

**Navigation**: GoRouter with named routes via `AppRouteNames` class. Bottom navigation uses `ShellRoute` to preserve tab state. Routes are defined in `lib/core/routes/app_router.dart`.

**Data Flow**: Repositories abstract data sources. Currently uses mock data (simulated with `Future.delayed`). The `ApiClient` in `lib/core/network/` is prepared for future backend integration—switch from mock to remote by replacing mock datasources.

**Result Type**: Use `Result<T>` from `lib/shared/models/result.dart` for operations that can fail. Pattern: `result.when(success: (data) => ..., failure: (msg) => ...)`.

### Current State

- Mock authentication: login with `ahmad.reza@email.com` or `081234567890`, password `12345678`
- API endpoints defined in `lib/core/constants/api_endpoints.dart` but not yet connected
- Indonesian locale (`id_ID`) initialized for date formatting

### Important Files

- `lib/main.dart` - App entry point, provider setup
- `lib/core/routes/app_router.dart` - All route definitions
- `lib/core/services/storage_service.dart` - Local storage (SharedPreferences)