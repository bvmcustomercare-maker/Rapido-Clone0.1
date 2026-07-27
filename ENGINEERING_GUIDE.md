# RideFlow Simulator — Master Engineering Guide & System Handbook
**Document Version:** 1.0.0  
**Status:** Approved / Single Source of Truth  
**Target Platform:** Flutter (Android First, iOS / Web Dashboard Ready)  
**Architecture:** Clean Architecture + MVVM + Riverpod + Hive (Offline-First)

---

## Table of Contents
1. [Engineering Principles](#1-engineering-principles)
2. [Project Structure](#2-project-structure)
3. [Development Workflow](#3-development-workflow)
4. [Task Breakdown](#4-task-breakdown)
5. [Sprint Planning](#5-sprint-planning)
6. [Coding Standards](#6-coding-standards)
7. [Naming Conventions](#7-naming-conventions)
8. [Flutter Standards](#8-flutter-standards)
9. [Riverpod Standards](#9-riverpod-standards)
10. [Architecture Rules](#10-architecture-rules)
11. [Database Rules (Hive)](#11-database-rules-hive)
12. [Simulation Engine Rules](#12-simulation-engine-rules)
13. [Performance Standards](#13-performance-standards)
14. [Security Standards](#14-security-standards)
15. [Testing Standards](#15-testing-standards)
16. [Git Standards](#16-git-standards)
17. [AI Coding Instructions](#17-ai-coding-instructions)
18. [Quality Gates](#18-quality-gates)
19. [Definition of Done (DoD)](#19-definition-of-done-dod)
20. [Risk Register](#20-risk-register)
21. [Developer Checklist](#21-developer-checklist)
22. [Future Scalability & Backend Migration Path](#22-future-scalability--backend-migration-path)

---

## 1. Engineering Principles

The RideFlow Simulator architecture adheres to strict enterprise software engineering principles to ensure zero tech-debt accumulation, high performance, complete offline resilience, and seamless testability.

### 1.1 Core Philosophies Table

| Principle | Core Meaning | Enforcement Mechanism |
| :--- | :--- | :--- |
| **Offline First** | The application must function 100% locally using Hive without requiring active remote server connectivity. | Repositories fall back on Hive local boxes; UI never assumes internet access. |
| **Clean Architecture** | Strict decoupling of UI, Domain Logic, and Infrastructure. Dependencies point inward only. | Layer-boundary lint rules and strict package isolation. |
| **Modular Design / Feature First** | Code is structured by business capability, not technical file types. | Modules reside in `lib/features/<feature>/` with autonomous data, domain, and presentation packages. |
| **SOLID Principles** | SRP, OCP, LSP, ISP, and DIP strictly enforced across all classes. | Interface abstractions for every repository and service; explicit single-responsibility classes. |
| **DRY (Don't Repeat Yourself)** | Shared logic and UI widgets must be consolidated in `core/` or `shared/`. | Mandatory widget and utility duplication checks during code reviews. |
| **KISS & YAGNI** | Keep It Simple, Stupid & You Aren't Gonna Need It. Avoid speculative abstractions. | PR reviews reject over-engineered patterns or unrequested features. |
| **Testability & Scalability** | All state, side effects, and simulation timing must be mockable and deterministic. | Riverpod dependency injection and explicit time/GPS providers. |
| **Readability & Reusability** | Code is written primarily for human and AI comprehension and long-term maintainability. | Self-documenting code, strict linting, and mandatory API documentation on public interfaces. |

---

## 2. Project Structure

The project follows a **Feature-First + Clean Architecture** layout.

```
lib/
├── main.dart                          # Application entry point
├── app/                               # Root application bootstrap
│   ├── app.dart                       # MaterialApp.router configuration
│   ├── router/                        # GoRouter definitions & navigation guards
│   ├── theme/                         # Material 3 themes, color palettes, typography
│   └── observers/                     # ProviderObserver & RouteObserver implementations
├── core/                              # Global shared infrastructure
│   ├── components/                    # Global atomic UI widgets (Buttons, Inputs, Cards)
│   ├── constants/                     # Global constants (Storage keys, Asset paths, Configs)
│   ├── errors/                        # Custom Failure & Exception hierarchies
│   ├── network/                       # Connectivity checks & network status observers
│   ├── services/                      # Low-level platform adapters (Location, Haptics, Storage)
│   ├── utils/                         # Pure utility functions, formatters, and extensions
│   └── value_objects/                 # Shared value objects (LatLng, Money, Distance)
├── simulation/                        # Independent Simulation Engine
│   ├── engine/                        # Tick loop, physics timers, clock controller
│   ├── generators/                    # Driver, surge pricing, & traffic demand generators
│   ├── gps/                           # Route interpolation, bearing math, dead reckoning
│   └── state/                         # State machine & simulation stream controllers
└── features/                          # Feature Modules (Feature-First Architecture)
    ├── auth/                          # Authentication Module
    │   ├── data/                      # Auth DTOs, Hive Data Sources, Repository Implementations
    │   ├── domain/                    # Auth Entities, Value Objects, Repository Interfaces, Use Cases
    │   └── presentation/              # Riverpod Notifiers, UI Screens, Component Widgets
    ├── ride_booking/                  # Ride Booking & Dispatch Module
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── ride_tracking/                 # Live Simulation & Trip Tracking Module
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── payment/                       # Wallet, Fare Calculation & Payment Module
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    ├── history/                       # Ride History & Ledger Module
    │   ├── data/
    │   ├── domain/
    │   └── presentation/
    └── profile/                       # User Profile & Driver Settings Module
        ├── data/
        ├── domain/
        └── presentation/
```

---

## 3. Development Workflow

Development progresses strictly through 12 sequential phases. No phase may begin until the preceding phase satisfies its Quality Gate.

### Workflow Phases Matrix

| Phase | Phase Name | Primary Focus | Key Deliverables | Quality Gate Criteria |
| :---: | :--- | :--- | :--- | :--- |
| **0** | Environment Setup | CI/CD, Linting, Architecture | `analysis_options.yaml`, directory structure, CI pipeline | `flutter analyze` 0 issues, pipeline green |
| **1** | Foundation | Material 3 Theme, Core UI, Hive Base | `AppTheme`, generic Hive adapters, core UI kit | 100% unit test pass on core utilities |
| **2** | Authentication | Local Auth, User Session, Security | `AuthRepository`, `AuthNotifier`, Login/Register UI | Session persistence verified across restarts |
| **3** | Home & Map Engine | Interactive Map Canvas, Drivers | Map view widget, driver pin rendering, location service | 60 FPS map panning & zero memory leaks |
| **4** | Ride Booking | Search, Fare Estimation, Dispatch | Search UI, route math, fare engine, driver matching | Fare calculation unit tests 100% pass |
| **5** | Ride Tracking | Live Simulation Engine, GPS | `SimulationEngine`, tick loop, live vehicle interpolation | Deterministic route traversal verified |
| **6** | Payment & Wallet | Fare Settlement, Digital Wallet | Wallet ledger, transaction DTOs, payment UI | Double-entry balance calculation test pass |
| **7** | History & Ledger | Ride Logs, Filtering, Receipts | Hive history boxes, paginated ride list, receipt UI | Fast query performance (<10ms for 1k items) |
| **8** | Profile & Driver Mode | User Profile, Driver Toggle | Driver mode state, vehicle profile manager | Smooth role-switching state transition |
| **9** | Settings & Config | Engine Controls, Parameters | Simulation parameter panel, speed controls | Real-time simulation parameter adjustment |
| **10**| Optimization | Memory, Battery, Frame Rate | Lazy loading, repaint boundary optimization | Cold start < 1.5s, 0 dropped frames |
| **11**| Quality & Testing | End-to-End Suite & Goldens | Full integration suite, golden tests, QA report | Test coverage > 85%, all gates passed |

---

## 4. Task Breakdown

### Phase 0: Environment Setup
* **Task 0.1:** Initialize Flutter project with standard Android/iOS configuration.
* **Task 0.2:** Configure `analysis_options.yaml` with strict rules (no implicit casts, absolute imports, const constructors).
* **Task 0.3:** Set up directory hierarchy according to Section 2.
* **Task 0.4:** Configure `pubspec.yaml` with locked dependencies (`flutter_riverpod`, `hive`, `go_router`, `freezed`).
* **Task 0.5:** Establish GitHub Actions CI workflow for automated testing and static analysis.

### Phase 1: Foundation
* **Task 1.1:** Create `AppColorScheme` and Material 3 `ThemeData` for Light and Dark modes.
* **Task 1.2:** Build reusable UI components (`PrimaryButton`, `InputField`, `CustomCard`, `LoadingOverlay`).
* **Task 1.3:** Configure `GoRouter` setup with root shell routes and global error screen.
* **Task 1.4:** Initialize Hive storage engine, register base type adapters, and wrap initializations in `core/services/storage_service.dart`.
* **Task 1.5:** Implement core exception handling (`Failure` objects and `Either` / result pattern constructs).

### Phase 2: Authentication
* **Task 2.1:** Define `UserEntity` and `UserAuthModel` Hive DTO.
* **Task 2.2:** Build `AuthRepository` interface and local Hive implementation (`AuthRepositoryImpl`).
* **Task 2.3:** Create `AuthNotifier` with Riverpod for managing login state, session validation, and logout.
* **Task 2.4:** Build `LoginScreen` and `RegisterScreen` with form validation.
* **Task 2.5:** Add GoRouter authentication redirection guards based on session state.

### Phase 3: Home & Map Engine
* **Task 3.1:** Integrate custom map canvas component.
* **Task 3.2:** Implement `LocationService` wrapper for current position tracking.
* **Task 3.3:** Build simulated surrounding driver pin generator (`DriverLocationGenerator`).
* **Task 3.4:** Create `HomeScreen` layout with floating panel bottom sheets.
* **Task 3.5:** Build real-time map marker updates using Riverpod stream providers.

### Phase 4: Ride Booking
* **Task 4.1:** Build `DestinationSearchScreen` with autocompletion list interface.
* **Task 4.2:** Implement `FareCalculator` domain service supporting Economy, Comfort, and Executive tiers.
* **Task 4.3:** Build `VehicleTierSelector` UI component.
* **Task 4.4:** Create `RideRequestRepository` interface and Hive persistence.
* **Task 4.5:** Implement matching workflow state machine (`Searching`, `DriverAssigned`, `DriverArrived`).

### Phase 5: Simulation Engine & Ride Tracking
* **Task 5.1:** Create core `SimulationEngine` managing 1000ms ticker loop.
* **Task 5.2:** Build `GPSInterpolator` for continuous movement along polyline points.
* **Task 5.3:** Create `RideTrackingScreen` with live vehicle animation and live ETA readout.
* **Task 5.4:** Implement simulation control triggers (Speedup 1x/2x/5x, cancel ride, simulated signal loss).
* **Task 5.5:** Implement in-app notification engine for trip updates.

### Phase 6: Payment & Wallet
* **Task 6.1:** Build `WalletEntity` and `TransactionEntity` models.
* **Task 6.2:** Create `PaymentRepository` for processing simulated transactions.
* **Task 6.3:** Build `WalletScreen` displaying current balance and transaction history.
* **Task 6.4:** Implement automated fare deduction on ride completion.

### Phase 7: History & Ledger
* **Task 7.1:** Build `RideHistoryRepository` with query filters (completed, cancelled, date range).
* **Task 7.2:** Build `RideHistoryScreen` with paginated list view.
* **Task 7.3:** Create `RideDetailScreen` with route breakdown and receipt download view.

### Phase 8: Profile & Driver Mode
* **Task 8.1:** Build `ProfileScreen` for editing user details and vehicle options.
* **Task 8.2:** Implement `DriverModeNotifier` allowing seamless toggle between Passenger and Driver UI.
* **Task 8.3:** Build Driver Ride Acceptance interface.

### Phase 9: Settings & Simulation Control
* **Task 9.1:** Build `SettingsScreen` for dark mode toggles and storage clearing.
* **Task 9.2:** Create `SimulationConfigPanel` to adjust traffic density, driver speed, and failure rates.

### Phase 10: Optimization
* **Task 10.1:** Add `RepaintBoundary` wrappers to map layers and dynamic widgets.
* **Task 10.2:** Optimize Hive read/write caching layer.
* **Task 10.3:** Conduct memory profiling and fix stream listener leakages.

### Phase 11: Testing & QA
* **Task 11.1:** Write unit tests for all Use Cases and Notifiers.
* **Task 11.2:** Write widget tests for all shared UI elements and main screens.
* **Task 11.3:** Build Golden tests for key UI flows across screen sizes.
* **Task 11.4:** Execute end-to-end integration test runner.

---

## 5. Sprint Planning

### Sprint Roadmap

```
+-----------------------------------------------------------------------------------+
| Sprint 1: Setup & Foundation (Phases 0-1)                                        |
+-----------------------------------------------------------------------------------+
| Sprint 2: Authentication & Map Canvas (Phases 2-3)                               |
+-----------------------------------------------------------------------------------+
| Sprint 3: Ride Booking & Dispatch (Phase 4)                                       |
+-----------------------------------------------------------------------------------+
| Sprint 4: Simulation Engine & Live Tracking (Phase 5)                             |
+-----------------------------------------------------------------------------------+
| Sprint 5: Payment, History & Profile (Phases 6-8)                                |
+-----------------------------------------------------------------------------------+
| Sprint 6: Config, Optimization, Testing & Release (Phases 9-11)                   |
+-----------------------------------------------------------------------------------+
```

* **Sprint 1 Goal:** Establish production infrastructure, theme engine, and core Hive storage wrappers.
* **Sprint 2 Goal:** Complete user authentication flow and render interactive map with driver location pins.
* **Sprint 3 Goal:** Deliver end-to-end destination search, route calculation, vehicle selection, and booking dispatch.
* **Sprint 4 Goal:** Deliver the Simulation Engine, ticker, GPS path interpolation, and real-time trip tracking screen.
* **Sprint 5 Goal:** Complete payment deductions, wallet management, ride history ledger, and user profile management.
* **Sprint 6 Goal:** Implement simulation control panel, complete performance optimizations, and achieve >85% test coverage.

---

## 6. Coding Standards

### 6.1 General Dart Rules
* **Effective Dart Compliance:** Strictly follow Effective Dart guidelines for Style, Documentation, Usage, and Design.
* **Sound Null Safety:** Never use the null-assertion operator (`!`) unless guaranteed by explicit checks or prior assertions. Prefer optional chaining (`?.`) or default fallbacks (`??`).
* **Immutability:** Mark all Domain entities, value objects, and Riverpod states as `@immutable` or define them using `Freezed`.
* **Explicit Typing:** Always explicitly define return types for methods and public functions. Avoid implicit `var` when the type isn't immediately obvious from the constructor.

### 6.2 Architectural Standards
* **Clean Boundaries:** Code in `domain/` must never import `flutter/material.dart`, `hive`, or any Presentation code.
* **Repository Pattern:** Presentation layer interacts exclusively with Repositories through Domain Use Cases or Notifiers.
* **Value Objects:** Encapsulate primitive types (e.g., coordinates, currency) into custom immutable value objects with built-in validation.

---

## 7. Naming Conventions

| Artifact | Convention | Pattern / Example |
| :--- | :--- | :--- |
| **Folders** | Lowercase snake_case | `lib/features/ride_booking/presentation/` |
| **Files** | Lowercase snake_case | `ride_request_notifier.dart` |
| **Classes / Interfaces** | UpperCamelCase | `RideRepositoryImpl`, `UserEntity` |
| **Widgets** | UpperCamelCase | `PrimaryButton`, `RideTrackingScreen` |
| **Providers** | LowerCamelCase with Provider suffix | `authNotifierProvider`, `rideHistoryProvider` |
| **Models / DTOs** | UpperCamelCase with Model suffix | `RideDtoModel`, `UserHiveModel` |
| **Enums** | UpperCamelCase (Values UpperCamel) | `enum RideStatus { searching, accepted, inTransit }` |
| **Constants** | LowerCamelCase | `kDefaultAnimationDuration`, `kMaxDriverSearchRadius` |
| **Variables / Methods** | LowerCamelCase | `calculateFare()`, `currentLocation` |
| **Database Boxes** | Lowercase snake_case string constant | `static const String ridesBox = 'rides_box'` |

---

## 8. Flutter Standards

### 8.1 Widget Construction Rules
* **Widget Size Limit:** No single `Widget.build()` method may exceed 80 lines of code. Split complex layouts into smaller private or modular public sub-widgets.
* **Const Usage:** Always use `const` constructors for immutable widgets to prevent unnecessary rebuilds.
* **Prefer Composition:** Favor Composition over Inheritance. Avoid extending base screen classes; use wrapper widgets or mixins instead.
* **Explicit Imports:** Use relative imports for intra-feature files (`import '../domain/user.dart';`) and package imports for cross-feature/core imports (`import 'package:rideflow/core/...';`). Never use `import 'file:///...` path imports.

### 8.2 Layout & Performance
* **Repaint Boundaries:** Wrap frequently updating UI elements (such as animated map markers or simulation timers) in `RepaintBoundary` widgets.
* **List Optimization:** Always use `ListView.builder` or `CustomScrollView` with slivers for dynamic lists. Never use `ListView(children: [])` for lists of unknown size.
* **Responsive Spacing:** Avoid hardcoded layout dimensions. Use standard spacing constants (`AppSpacing.sm`, `AppSpacing.md`, `AppSpacing.lg`).

---

## 9. Riverpod Standards

### 9.1 State Management Rules
* **Notifier Standard:** Use `Notifier` or `AsyncNotifier` (Riverpod 2.x+) with code generation where applicable. Avoid legacy `StateNotifier` for new code.
* **State Classes:** State objects must be immutable. Use `freezed` or custom `copyWith` methods for state transitions.
* **AutoDispose:** Default to `AutoDispose` providers for feature screens to ensure state is purged from memory when screens unmount. Hold global providers (`authProvider`, `databaseProvider`) in memory explicitly.

```dart
// Preferred Provider Pattern Example
@riverpod
class RideBookingNotifier extends _$RideBookingNotifier {
  @override
  RideBookingState build() {
    return const RideBookingState.initial();
  }

  Future<void> requestRide(Location destination) async {
    state = const RideBookingState.loading();
    final result = await ref.read(rideRepositoryProvider).createRequest(destination);
    state = result.fold(
      (failure) => RideBookingState.error(failure.message),
      (ride) => RideBookingState.success(ride),
    );
  }
}
```

---

## 10. Architecture Rules & Layer Hierarchy

### 10.1 Layer Dependencies

```
[ Presentation Layer ] ──> [ Domain Layer (Interfaces & Entities) ] <── [ Data Layer ]
         │                                                                   │
         └───────────────────────> [ Core / Shared ] <───────────────────────┘
```

### 10.2 Layer Constraints
1. **Domain Layer:** Pure Dart only. Absolutely zero external framework dependencies (No Flutter UI, No Hive, No HTTP). Defines domain entities and repository interfaces.
2. **Data Layer:** Implements domain repository interfaces. Handles Hive serialization, DTO mapping, and local persistence.
3. **Presentation Layer:** Renders UI screens using Material components and manages local view state via Riverpod. Never calls Hive or Data Sources directly.
4. **Simulation Layer:** Operates as an autonomous domain/data generator. Exposes pure stream interfaces that feed into the application repositories.

---

## 11. Database Rules (Hive)

* **Hive Type IDs:** Explicitly assign fixed `@HiveType(typeId: X)` annotations to every model to avoid ID collisions.
  * `0`: UserHiveModel
  * `1`: RideHiveModel
  * `2`: VehicleHiveModel
  * `3`: TransactionHiveModel
* **Repository Access:** All Hive boxes must be accessed exclusively through repository implementations. Direct box operations inside widgets are strictly banned.
* **Model Separation:** Maintain separate models for Hive DTOs (`UserHiveModel`) and Domain Entities (`UserEntity`). Require explicit extension mappers (`toDomain()` and `toModel()`).

---

## 12. Simulation Engine Rules

The **Simulation Engine** is a core component of RideFlow Simulator, acting as the local back-end server.

```
┌─────────────────────────────────────────────────────────┐
│                     SIMULATION ENGINE                   │
│                                                         │
│  ┌──────────────────┐             ┌──────────────────┐  │
│  │ Driver Generator │             │  GPS Interpolator│  │
│  └────────┬─────────┘             └────────┬─────────┘  │
│           │                                │            │
│           ▼                                ▼            │
│  ┌───────────────────────────────────────────────────┐  │
│  │           Core Ticker (1000ms Loop)               │  │
│  └────────────────────────┬──────────────────────────┘  │
└───────────────────────────┼─────────────────────────────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │ Ride State Stream       │
               └────────────┬────────────┘
                            │
                            ▼
               ┌─────────────────────────┐
               │  Presentation / Maps UI │
               └─────────────────────────┘
```

* **Core Ticker:** Runs on an isolated periodic timer (1000ms tick interval). Supports multiplier factors (1x, 2x, 5x speed).
* **GPS Interpolation:** Calculates intermediate latitude/longitude points along polyline coordinates using Haversine and Bearing algorithms.
* **State Machine:** Enforces strict trip status progression:
  `Idle -> Searching -> Assigned -> EnRouteToPickup -> ArrivedAtPickup -> InTransit -> Completed`.
* **Failure Injections:** Configurable simulation settings can inject mock events like driver cancellation, GPS signal drift, or payment failure.

---

## 13. Performance Standards

* **Target Frame Rate:** Maintained strictly at **60 FPS** (16.6ms frame rendering budget).
* **Cold Start Time:** Application must be fully responsive within **1.5 seconds** on target mid-range devices.
* **Memory Management:** Maximum allocation under normal simulation operations must not exceed **150 MB**.
* **Image Assets:** All images must be compressed WebP or vector SVGs. Raster images must specify explicit pixel bounds in `AssetImage`.
* **Rebuild Optimization:** Use `select` in Riverpod listeners (`ref.watch(provider.select((s) => s.targetProperty))`) to avoid unnecessary widget rebuilds.

---

## 14. Security Standards

* **Sensitive Data:** API keys, local tokens, and user credentials must be stored using `FlutterSecureStorage` (EncryptedSharedPreferences on Android, Keychain on iOS), never plain Hive boxes.
* **Input Validation:** All user inputs (phone numbers, payment amounts, addresses) must be sanitized and validated using domain rules before processing.
* **Logging:** Production builds must strip all `debugPrint` and `print` statements using custom logging wrappers (`AppLogger`) disabled in release mode.

---

## 15. Testing Standards

* **Coverage Target:** Minimum **85% overall test coverage** required across Domain and Presentation layers.

```
       /       /   \     Integration Tests (E2E workflows)
     /-----    /       \    Widget & Golden Tests (UI fidelity & components)
   /---------  /           \  Unit Tests (Domain Use Cases, Notifiers, Calculations)
 /-------------```

### 15.1 Unit Testing Guidelines
* Every Use Case and Riverpod Notifier must have a corresponding `.test.dart` file.
* Mock dependencies using `mocktail`. Never execute actual storage/network code during unit tests.

### 15.2 Widget & Golden Testing
* All shared components in `core/components/` must have Golden tests covering Light and Dark themes.

---

## 16. Git Standards

### 16.1 Branching Strategy
* `main`: Production-ready releases.
* `develop`: Integration branch for completed features.
* `feature/<feature-name>`: Feature development branches.
* `fix/<bug-description>`: Bug fix branches.

### 16.2 Commit Message Format (Conventional Commits)
Format: `<type>(<scope>): <short description>`

* `feat(booking)`: Add vehicle tier selector widget
* `fix(simulation)`: Correct GPS bearing calculation on turn points
* `refactor(auth)`: Extract session storage into separate service
* `test(wallet)`: Add unit tests for fare deduction logic

---

## 17. AI Coding Instructions

**MANDATORY RULES FOR AI CODING ASSISTANTS:**

1. **Architecture Rule:** Never write business logic directly inside UI Widgets. Always route through Riverpod Notifiers and Domain Use Cases.
2. **Layer Boundary:** Never import Hive or Data models inside `lib/features/*/presentation/` or `lib/features/*/domain/`.
3. **Widget Reusability:** Before generating new UI elements, inspect `lib/core/components/` to reuse existing components. Never duplicate button or text field implementations.
4. **Hardcoding:** Never hardcode layout colors, padding values, or strings directly inside widgets. Use `Theme.of(context)`, `AppSpacing`, and localized string constants.
5. **Error Handling:** Never swallow exceptions silently. Wrap dynamic operations in `Either<Failure, T>` constructs and propagate errors to the UI state.
6. **File Constraints:** No single source file generated by AI may exceed **300 lines of code**. If a file grows larger, decompose it into smaller modular sub-components.

---

## 18. Quality Gates

Before any phase or feature pull request is marked as complete, it must pass the following Quality Gate checklist:

- [ ] `flutter analyze` returns zero warnings or errors.
- [ ] `dart format --set-exit-if-changed .` passes cleanly.
- [ ] All new and existing unit tests pass (`flutter test`).
- [ ] Code coverage requirements met for modified features (>85%).
- [ ] Zero hardcoded styling or color values present in presentation layer.
- [ ] Public API methods documented with Dart doc comments (`///`).

---

## 19. Definition of Done (DoD)

### Feature-Level DoD Checklist
- [ ] Requirements from PRD fully implemented.
- [ ] UI matches design tokens and functions in both Light and Dark modes.
- [ ] Unit tests written for Notifiers and Domain logic.
- [ ] Widget tests written for major screens.
- [ ] Code reviewed and approved by Tech Lead / AI Validator.
- [ ] Verified offline operation on local emulator device.

---

## 20. Risk Register

| Risk ID | Description | Impact | Probability | Mitigation Strategy | Owner |
| :---: | :--- | :---: | :---: | :--- | :--- |
| **R-01** | High UI frame drops during fast simulation ticks | High | Medium | Isolate ticker execution from UI thread; wrap map markers in `RepaintBoundary`. | Mobile Lead |
| **R-02** | Hive schema corruption during app updates | High | Low | Implement explicit Hive migration adapters and versioned box keys. | Data Lead |
| **R-03** | Excessive state rebuilds caused by unoptimized Riverpod watches | Medium | High | Enforce `ref.watch(provider.select(...))` across all presentation components. | Architect |

---

## 21. Developer Checklist

### Daily Development Workflow
1. **Before Coding:**
   - Pull latest `develop` branch.
   - Run `flutter pub get`.
2. **While Coding:**
   - Follow strict naming and architectural conventions.
   - Run tests locally for the feature under edit (`flutter test test/features/...`).
3. **Before Commit:**
   - Run `flutter analyze`.
   - Run `dart format .`.
4. **Before PR Merge:**
   - Ensure green CI pipeline build.
   - Obtain minimum 1 peer code review approval.

---

## 22. Future Scalability & Backend Migration Path

Although **RideFlow Simulator** operates as an offline-first local application, the architecture is designed for seamless future migration to remote backends (Firebase, Supabase, Node.js REST / GraphQL).

```
                      ┌─────────────────────────────────┐
                      │          Domain Layer           │
                      │     (RideRepository Interface)  │
                      └────────────────┬────────────────┘
                                       │
                ┌──────────────────────┴──────────────────────┐
                │                                             │
                ▼                                             ▼
┌───────────────────────────────┐             ┌───────────────────────────────┐
│     Hive Local Storage        │             │      Remote REST / GraphQL    │
│   (Current Implementation)    │             │    (Future Implementation)    │
└───────────────────────────────┘             └───────────────────────────────┘
```

### Migration Guidelines
1. **Repository Abstraction:** Because presentation code relies exclusively on abstract interfaces (`RideRepository`), switching from local Hive storage to remote APIs requires zero changes to UI or Notifier logic.
2. **Data Model Decoupling:** Remote DTOs (e.g., `RideResponseDto`) can be introduced in the `data/` layer alongside `toDomain()` mappers without touching existing domain entities.
3. **Authentication Swap:** `AuthRepositoryImpl` can be updated to delegate session tokens to Firebase Auth or OAuth endpoints while preserving the outer contract.

---
*End of Master Engineering Guide — RideFlow Simulator*
