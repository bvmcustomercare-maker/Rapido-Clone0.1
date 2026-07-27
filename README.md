# RideFlow Simulator 🚗

A fully **offline** Flutter ride-booking simulator built with Clean Architecture, Riverpod, Hive, and Google Maps Flutter.

---

## 🚀 Quick Start

### 1. Prerequisites
- Flutter SDK ≥ 3.0.0
- Android Studio / VS Code with Flutter plugin
- A Google Maps API key (Android + iOS)

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Download & Add Fonts
Download **Inter** from [Google Fonts](https://fonts.google.com/specimen/Inter) and place these files in `assets/fonts/`:
- `Inter-Regular.ttf`
- `Inter-Medium.ttf`
- `Inter-SemiBold.ttf`
- `Inter-Bold.ttf`

> **Skip fonts quickly:** In `lib/core/theme/app_theme.dart`, change `fontFamily: 'Inter'` to `fontFamily: null` to use the system font.

### 4. Configure Google Maps API Key

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

**iOS** — `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

### 5. Run the App
```bash
flutter run
```

---

## 🏗️ Architecture

```
lib/
├── app/
│   └── router/         # GoRouter — all 25 routes
├── core/
│   ├── constants/      # Colors, Typography, Spacing, Routes, Strings
│   ├── theme/          # ThemeData (light + dark) + RideFlowTokens extension
│   └── utils/          # GeoUtils, FormatUtils, ValidationUtils
├── data/
│   └── models/         # Hive models + manual TypeAdapters (.g.dart)
├── services/
│   ├── storage/        # HiveService (box initializer & accessors)
│   └── simulation/     # DriverGenerator + SimulationEngine
└── presentation/
    ├── providers/       # Riverpod StateNotifiers (auth, location, ride, settings)
    ├── screens/         # 25 screens across 12 feature folders
    └── widgets/         # Shared UI components
```

---

## 📱 Screen Flow

```
Splash → Onboarding → Login → OTP → Signup → Home
Home → Location Search → Map Pin Select → Confirm Ride
→ Searching → Driver Assigned → Live Ride → Ride Complete
→ Payment → Payment Success → Rating → Home
Profile → Edit Profile / Statistics
Settings → About
History → Ride Detail
Notifications
```

---

## 🗺️ Hive Storage

| Box         | TypeId | Model         |
|-------------|--------|---------------|
| `users`     | 0      | `UserModel`   |
| `rides`     | 1      | `RideModel`   |
| `locations` | 2      | `LocationModel` |
| `drivers`   | 3      | `DriverModel` |
| `session`   | —      | raw key-value |
| `settings`  | —      | raw key-value |

---

## 🛡️ Key Design Decisions

- **100% offline** — No real backend, GPS, or network calls
- **Simulated GPS** — `SimulationEngine` ticks driver position along interpolated polyline
- **4-digit OTP** — Indian standard (not 6-digit), generated in `DriverGenerator`
- **Manual fare entry** — User sets fare (₹1–₹99,999); no backend fare calculation
- **Indian context** — 40+ landmark locations, Indian driver names, Indian number plates

---

## 🎨 Design System

- **Primary color**: Mobility Yellow `#FFD400`
- **Font**: Inter (Google Fonts)
- **Grid**: 8-point spacing system
- **Themes**: Light & Dark mode with `ThemeExtension<RideFlowTokens>`
