# RideFlow Simulator
## Product Requirements Document (PRD)
### Version 1.0 | July 2026

---

> **Confidential — Internal Development Document**
> This document is intended for the development team, designers, and project stakeholders only.

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Product Vision](#2-product-vision)
3. [Product Goals](#3-product-goals)
4. [User Personas](#4-user-personas)
5. [User Journey](#5-user-journey)
6. [Functional Requirements](#6-functional-requirements)
7. [Non-Functional Requirements](#7-non-functional-requirements)
8. [UI/UX Specifications](#8-uiux-specifications)
9. [Design System](#9-design-system)
10. [Navigation Flow](#10-navigation-flow)
11. [Information Architecture](#11-information-architecture)
12. [Database Design](#12-database-design)
13. [Folder Structure](#13-folder-structure)
14. [State Management](#14-state-management)
15. [Simulation Engine](#15-simulation-engine)
16. [Local Storage Design](#16-local-storage-design)
17. [Animation Guidelines](#17-animation-guidelines)
18. [Edge Cases](#18-edge-cases)
19. [Error Handling](#19-error-handling)
20. [Future Roadmap](#20-future-roadmap)
21. [Technical Recommendations](#21-technical-recommendations)
22. [Development Milestones](#22-development-milestones)
23. [QA Checklist](#23-qa-checklist)
24. [Acceptance Criteria](#24-acceptance-criteria)
25. [Appendix](#25-appendix)

---

## 1. Executive Summary

**Project Name:** RideFlow Simulator
**Platform:** Android (Primary), iOS and Web (Future)
**Type:** Simulated Mobile Application
**Technology:** Flutter + Dart
**Development Mode:** Fully Offline, No Backend Required
**Purpose:** Learning, UI/UX Practice, Portfolio Presentation, Offline Demonstrations

RideFlow Simulator is a fully simulated ride-booking mobile application built using Flutter. It replicates the complete end-to-end experience of a real-world ride-hailing application — from splash screen through to ride completion and driver rating — without any real backend, real drivers, real payments, or real GPS data.

Every interaction is simulated locally on the device. The application is designed to be visually indistinguishable from a production ride-booking app. It is built for developers, UX students, product managers, and anyone who needs a realistic, demonstrable, offline-capable ride-booking experience for portfolio or learning purposes.

The application does not use, replicate, or copy any copyrighted assets, layouts, brand identities, or proprietary designs from Rapido, Uber, Ola, Lyft, or any other ride-hailing company.

---

## 2. Product Vision

> "To create the most realistic, visually premium, and technically excellent simulated ride-booking experience — one that feels so real, the user forgets it is a simulation."

RideFlow Simulator should serve as a gold-standard example of what a Flutter mobile application can achieve in terms of:

- UI/UX polish and animation quality
- Realistic simulation fidelity
- Clean architecture and code maintainability
- Offline-first design
- Accessibility and performance

The application exists at the intersection of education and demonstration — it teaches through doing and impresses through fidelity.

---

## 3. Product Goals

### 3.1 Primary Goals

| # | Goal | Success Metric |
|---|------|----------------|
| G1 | Deliver a realistic ride-booking simulation | User cannot distinguish from real app in demo |
| G2 | Run entirely offline on a single Android device | Zero network calls required for core flow |
| G3 | Achieve 60 FPS smooth animations throughout | No jank or frame drops on mid-range devices |
| G4 | Build with clean, maintainable Flutter architecture | Code review score > 90% |
| G5 | Allow manual fare entry by user | Any value ₹1–₹99,999 accepted |
| G6 | Store all ride history locally | 100% offline persistence |
| G7 | Support dark and light mode | Both modes complete and polished |
| G8 | Generate realistic random drivers dynamically | Every booking produces a unique driver profile |

### 3.2 Secondary Goals

- Serve as a portfolio-quality Flutter project
- Demonstrate advanced state management patterns
- Showcase Google Maps integration with animated simulation
- Provide a reference implementation for ride-booking UI patterns

---

## 4. User Personas

### 4.1 Persona 1 — The Flutter Developer

**Name:** Arjun Mehta
**Age:** 24
**Role:** Junior Flutter Developer
**Goal:** Learn how to build complex multi-screen apps with real-world patterns
**Frustration:** Tutorials are too simple; no real-world example to study
**How RideFlow Helps:** Complete production-grade codebase to learn from

---

### 4.2 Persona 2 — The UX Design Student

**Name:** Priya Sharma
**Age:** 22
**Role:** UI/UX Design Student
**Goal:** Build a portfolio with a realistic app prototype
**Frustration:** Static Figma mockups don't impress; needs interactive demos
**How RideFlow Helps:** Live, tappable, animated app for portfolio presentation

---

### 4.3 Persona 3 — The Product Manager

**Name:** Rahul Verma
**Age:** 31
**Role:** Product Manager at a startup
**Goal:** Demo a ride-booking concept to investors without building a real backend
**Frustration:** Real apps need servers, drivers, payments — too expensive to demo
**How RideFlow Helps:** Full end-to-end simulation, investor-ready on day one

---

### 4.4 Persona 4 — The Coding Trainer

**Name:** Sneha Kapoor
**Age:** 35
**Role:** Flutter Bootcamp Instructor
**Goal:** Use a real-world app as a teaching reference in workshops
**Frustration:** Most sample apps are too simple or too outdated
**How RideFlow Helps:** A professional codebase that covers every major Flutter topic

---

## 5. User Journey

### 5.1 Complete User Flow

```
┌─────────────────────────────────────────────────────────┐
│                      SPLASH SCREEN                      │
│              Logo Animation + Brand Load                │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                    ONBOARDING (3 Slides)                │
│         Feature Highlights + Get Started CTA            │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                  LOGIN / SIGNUP                          │
│         Phone Number → OTP → Profile Setup              │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│               LOCATION PERMISSION                       │
│         Request + Handle Grant/Deny                     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│                   HOME SCREEN                           │
│   Map + Pickup/Drop Input + Vehicle Cards + Fare Box    │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              LOCATION SELECTION                         │
│         Search + Recent + Favourites + Map Pin          │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              VEHICLE SELECTION                          │
│        Bike / Auto / Cab + Details + Select             │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              MANUAL FARE INPUT                          │
│         User enters any fare amount manually            │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              CONFIRM RIDE SCREEN                        │
│      Summary: Pickup, Drop, Vehicle, Fare, Payment      │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              SEARCHING DRIVER                           │
│      Animation + Nearby Drivers + Random Delay          │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              DRIVER ASSIGNED                            │
│    Driver Card: Name, Photo, Rating, Vehicle, OTP       │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              CAPTAIN ARRIVING                           │
│   Live Map: Driver Moving to Pickup + ETA Countdown     │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              RIDE STARTED                               │
│    Live Map: Moving to Destination + Trip Meter         │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              RIDE COMPLETED                             │
│      Arrival Animation + Trip Summary Card              │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              PAYMENT SCREEN                             │
│     Method Selection + Amount + Success Animation       │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              RATING SCREEN                              │
│      Star Rating + Tags + Comment + Submit              │
└─────────────────────┬───────────────────────────────────┘
                      │
                      ▼
┌─────────────────────────────────────────────────────────┐
│              HOME SCREEN                                │
│              Ready for Next Ride                        │
└─────────────────────────────────────────────────────────┘
```

---

## 6. Functional Requirements

### 6.1 Authentication Module

#### FR-AUTH-001: Fake Phone Login
- User enters a 10-digit phone number
- System simulates OTP sending (shows toast: "OTP sent to XXXXXXXXXX")
- User enters any 4 or 6 digit OTP — all OTPs are accepted
- On success, navigate to profile setup or home (if returning user)
- Store session locally using Hive

#### FR-AUTH-002: Fake Signup
- New user enters: Name, Phone, Email (optional), Profile Photo (optional)
- All fields stored locally
- No validation against any real database
- Auto-login after signup

#### FR-AUTH-003: OTP Simulation
- Display animated OTP input field
- Accept any numeric OTP (4 or 6 digits configurable)
- Show fake "Verifying..." loader for 1.5 seconds
- Show success animation on acceptance
- Show error animation if non-numeric characters entered

#### FR-AUTH-004: Session Management
- Remember logged-in user across app restarts
- Auto-navigate to home if session exists
- Provide logout option in profile/settings

#### FR-AUTH-005: Profile Management
- Edit name, phone, email
- Change profile photo (from gallery or camera)
- View ride statistics on profile page

---

### 6.2 Home Screen Module

#### FR-HOME-001: Google Map Display
- Show Google Map centered on current (simulated) location
- Display custom map style (dark or light based on theme)
- Show animated current location marker
- Show pickup and drop markers when set

#### FR-HOME-002: Location Input
- "Where to go?" input box as floating card
- Tap to open full-screen location search
- Show current location as default pickup
- Allow manual pickup location change

#### FR-HOME-003: Recent and Favourite Places
- Show last 5 searched locations below search bar
- Allow marking any location as favourite (star icon)
- Show favourites section in location search screen

#### FR-HOME-004: Vehicle Selection Cards
- Horizontal scrollable cards: Bike, Auto, Cab
- Each card shows: icon, name, capacity, description
- Selected card highlights with yellow accent
- Fare not shown here — user enters manually later

#### FR-HOME-005: Manual Fare Input Box
- Text input field below vehicle cards
- Label: "Enter Your Fare (₹)"
- Accepts any numeric value from ₹1 to ₹99,999
- Shows rupee symbol prefix
- Numeric keyboard opens automatically
- Fare persists through entire ride lifecycle

#### FR-HOME-006: Confirm Ride Button
- Yellow pill button at bottom
- Disabled if no destination or fare entered
- Enabled when both destination and fare are set
- Tap navigates to ride confirmation screen

---

### 6.3 Location Search Module

#### FR-LOC-001: Search Interface
- Full-screen overlay with search bar at top
- Back button to dismiss
- Recent places section
- Favourites section
- Simulated search results (use preset list of Indian cities/places)

#### FR-LOC-002: Map Pin Selection
- "Choose on Map" option
- Opens full-screen map with draggable pin
- Confirm button sets location
- Address resolves from coordinates (simulated)

#### FR-LOC-003: Location Data
- Store each searched location in recent list (max 10)
- Deduplicate recent locations
- Allow clearing recent locations from settings

---

### 6.4 Ride Booking Module

#### FR-BOOK-001: Ride Confirmation Screen
- Show summary card:
  - Pickup address
  - Drop address
  - Vehicle type
  - Fare (user entered)
  - Payment method selector
- "Confirm Ride" button

#### FR-BOOK-002: Payment Method Selection
- Options: Cash, UPI, Wallet, Card
- Default: Cash
- Icons for each method
- Selected method highlighted
- No real payment processing

#### FR-BOOK-003: Searching Driver Animation
- Full-screen searching state
- Pulsing radar animation (Lottie)
- "Finding drivers nearby..." text
- Animated nearby driver dots on map
- Random delay: 3–8 seconds before driver found
- Option to cancel during search

#### FR-BOOK-004: Driver Assignment
- After search delay, show driver card (bottom sheet)
- Driver card contains:
  - Driver photo (random avatar)
  - Driver name (randomly generated Indian name)
  - Star rating (4.1–4.9 range)
  - Vehicle number (randomly generated)
  - Vehicle type and color
  - Estimated arrival time (2–8 minutes)
  - 4-digit OTP for ride verification
  - Call button (fake — shows toast)
  - Message button (fake — shows toast)

#### FR-BOOK-005: Captain Arriving State
- Map shows driver marker moving toward pickup
- ETA countdown timer
- Driver card visible at bottom
- "Cancel Ride" option available
- Notification: "Your driver is arriving"

#### FR-BOOK-006: Ride Started State
- Map shows route from pickup to destination
- Driver marker moves along route
- Trip meter (distance + time) counting
- Fare displayed (user's manual entry)
- Emergency SOS button (fake — shows popup)
- Share trip option (fake — shows toast)

#### FR-BOOK-007: Ride Completed State
- Driver marker reaches destination
- "You have arrived!" animation
- Trip summary bottom sheet:
  - Total distance (simulated)
  - Total time
  - Fare
  - Driver name
  - Vehicle

---

### 6.5 Payment Module

#### FR-PAY-001: Payment Screen
- Show fare amount prominently
- Show selected payment method
- "Pay Now" button
- Fake processing animation (1.5 seconds)
- Success screen with Lottie animation
- Receipt details

#### FR-PAY-002: Payment Methods (All Simulated)
- **Cash:** Show "Pay ₹[fare] to driver" message
- **UPI:** Show fake UPI ID input or QR screen → success
- **Wallet:** Show wallet balance (fake ₹500 default) deducted
- **Card:** Show card input fields → fake processing → success

#### FR-PAY-003: Payment Success
- Full-screen success animation (Lottie — green checkmark)
- "Payment Successful" title
- Amount, method, transaction ID (random 12-digit)
- "Rate Your Driver" CTA button

---

### 6.6 Rating Module

#### FR-RATE-001: Rating Screen
- Driver photo + name at top
- 5-star rating selector (tap to select)
- Quick feedback tags: "Good Driver", "Safe Ride", "On Time", "Friendly", "Clean Vehicle"
- Optional comment text box
- "Favourite Driver" toggle
- "Submit" button
- Skip option

#### FR-RATE-002: Rating Storage
- Store rating with ride record locally
- Update driver's average rating in local simulation data

---

### 6.7 Ride History Module

#### FR-HIST-001: History List
- List of all completed rides (newest first)
- Each item shows:
  - Pickup → Drop (short address)
  - Date and time
  - Fare
  - Vehicle type icon
  - Status badge (Completed / Cancelled)
  - Driver name

#### FR-HIST-002: Ride Detail Screen
- Full ride details:
  - Map snapshot (static, showing route)
  - Pickup and drop full addresses
  - Date, time, duration
  - Distance (simulated)
  - Fare
  - Payment method
  - Driver name, photo, rating
  - OTP used
  - User's rating given
- "Rebook" button (pre-fills same locations)

#### FR-HIST-003: History Management
- Filter by: All, Completed, Cancelled
- Search rides by location or date
- Delete individual ride records
- Delete all history (from settings)

---

### 6.8 Profile Module

#### FR-PROF-001: Profile Screen
- Profile photo (editable)
- Name and phone number
- Member since date
- Ride statistics card:
  - Total rides
  - Total distance (simulated sum)
  - Total spent (sum of all fares)
  - Favourite vehicle type

#### FR-PROF-002: Edit Profile
- Edit name
- Edit email
- Change profile photo
- Save button

---

### 6.9 Settings Module

#### FR-SET-001: Settings Screen
Options include:
- Dark Mode toggle
- Language selector (English, Hindi — UI strings only)
- Notification toggle (fake notifications on/off)
- Delete Ride History (with confirmation)
- Reset Application (clears all data, returns to onboarding)
- About RideFlow
- Privacy Policy (static text screen)
- Terms of Service (static text screen)
- App Version display

---

### 6.10 Notification Module

#### FR-NOTIF-001: Fake Local Notifications
- Trigger using flutter_local_notifications
- Notifications fired at each ride stage:

| Trigger | Notification Title | Body |
|---------|-------------------|------|
| Searching starts | Finding your ride | Looking for nearby drivers... |
| Driver found | Driver Assigned! | [Name] is on the way |
| Driver arriving | Almost there! | Your driver is 2 mins away |
| Ride started | Ride Started | Have a safe journey! |
| Ride completed | You've arrived! | Rate your experience |
| Payment success | Payment Done | ₹[fare] paid successfully |

---

## 7. Non-Functional Requirements

### 7.1 Performance

| Requirement | Target |
|-------------|--------|
| App launch time (cold start) | < 2.5 seconds |
| Screen transition time | < 300ms |
| Map render time | < 1 second |
| Animation frame rate | Consistent 60 FPS |
| Memory usage (mid-range device) | < 150 MB RAM |
| APK size | < 30 MB |
| Battery consumption | Minimal — no background GPS |

### 7.2 Compatibility

| Requirement | Specification |
|-------------|---------------|
| Minimum Android version | Android 6.0 (API 23) |
| Target Android version | Android 14 (API 34) |
| Screen sizes supported | 5.0" to 7.0" |
| Orientations | Portrait only |
| Tablet support | Not required (v1.0) |

### 7.3 Reliability

- App must not crash during any standard user flow
- All simulated states must be recoverable (app can be backgrounded and resumed)
- Local data must persist across app restarts
- No data loss on unexpected app closure

### 7.4 Maintainability

- Clean Architecture with clear layer separation
- All business logic in repository/use case layer
- No business logic in widgets
- Minimum 70% code coverage for business logic
- All strings externalized (no hardcoded text in widgets)
- Consistent code style enforced via dart_style and flutter_lints

### 7.5 Accessibility

- All interactive elements minimum 48x48dp touch target
- Sufficient colour contrast (WCAG AA minimum)
- Screen reader support for primary flows
- Font size respects system accessibility settings

### 7.6 Offline Capability

- 100% of core functionality works without internet
- Google Maps tiles may require internet (graceful degradation if offline)
- All ride data stored locally
- No API calls for any simulation logic

---

## 8. UI/UX Specifications

### 8.1 Splash Screen

**Purpose:** Brand introduction and initialization
**Duration:** 2.0–2.5 seconds

**Layout:**
- Full screen black background
- RideFlow logo centered (animated SVG — draw path animation)
- Tagline fades in below logo after 0.8 seconds
- Version number at bottom (subtle, small)
- Progress to onboarding or home after animation completes

**Components:**
- AnimatedLogo widget (custom painter)
- FadeTransition for tagline
- No skip button

**Animation Sequence:**
1. 0ms: Black screen
2. 200ms: Logo path draw begins
3. 800ms: Logo complete, tagline fade begins
4. 1400ms: Tagline fully visible
5. 2200ms: Fade to white → navigate

---

### 8.2 Onboarding Screen

**Purpose:** Introduce key features to new users
**Slides:** 3 slides

**Layout:**
- Full screen with page indicator dots at bottom
- Illustration (Lottie animation) top 55% of screen
- Title text (large, bold) center
- Subtitle text (medium, regular) below title
- Next button (yellow, pill shape) at bottom
- Skip text link top right (slides 1–2)
- "Get Started" replaces "Next" on slide 3

**Slide Content:**

| Slide | Title | Subtitle | Illustration |
|-------|-------|----------|--------------|
| 1 | Book in Seconds | Enter pickup, drop, and your fare — done | Animated phone with map |
| 2 | Real-Time Tracking | Watch your driver arrive live on the map | Animated map marker moving |
| 3 | Safe & Reliable | Verified drivers, OTP verification, every ride | Animated shield/checkmark |

**Spacing:**
- Illustration top margin: 48dp
- Title top margin from illustration: 32dp
- Subtitle top margin: 12dp
- Button bottom margin: 48dp

---

### 8.3 Login Screen

**Purpose:** Authenticate user (simulated)

**Layout:**
- Top: Logo (small) + "Welcome Back" heading
- Phone number input with country code (+91)
- "Send OTP" button (yellow, full width)
- "New user? Sign Up" text link below button
- Skip for now option (very subtle, bottom of screen)

**OTP Screen (separate route):**
- "Enter OTP" heading
- Subtitle: "Sent to +91 XXXXXXXXXX"
- 4/6 digit OTP input (individual boxes)
- Resend OTP link (with 30-second countdown)
- Verify button

**Components:**
- PhoneInputField (custom, with flag + code)
- OTPInputRow (6 individual TextFields)
- CountdownTimer widget
- PrimaryButton widget

**States:**
- Default: Empty inputs
- Filled: Inputs have content, button active
- Loading: Button shows spinner
- Error: Red border on input, error message below

---

### 8.4 Home Screen

**Purpose:** Main hub for booking a ride

**Layout (bottom-up):**
```
┌────────────────────────────────────┐
│         Google Map (full screen)   │
│  [Current location marker]         │
│  [Pickup marker] [Drop marker]     │
│                                    │
├────────────────────────────────────┤
│  ┌──────────────────────────────┐  │
│  │  📍 Current Location          │  │
│  │  ─────────────────────────── │  │
│  │  🔍 Where to go?              │  │
│  └──────────────────────────────┘  │
│                                    │
│  ┌──── Vehicle Cards (scroll) ───┐  │
│  │  [Bike] [Auto] [Cab]          │  │
│  └───────────────────────────────┘  │
│                                    │
│  ┌──── Fare Input ───────────────┐  │
│  │  ₹  [Enter fare amount]       │  │
│  └───────────────────────────────┘  │
│                                    │
│  [    CONFIRM RIDE BUTTON    ]     │
│                                    │
│  [Home] [History] [Profile] [More] │
└────────────────────────────────────┘
```

**Map Configuration:**
- Custom map style JSON (dark/light based on theme)
- Disabled POI labels for cleanliness
- Custom current location marker (yellow animated dot)
- Custom pickup marker (yellow pin)
- Custom destination marker (black pin)

**Bottom Sheet Behaviour:**
- Default: Collapsed to show map partially
- Expanded: After both locations set
- Draggable between states

---

### 8.5 Location Search Screen

**Purpose:** Allow user to search and select locations

**Layout:**
```
┌────────────────────────────────────┐
│  ← Back                            │
│  ┌──────────────────────────────┐  │
│  │  📍 Pickup location           │  │
│  └──────────────────────────────┘  │
│  ┌──────────────────────────────┐  │
│  │  🔍 Search destination        │  │
│  └──────────────────────────────┘  │
│                                    │
│  ─── RECENT PLACES ────────────── │
│  [🕐 Place 1]  [🕐 Place 2]        │
│                                    │
│  ─── FAVOURITES ────────────────  │
│  [⭐ Home]  [⭐ Office]             │
│                                    │
│  ─── SEARCH RESULTS ────────────  │
│  [📍 Result 1]                     │
│  [📍 Result 2]                     │
│  [📍 Result 3]                     │
│                                    │
│  [📌 Choose on Map]                │
└────────────────────────────────────┘
```

**Simulated Search Logic:**
- Use a preset list of 100+ Indian city locations
- Filter list based on typed characters
- Show top 5 matching results
- Each result shows place name + city

---

### 8.6 Vehicle Selection Screen

**Purpose:** Select ride type

**Layout:**
- Back button top left
- "Select Vehicle" title
- Three vehicle cards (full width, stacked vertically)
- Each card:
  - Vehicle icon (left)
  - Vehicle name (bold)
  - Passenger capacity
  - Short description (e.g., "Affordable bike rides")
  - Right: Selection radio/tick
- Selected card has yellow left border + light yellow background

**Vehicle Types:**

| Type | Icon | Capacity | Description |
|------|------|----------|-------------|
| Bike | 🏍️ | 1 person | Fast & affordable for solo rides |
| Auto | 🛺 | 3 persons | Comfortable rides at great value |
| Cab | 🚗 | 4 persons | Premium AC cab for all occasions |

---

### 8.7 Ride Confirmation Screen

**Purpose:** Review and confirm ride details before booking

**Layout:**
- "Confirm Ride" title
- Route card:
  - Green dot: Pickup address
  - Vertical dotted line
  - Red dot: Drop address
- Fare display (prominent, yellow background card)
- Vehicle type chip
- Payment method row (tap to change)
- "Book Ride" large yellow button

---

### 8.8 Searching Driver Screen

**Purpose:** Simulate driver search with engaging animation

**Layout:**
- Full screen, dark overlay over map
- Centered Lottie animation (radar pulse)
- "Finding drivers nearby..." text
- Sub-text: "This usually takes a few seconds"
- Animated dots representing nearby drivers on map
- Cancel button (bottom, subtle)

**Simulation Logic:**
- Random delay between 3 and 8 seconds
- At 50% of delay: Show "Almost found a driver..."
- After delay: Transition to driver assigned state

---

### 8.9 Driver Assigned / Arriving Screen

**Purpose:** Show assigned driver details and live arrival

**Layout:**
- Map top 60% (driver marker animating toward pickup)
- Bottom sheet 40%:
  - Driver photo (circular, with online badge)
  - Driver name (bold)
  - Star rating with count
  - Vehicle info (number, color, model)
  - OTP box (4 digits, highlighted)
  - ETA chip ("Arriving in 3 mins")
  - Call button + Message button (row)
  - Cancel Ride button (text, red)

---

### 8.10 Live Ride Screen

**Purpose:** Show active ride with live map movement

**Layout:**
- Map full screen with animated driver + route polyline
- Floating card (top): Pickup → Drop summary
- Floating chip: ETA + Distance remaining
- Bottom strip: Fare + Driver name + SOS button

---

### 8.11 Ride Completed Screen

**Purpose:** Confirm arrival and transition to payment

**Layout:**
- Lottie animation: Destination reached (checkmark + flag)
- "You have arrived!" title
- Trip summary:
  - Distance: X.X km (simulated)
  - Duration: XX mins
  - Fare: ₹[user amount]
- "Proceed to Pay" yellow button

---

### 8.12 Payment Screen

**Purpose:** Simulate payment flow

**Layout:**
- "Payment" title
- Amount display (large, bold: ₹XXX)
- Payment method icons row
- Selected method highlighted
- Pay button
- On press: Processing animation (1.5s) → Success screen

**Success Screen:**
- Lottie: Green animated checkmark
- "Payment Successful!" title
- Transaction ID (random 12 digits)
- Amount + Method
- "Rate Your Driver" CTA

---

### 8.13 Rating Screen

**Purpose:** Collect simulated driver rating

**Layout:**
- Driver photo + name
- "How was your ride?" title
- 5 yellow stars (tap to select)
- Feedback tag chips (horizontal scroll)
- Comment box (optional)
- Favourite driver toggle
- Submit button
- Skip link

---

### 8.14 Ride History Screen

**Purpose:** Display list of all past rides

**Layout:**
- "My Rides" title
- Filter tabs: All | Completed | Cancelled
- List of ride cards (newest first)
- Each card:
  - Vehicle icon (left)
  - Pickup → Drop addresses
  - Date + Time
  - Fare (right aligned, bold)
  - Status badge

**Empty State:**
- Illustration (empty road)
- "No rides yet"
- "Book your first ride" CTA button

---

### 8.15 Profile Screen

**Purpose:** Show user info and statistics

**Layout:**
- Profile photo (large, circular, editable)
- Name + Phone
- Edit Profile button
- Stats card:
  - Total Rides
  - Total Distance
  - Total Spent
  - Member Since
- Settings row
- Logout button (red text, bottom)

---

## 9. Design System

### 9.1 Color Palette

#### Primary Colors

| Token | Value | Usage |
|-------|-------|-------|
| `primary` | #F5C518 | Primary actions, CTAs, highlights |
| `primary-dark` | #D4A800 | Pressed state for primary |
| `primary-light` | #FFF3C4 | Background tints |
| `on-primary` | #000000 | Text on yellow backgrounds |

#### Neutral Colors

| Token | Value | Usage |
|-------|-------|-------|
| `neutral-900` | #0D0D0D | Primary text (dark mode bg) |
| `neutral-800` | #1A1A1A | Card backgrounds (dark mode) |
| `neutral-700` | #2C2C2C | Elevated surfaces (dark mode) |
| `neutral-600` | #3D3D3D | Borders (dark mode) |
| `neutral-100` | #F5F5F5 | Backgrounds (light mode) |
| `neutral-50` | #FAFAFA | Card backgrounds (light mode) |
| `white` | #FFFFFF | Surfaces, text on dark |

#### Semantic Colors

| Token | Value | Usage |
|-------|-------|-------|
| `success` | #22C55E | Payment success, completed status |
| `error` | #EF4444 | Errors, cancel actions |
| `warning` | #F97316 | Warnings, alerts |
| `info` | #3B82F6 | Information states |

#### Map Colors

| Token | Value | Usage |
|-------|-------|-------|
| `route-line` | #F5C518 | Polyline on map |
| `pickup-pin` | #22C55E | Pickup location marker |
| `drop-pin` | #EF4444 | Destination marker |
| `driver-pin` | #F5C518 | Driver location marker |

---

### 9.2 Typography Scale

**Font Family:** Inter (Primary) + Poppins (Headings)

| Style | Font | Weight | Size | Line Height | Usage |
|-------|------|--------|------|-------------|-------|
| `display-large` | Poppins | 700 | 32sp | 40sp | Splash, hero text |
| `display-medium` | Poppins | 700 | 28sp | 36sp | Screen titles |
| `headline-large` | Poppins | 600 | 24sp | 32sp | Section headings |
| `headline-medium` | Poppins | 600 | 20sp | 28sp | Card headings |
| `title-large` | Inter | 600 | 18sp | 26sp | List item titles |
| `title-medium` | Inter | 500 | 16sp | 24sp | Subtitles |
| `body-large` | Inter | 400 | 16sp | 24sp | Body text |
| `body-medium` | Inter | 400 | 14sp | 20sp | Secondary body |
| `label-large` | Inter | 600 | 14sp | 20sp | Buttons, tabs |
| `label-medium` | Inter | 500 | 12sp | 16sp | Tags, chips |
| `caption` | Inter | 400 | 11sp | 16sp | Helper text |

---

### 9.3 Button System

#### Primary Button
```
Background: #F5C518
Text: #000000 (Inter, SemiBold, 16sp)
Border Radius: 28dp (pill shape)
Height: 56dp
Width: Full width (horizontal padding 24dp)
Padding: 16dp vertical, 24dp horizontal
Shadow: 0dp (flat) / 4dp elevation on press
State - Pressed: Scale 0.96, color #D4A800
State - Disabled: Opacity 0.4
```

#### Secondary Button
```
Background: Transparent
Border: 1.5dp #F5C518
Text: #F5C518 (Inter, SemiBold, 16sp)
Border Radius: 28dp
Height: 56dp
State - Pressed: Background #FFF3C4
```

#### Text Button
```
Background: Transparent
Text: #F5C518 (Inter, Medium, 14sp)
No border, no background
Underline optional
```

#### Icon Button
```
Size: 48x48dp (touch target)
Icon size: 24dp
Background: Neutral surface
Border Radius: 12dp
```

---

### 9.4 Card System

#### Standard Card
```
Background: Surface color
Border Radius: 16dp
Elevation: 2dp (light) / 4dp (dark)
Padding: 16dp
Shadow: Soft, 0 2dp 8dp rgba(0,0,0,0.08)
```

#### Driver Card
```
Background: Surface color
Border Radius: 24dp 24dp 0 0 (bottom sheet)
Padding: 24dp
Contains: Photo, name, rating, vehicle, OTP
```

#### Vehicle Card
```
Border Radius: 12dp
Border: 1.5dp (yellow when selected, transparent when not)
Background: Surface / Primary-light when selected
Height: 80dp
Padding: 16dp
```

#### Ride History Card
```
Border Radius: 12dp
Elevation: 1dp
Padding: 16dp
Left accent strip: 4dp yellow (completed) / red (cancelled)
```

---

### 9.5 Navigation

#### Bottom Navigation Bar
```
Height: 64dp
Items: 4 (Home, History, Profile, More)
Active: Yellow icon + yellow label
Inactive: Gray icon + gray label
Background: Surface color
Top border: 0.5dp divider
```

#### Navigation Items:
1. **Home** — House icon
2. **History** — Clock icon
3. **Profile** — Person icon
4. **More** — Grid/menu icon

---

### 9.6 Input Fields

#### Standard Text Field
```
Height: 56dp
Border Radius: 12dp
Border: 1dp neutral-300 (default), 2dp yellow (focused), 2dp red (error)
Background: Surface
Label: Floating label (Material 3)
Padding: 16dp horizontal
```

#### OTP Input Fields
```
Each box: 48x56dp
Border Radius: 8dp
Border: 1.5dp neutral (default), 2dp yellow (active), 2dp success (filled)
Spacing between boxes: 8dp
Auto-advance on digit entry
```

#### Fare Input Field
```
Prefix: "₹" symbol (bold, yellow)
Numeric keyboard only
Height: 56dp
Border Radius: 12dp
Border: 1.5dp yellow always (key input)
Font size: 24sp, Bold
```

---

### 9.7 Iconography

- **Icon Library:** Material Symbols (Rounded variant)
- **Icon Size:** 24dp standard, 20dp compact, 32dp featured
- **Icon Color:** Follows text color hierarchy
- **Custom Icons:** SVG assets for vehicle types, map markers

---

### 9.8 Spacing System

```
spacing-2:  2dp
spacing-4:  4dp
spacing-8:  8dp
spacing-12: 12dp
spacing-16: 16dp
spacing-20: 20dp
spacing-24: 24dp
spacing-32: 32dp
spacing-40: 40dp
spacing-48: 48dp
spacing-64: 64dp
```

**Usage Rules:**
- Between related elements: 8dp
- Between sections: 24dp
- Screen horizontal padding: 16dp
- Card internal padding: 16dp
- Bottom of screen above nav: 80dp

---

### 9.9 Corner Radius System

```
radius-4:  4dp  (chips, small elements)
radius-8:  8dp  (small cards, inputs compact)
radius-12: 12dp (standard cards, inputs)
radius-16: 16dp (large cards, modals)
radius-24: 24dp (bottom sheets top, large buttons)
radius-28: 28dp (pill buttons)
radius-full: 9999dp (circular avatars, badges)
```

---

### 9.10 Elevation and Shadow

| Level | Elevation | Shadow | Usage |
|-------|-----------|--------|-------|
| 0 | 0dp | None | Flat surfaces |
| 1 | 1dp | 0 1px 3px rgba(0,0,0,0.06) | Cards resting |
| 2 | 2dp | 0 2px 8px rgba(0,0,0,0.08) | Raised cards |
| 3 | 4dp | 0 4px 16px rgba(0,0,0,0.12) | Bottom sheets |
| 4 | 8dp | 0 8px 24px rgba(0,0,0,0.16) | FABs, dialogs |

---

### 9.11 Motion Guidelines

| Animation Type | Duration | Curve |
|---------------|----------|-------|
| Page transition | 300ms | easeInOut |
| Bottom sheet open | 350ms | easeOut |
| Bottom sheet close | 250ms | easeIn |
| Button press | 100ms | linear |
| Card appear | 200ms | easeOut |
| Fade in/out | 200ms | linear |
| Map marker move | Variable | linear |
| Lottie animations | Per file | Per file |
| Hero animations | 400ms | easeInOut |
| Snackbar | 250ms | easeOut |

---

## 10. Navigation Flow

### 10.1 Route Structure

```dart
// App Routes
class AppRoutes {
  static const splash       = '/';
  static const onboarding   = '/onboarding';
  static const login        = '/login';
  static const otp          = '/otp';
  static const signup       = '/signup';
  static const home         = '/home';
  static const locationSearch = '/location-search';
  static const vehicleSelect  = '/vehicle-select';
  static const confirmRide    = '/confirm-ride';
  static const searching      = '/searching';
  static const driverAssigned = '/driver-assigned';
  static const liveRide       = '/live-ride';
  static const rideComplete   = '/ride-complete';
  static const payment        = '/payment';
  static const paymentSuccess = '/payment-success';
  static const rating         = '/rating';
  static const history        = '/history';
  static const rideDetail     = '/ride-detail';
  static const profile        = '/profile';
  static const editProfile    = '/edit-profile';
  static const settings       = '/settings';
  static const about          = '/about';
}
```

### 10.2 Navigation Graph

```
Splash
├── Onboarding (first launch)
│   └── Login
│       ├── OTP
│       │   └── Home
│       └── Signup
│           └── Home
└── Home (returning user)
    ├── LocationSearch (pickup)
    ├── LocationSearch (destination)
    ├── VehicleSelect
    │   └── ConfirmRide
    │       └── Searching
    │           └── DriverAssigned
    │               └── LiveRide
    │                   └── RideComplete
    │                       └── Payment
    │                           └── PaymentSuccess
    │                               └── Rating
    │                                   └── Home
    ├── History
    │   └── RideDetail
    ├── Profile
    │   └── EditProfile
    └── Settings
        ├── About
        ├── PrivacyPolicy
        └── TermsOfService
```

### 10.3 Back Navigation Rules

| Screen | Back Behaviour |
|--------|---------------|
| Home | Exit app (with confirm dialog) |
| Searching | Cancel ride (with confirm) |
| LiveRide | Cancel ride (with confirm) |
| PaymentSuccess | Clear back stack → Home |
| Rating | Skip rating → Home |
| OTP | Back to Login |
| All others | Standard pop |

---

## 11. Information Architecture

### 11.1 App Structure

```
RideFlow Simulator
├── Authentication
│   ├── Login
│   ├── OTP Verification
│   └── Signup
│
├── Core Flow
│   ├── Home
│   ├── Location Selection
│   ├── Vehicle Selection
│   ├── Fare Input
│   ├── Ride Confirmation
│   ├── Driver Search
│   ├── Driver Tracking
│   ├── Live Ride
│   ├── Ride Completion
│   ├── Payment
│   └── Rating
│
├── History
│   ├── Ride List
│   └── Ride Detail
│
├── Profile
│   ├── View Profile
│   └── Edit Profile
│
└── Settings
    ├── Appearance
    ├── Notifications
    ├── Data Management
    └── About
```

---

## 12. Database Design

### 12.1 Local Storage Strategy

**Primary Database:** Hive (NoSQL, fast, Flutter-native)
**Secondary:** SharedPreferences (for simple key-value settings)
**File Storage:** path_provider (for profile images)

### 12.2 Hive Boxes

#### Box: `users`
```dart
@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0) String id;           // UUID
  @HiveField(1) String name;
  @HiveField(2) String phone;
  @HiveField(3) String? email;
  @HiveField(4) String? profileImagePath;
  @HiveField(5) DateTime createdAt;
  @HiveField(6) int totalRides;
  @HiveField(7) double totalSpent;
  @HiveField(8) double totalDistance;
}
```

#### Box: `rides`
```dart
@HiveType(typeId: 1)
class RideModel extends HiveObject {
  @HiveField(0)  String id;               // UUID
  @HiveField(1)  String userId;
  @HiveField(2)  String pickupAddress;
  @HiveField(3)  double pickupLat;
  @HiveField(4)  double pickupLng;
  @HiveField(5)  String dropAddress;
  @HiveField(6)  double dropLat;
  @HiveField(7)  double dropLng;
  @HiveField(8)  double fare;
  @HiveField(9)  String vehicleType;      // bike/auto/cab
  @HiveField(10) String paymentMethod;    // cash/upi/wallet/card
  @HiveField(11) String status;           // completed/cancelled
  @HiveField(12) DateTime startedAt;
  @HiveField(13) DateTime? completedAt;
  @HiveField(14) int durationMinutes;
  @HiveField(15) double distanceKm;
  @HiveField(16) String driverName;
  @HiveField(17) String driverPhone;
  @HiveField(18) double driverRating;
  @HiveField(19) String vehicleNumber;
  @HiveField(20) String otp;
  @HiveField(21) int? userRating;         // 1-5
  @HiveField(22) String? userComment;
  @HiveField(23) String transactionId;
}
```

#### Box: `locations`
```dart
@HiveType(typeId: 2)
class LocationModel extends HiveObject {
  @HiveField(0) String id;
  @HiveField(1) String address;
  @HiveField(2) String shortName;
  @HiveField(3) double lat;
  @HiveField(4) double lng;
  @HiveField(5) bool isFavourite;
  @HiveField(6) String? favouriteLabel;   // "Home", "Office", custom
  @HiveField(7) DateTime lastUsed;
  @HiveField(8) int useCount;
}
```

#### Box: `settings`
```dart
// Stored as key-value in SharedPreferences
class SettingsKeys {
  static const darkMode           = 'dark_mode';          // bool
  static const language           = 'language';            // String: 'en'/'hi'
  static const notificationsOn    = 'notifications_on';   // bool
  static const onboardingComplete = 'onboarding_done';    // bool
  static const loggedInUserId     = 'logged_in_user';     // String
  static const defaultPayment     = 'default_payment';    // String
}
```

### 12.3 Entity Relationship

```
USER (1) ──────────────── (many) RIDES
  │
  └── has many ──── LOCATIONS (recent + favourites)

RIDES ──── has one ──── DRIVER (generated in-memory, stored with ride)
```

---

## 13. Folder Structure

```
lib/
├── main.dart
├── app.dart                          # MaterialApp setup
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_typography.dart
│   │   ├── app_spacing.dart
│   │   ├── app_strings.dart
│   │   ├── app_routes.dart
│   │   └── app_config.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── dark_theme.dart
│   │   └── light_theme.dart
│   │
│   ├── utils/
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   ├── format_utils.dart
│   │   ├── location_utils.dart
│   │   └── logger.dart
│   │
│   ├── extensions/
│   │   ├── string_extensions.dart
│   │   ├── double_extensions.dart
│   │   └── context_extensions.dart
│   │
│   └── errors/
│       ├── app_exception.dart
│       └── failure.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── ride_model.dart
│   │   ├── location_model.dart
│   │   ├── driver_model.dart
│   │   └── rating_model.dart
│   │
│   ├── datasources/
│   │   ├── local/
│   │   │   ├── hive_local_datasource.dart
│   │   │   └── prefs_datasource.dart
│   │   └── fake/
│   │       ├── fake_auth_datasource.dart
│   │       ├── fake_driver_datasource.dart
│   │       ├── fake_ride_datasource.dart
│   │       ├── fake_payment_datasource.dart
│   │       ├── fake_notification_datasource.dart
│   │       └── fake_gps_datasource.dart
│   │
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── ride_repository_impl.dart
│       ├── location_repository_impl.dart
│       ├── driver_repository_impl.dart
│       └── settings_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── ride.dart
│   │   ├── driver.dart
│   │   └── location.dart
│   │
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── ride_repository.dart
│   │   ├── location_repository.dart
│   │   ├── driver_repository.dart
│   │   └── settings_repository.dart
│   │
│   └── usecases/
│       ├── auth/
│       │   ├── login_usecase.dart
│       │   ├── signup_usecase.dart
│       │   └── logout_usecase.dart
│       ├── ride/
│       │   ├── book_ride_usecase.dart
│       │   ├── cancel_ride_usecase.dart
│       │   ├── complete_ride_usecase.dart
│       │   └── get_ride_history_usecase.dart
│       ├── location/
│       │   ├── search_location_usecase.dart
│       │   ├── save_favourite_usecase.dart
│       │   └── get_recent_locations_usecase.dart
│       └── settings/
│           ├── toggle_dark_mode_usecase.dart
│           └── reset_app_usecase.dart
│
├── presentation/
│   ├── providers/                    # Riverpod providers
│   │   ├── auth_provider.dart
│   │   ├── ride_provider.dart
│   │   ├── driver_provider.dart
│   │   ├── location_provider.dart
│   │   ├── map_provider.dart
│   │   ├── settings_provider.dart
│   │   └── simulation_provider.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── onboarding/
│   │   │   ├── onboarding_screen.dart
│   │   │   └── widgets/
│   │   │       └── onboarding_slide.dart
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   ├── otp_screen.dart
│   │   │   ├── signup_screen.dart
│   │   │   └── widgets/
│   │   │       ├── phone_input_field.dart
│   │   │       └── otp_input_row.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── map_widget.dart
│   │   │       ├── location_input_card.dart
│   │   │       ├── vehicle_cards_row.dart
│   │   │       ├── fare_input_box.dart
│   │   │       └── confirm_button.dart
│   │   ├── location/
│   │   │   ├── location_search_screen.dart
│   │   │   └── widgets/
│   │   │       ├── recent_place_tile.dart
│   │   │       ├── favourite_place_chip.dart
│   │   │       └── search_result_tile.dart
│   │   ├── booking/
│   │   │   ├── vehicle_selection_screen.dart
│   │   │   ├── confirm_ride_screen.dart
│   │   │   ├── searching_screen.dart
│   │   │   ├── driver_assigned_screen.dart
│   │   │   ├── live_ride_screen.dart
│   │   │   └── ride_complete_screen.dart
│   │   ├── payment/
│   │   │   ├── payment_screen.dart
│   │   │   └── payment_success_screen.dart
│   │   ├── rating/
│   │   │   └── rating_screen.dart
│   │   ├── history/
│   │   │   ├── history_screen.dart
│   │   │   └── ride_detail_screen.dart
│   │   ├── profile/
│   │   │   ├── profile_screen.dart
│   │   │   └── edit_profile_screen.dart
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── about_screen.dart
│   │
│   └── widgets/                      # Shared widgets
│       ├── primary_button.dart
│       ├── secondary_button.dart
│       ├── app_text_field.dart
│       ├── ride_status_badge.dart
│       ├── star_rating_widget.dart
│       ├── driver_card.dart
│       ├── loading_overlay.dart
│       ├── empty_state_widget.dart
│       ├── error_widget.dart
│       └── bottom_sheet_handle.dart
│
├── services/
│   ├── simulation/
│   │   ├── simulation_engine.dart
│   │   ├── driver_generator.dart
│   │   ├── route_simulator.dart
│   │   ├── eta_calculator.dart
│   │   └── notification_simulator.dart
│   ├── map/
│   │   ├── map_service.dart
│   │   └── location_service.dart
│   └── storage/
│       ├── hive_service.dart
│       └── secure_storage_service.dart
│
└── assets/                           # Referenced from pubspec.yaml
    ├── lottie/
    │   ├── splash_logo.json
    │   ├── searching_radar.json
    │   ├── driver_found.json
    │   ├── ride_complete.json
    │   ├── payment_success.json
    │   └── empty_rides.json
    ├── images/
    │   ├── onboarding_1.png
    │   ├── onboarding_2.png
    │   └── onboarding_3.png
    ├── icons/
    │   ├── bike.svg
    │   ├── auto.svg
    │   ├── cab.svg
    │   └── map_marker.svg
    └── map_styles/
        ├── dark_map_style.json
        └── light_map_style.json
```

---

## 14. State Management

### 14.1 Recommendation: Riverpod

**Why Riverpod over Bloc or Provider:**

| Criteria | Riverpod | Bloc | Provider |
|----------|----------|------|----------|
| Boilerplate | Low | High | Medium |
| Testability | Excellent | Excellent | Good |
| Learning curve | Medium | High | Low |
| Compile-time safety | Yes | Partial | No |
| Async handling | Built-in | Manual | Manual |
| Code generation support | Yes | Yes | No |
| Recommended for | Complex apps | Enterprise | Simple apps |

RideFlow requires managing complex async simulation states, real-time map updates, and multiple interdependent features. Riverpod with code generation (`riverpod_annotation`) is the ideal choice.

### 14.2 Architecture: Clean Architecture + MVVM

```
UI Layer (Screens/Widgets)
        ↕
Presentation Layer (Riverpod Providers/Notifiers)
        ↕
Domain Layer (Use Cases + Entities)
        ↕
Data Layer (Repositories + DataSources)
        ↕
Local Storage (Hive + SharedPreferences)
Fake Services (Simulation Engine)
```

### 14.3 Key Providers

```dart
// Auth State
@riverpod
class AuthNotifier extends _$AuthNotifier {
  // Manages: login, logout, session, user data
}

// Ride Booking State
@riverpod
class RideNotifier extends _$RideNotifier {
  // Manages: ride lifecycle, current ride state
  // States: idle → searching → assigned → arriving
  //         → started → completed → paying → rated
}

// Simulation State
@riverpod
class SimulationNotifier extends _$SimulationNotifier {
  // Manages: driver movement, ETA countdown
  // timer-based state updates every second
}

// Map State
@riverpod
class MapNotifier extends _$MapNotifier {
  // Manages: camera position, markers, polylines
}

// Location State
@riverpod
class LocationNotifier extends _$LocationNotifier {
  // Manages: pickup, destination, recent, favourites
}

// Settings State
@riverpod
class SettingsNotifier extends _$SettingsNotifier {
  // Manages: dark mode, language, notifications
}
```

### 14.4 Ride State Machine

```
RideState:
├── idle
├── selectingLocations
├── selectingVehicle
├── enteringFare
├── confirmingRide
├── searchingDriver
├── driverAssigned
├── driverArriving
├── rideStarted
├── rideCompleted
├── processingPayment
├── paymentSuccess
├── rating
└── error(message)
```

---

## 15. Simulation Engine

### 15.1 Overview

The Simulation Engine is the core of RideFlow. It replaces all real backend services with convincing, configurable, randomized simulations.

### 15.2 Driver Generator

```dart
class DriverGenerator {

  static const List<String> _indianMaleNames = [
    'Rajesh Kumar', 'Amit Singh', 'Suresh Yadav',
    'Vikram Sharma', 'Dinesh Patel', 'Manoj Tiwari',
    // ... 50+ names
  ];

  static const List<String> _vehicleColors = [
    'White', 'Black', 'Silver', 'Grey', 'Blue',
  ];

  static const List<String> _vehicleBrands = {
    'bike': ['Honda Activa', 'TVS Jupiter', 'Bajaj Pulsar', 'Hero Splendor'],
    'auto': ['Bajaj RE', 'Piaggio Ape', 'TVS King'],
    'cab':  ['Maruti Swift', 'Hyundai i20', 'Toyota Etios', 'Maruti Dzire'],
  };

  DriverModel generate(String vehicleType) {
    final name = _randomFrom(_indianMaleNames);
    final brand = _randomFrom(_vehicleBrands[vehicleType]!);
    final rating = 4.1 + Random().nextDouble() * 0.8; // 4.1–4.9

    return DriverModel(
      id: _generateUUID(),
      name: name,
      phone: _generateFakePhone(),
      rating: double.parse(rating.toStringAsFixed(1)),
      totalRides: 200 + Random().nextInt(2000),
      vehicleType: vehicleType,
      vehicleBrand: brand,
      vehicleColor: _randomFrom(_vehicleColors),
      vehicleNumber: _generateVehicleNumber(),
      etaMinutes: 2 + Random().nextInt(7),       // 2–8 minutes
      experience: '${1 + Random().nextInt(8)} years',
      language: _randomFrom(['Hindi', 'English', 'Hindi & English']),
      cancellationRate: Random().nextInt(8),      // 0–7%
      avatarSeed: Random().nextInt(1000),         // For avatar generation
      otp: _generateOTP(),
    );
  }

  String _generateVehicleNumber() {
    // Format: RJ 14 AB 1234
    final states = ['RJ', 'DL', 'MH', 'UP', 'KA', 'TN'];
    final state = _randomFrom(states);
    final district = (10 + Random().nextInt(90)).toString();
    final letters = _randomLetters(2);
    final digits = (1000 + Random().nextInt(9000)).toString();
    return '$state $district $letters $digits';
  }

  String _generateOTP() {
    return (1000 + Random().nextInt(9000)).toString();
  }
}
```

### 15.3 Route Simulator

```dart
class RouteSimulator {
  // Generates fake GPS coordinates along a straight-line interpolated path
  // between two LatLng points with slight random deviation

  List<LatLng> generateRoute(LatLng from, LatLng to, int steps) {
    final List<LatLng> points = [];
    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final lat = from.latitude + (to.latitude - from.latitude) * t
                + _noise() * 0.001;
      final lng = from.longitude + (to.longitude - from.longitude) * t
                + _noise() * 0.001;
      points.add(LatLng(lat, lng));
    }
    return points;
  }

  double _noise() => (Random().nextDouble() - 0.5);

  // Simulate movement: emit one point per second via Stream
  Stream<LatLng> simulateMovement(List<LatLng> route) async* {
    for (final point in route) {
      await Future.delayed(const Duration(milliseconds: 800));
      yield point;
    }
  }
}
```

### 15.4 Simulation Timing Configuration

```dart
class SimulationConfig {
  // All values in milliseconds unless noted

  static const searchMinDelay     = 3000;    // min wait to find driver
  static const searchMaxDelay     = 8000;    // max wait to find driver
  static const driverArrivalMin   = 120;     // seconds (2 min)
  static const driverArrivalMax   = 480;     // seconds (8 min)
  static const rideStepsCount     = 60;      // map animation steps
  static const stepInterval       = 1000;    // ms between each step
  static const otpVerifyDelay     = 1500;    // ms for fake OTP verification
  static const paymentProcessTime = 1800;    // ms for fake payment
  static const driverFoundChance  = 0.95;    // 95% success rate
  static const cancelDuringSearch = 0.05;    // 5% auto-cancel simulation
}
```

### 15.5 ETA Calculator

```dart
class ETACalculator {
  // Based on straight-line distance + simulated speed

  int calculateArrivalETA(LatLng driver, LatLng pickup) {
    final distance = _haversineDistance(driver, pickup); // in km
    final speedKmPerMin = 0.4; // ~24 km/h city speed
    return (distance / speedKmPerMin).ceil().clamp(2, 8);
  }

  int calculateRideETA(LatLng pickup, LatLng destination) {
    final distance = _haversineDistance(pickup, destination);
    final speedKmPerMin = 0.35;
    return (distance / speedKmPerMin).ceil().clamp(5, 45);
  }

  double calculateDistance(LatLng from, LatLng to) {
    return _haversineDistance(from, to);
  }

  double _haversineDistance(LatLng from, LatLng to) {
    // Standard haversine formula implementation
    // Returns distance in kilometers
  }
}
```

### 15.6 Fake Notification Service

```dart
class FakeNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;

  Future<void> sendNotification(NotificationEvent event) async {
    final payload = _getPayload(event);
    await _plugin.show(
      event.index,
      payload.title,
      payload.body,
      _getDetails(),
    );
  }
}

enum NotificationEvent {
  searchingDriver,
  driverFound,
  driverArriving,
  rideStarted,
  rideCompleted,
  paymentSuccess,
  ratingReminder,
}
```

---

## 16. Local Storage Design

### 16.1 Hive Initialization

```dart
Future<void> initHive() async {
  final dir = await getApplicationDocumentsDirectory();
  Hive.init(dir.path);

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(RideModelAdapter());
  Hive.registerAdapter(LocationModelAdapter());

  await Hive.openBox<UserModel>('users');
  await Hive.openBox<RideModel>('rides');
  await Hive.openBox<LocationModel>('locations');
  await Hive.openBox('session');
}
```

### 16.2 Storage Operations

| Operation | Box | Method |
|-----------|-----|--------|
| Save user | users | `box.put(user.id, user)` |
| Get current user | users | `box.get(sessionUserId)` |
| Save ride | rides | `box.add(ride)` |
| Get all rides | rides | `box.values.toList()` |
| Get rides by user | rides | filter by userId |
| Save location | locations | `box.add(location)` |
| Get recents | locations | filter by lastUsed, limit 10 |
| Get favourites | locations | filter isFavourite == true |
| Delete all history | rides | `box.clear()` |
| Reset app | all boxes | `box.clear()` on all |

### 16.3 Data Limits

| Data Type | Limit | Strategy |
|-----------|-------|----------|
| Ride history | 500 records | Delete oldest when exceeded |
| Recent locations | 10 records | FIFO replacement |
| Favourite locations | 20 records | User manages manually |
| Profile images | 1 current | Replace on change |

---

## 17. Animation Guidelines

### 17.1 Lottie Animation Files Required

| File | Screen | Description |
|------|--------|-------------|
| `splash_logo.json` | Splash | RideFlow logo draw + fill |
| `searching_radar.json` | Searching | Pulsing radar circles |
| `driver_found.json` | Driver Assigned | Driver card pop in |
| `ride_complete.json` | Ride Complete | Flag/destination reached |
| `payment_success.json` | Payment | Green checkmark celebration |
| `empty_rides.json` | History | Empty road illustration |
| `onboarding_1.json` | Onboarding | Phone + map animation |
| `onboarding_2.json` | Onboarding | Moving marker animation |
| `onboarding_3.json` | Onboarding | Shield/safety animation |

### 17.2 Custom Flutter Animations

#### Map Marker Animation (Current Location)
```dart
// Pulsing dot — AnimationController with repeat
// Inner dot: static yellow circle 12dp
// Outer ring: scale 1.0 → 2.0, opacity 1.0 → 0.0
// Duration: 1500ms, repeat: true
```

#### Driver Marker Movement
```dart
// Animate LatLng position using Tween<LatLng>
// Update marker position every 800ms via stream
// Smooth interpolation between GPS points
```

#### Searching Nearby Drivers
```dart
// Randomly place 5–8 circular markers around pickup point
// Each marker: fade in at random delay (200–800ms)
// All markers pulse simultaneously
```

#### Bottom Sheet Entry
```dart
// Slide up from bottom: DraggableScrollableSheet
// Entry: 350ms easeOut
// Initial size: 0.4 (40% of screen)
// Expanded size: 0.75 (75% of screen)
```

#### Page Transitions
```dart
// Custom PageRouteBuilder for all named routes
// Slide + fade combination
// Duration: 300ms easeInOut
```

#### Button Press Feedback
```dart
// GestureDetector with ScaleTransition
// Press: scale 0.96 over 100ms
// Release: scale 1.0 over 100ms
// Color: darken by 15% on press
```

---

## 18. Edge Cases

### 18.1 Authentication Edge Cases

| Scenario | Handling |
|----------|----------|
| User enters non-numeric OTP | Show error: "Please enter digits only" |
| User enters OTP < 4 digits | Disable verify button |
| Phone number < 10 digits | Disable Send OTP button |
| App killed during OTP wait | Return to login screen |
| User already registered | Auto-login with saved session |
| Profile photo too large | Compress before saving (max 500KB) |

### 18.2 Booking Edge Cases

| Scenario | Handling |
|----------|----------|
| No destination set | Confirm Ride button disabled |
| Fare entered as 0 | Show error: "Please enter a valid fare" |
| Fare exceeds ₹99,999 | Cap at ₹99,999 with toast |
| User cancels during search | Return to home, show cancellation toast |
| User cancels after driver assigned | Show cancellation fee warning (fake) |
| App backgrounded during live ride | Resume simulation on foreground |
| Location permission denied | Show explanation, offer manual entry |
| Pickup = destination | Show error: "Pickup and drop cannot be same" |

### 18.3 Map Edge Cases

| Scenario | Handling |
|----------|----------|
| No internet (Google Maps offline) | Show cached tiles or placeholder |
| Location services disabled | Prompt to enable, offer manual pin |
| GPS inaccurate | Use last known simulated position |
| Map loads slowly | Show skeleton loader |

### 18.4 Storage Edge Cases

| Scenario | Handling |
|----------|----------|
| Hive box corrupted | Delete and reinitialise box |
| Storage full | Show warning, offer to delete old rides |
| App reset while ride active | Clear active ride state |
| First launch with no data | Show empty states, no errors |

---

## 19. Error Handling

### 19.1 Error Hierarchy

```dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  const AppException(this.message, {this.code});
}

class StorageException extends AppException { ... }
class ValidationException extends AppException { ... }
class SimulationException extends AppException { ... }
class LocationException extends AppException { ... }
```

### 19.2 Error Display Strategy

| Error Type | Display Method |
|------------|---------------|
| Input validation | Inline field error text |
| Non-critical (toast-worthy) | SnackBar (3 seconds) |
| Blocking errors | AlertDialog with action |
| Critical/unknown | Full error screen with retry |
| Empty states | Dedicated empty state widget |

### 19.3 Error Messages

| Error | User-Facing Message |
|-------|---------------------|
| No destination | "Please add a destination to continue" |
| Invalid fare | "Please enter a fare amount" |
| Zero fare | "Fare must be at least ₹1" |
| Storage error | "Something went wrong. Please try again." |
| Location denied | "Location access needed for a better experience" |
| Simulation timeout | "Could not find a driver. Please try again." |

---

## 20. Future Roadmap

### 20.1 Version 1.1 — Polish Release
- [ ] Haptic feedback on all interactions
- [ ] Improved map animations (cubic bezier driver path)
- [ ] Ride receipt PDF export (simulated)
- [ ] Driver profile detail screen
- [ ] Add more Indian city location datasets

### 20.2 Version 1.2 — Feature Expansion
- [ ] Multiple saved addresses (Home, Office, Gym, etc.)
- [ ] Ride scheduling simulation ("Book for later")
- [ ] Promo code input field (fake)
- [ ] Referral section (fake)
- [ ] Wallet top-up simulation

### 20.3 Version 2.0 — iOS + Web
- [ ] iOS platform support
- [ ] Flutter Web dashboard (admin view — ride stats)
- [ ] iPad layout optimization
- [ ] Apple Pay simulation (iOS)

### 20.4 Version 2.1 — Advanced Simulation
- [ ] Multi-stop rides
- [ ] Surge pricing simulation
- [ ] Driver cancellation simulation (driver cancels, new search begins)
- [ ] SOS alert simulation (vibration + fake call)
- [ ] Corporate booking mode

### 20.5 Version 3.0 — Configurability
- [ ] Simulation settings panel (adjust delays, fares, driver acceptance rate)
- [ ] Custom branding mode (white-label for portfolios)
- [ ] Export/import ride data
- [ ] Demo mode (scripted walkthrough for presentations)

---

## 21. Technical Recommendations

### 21.1 Package Recommendations

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.5.0
  riverpod_annotation: ^2.3.0

  # Navigation
  go_router: ^13.0.0

  # Local Storage
  hive_flutter: ^1.1.0
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  path_provider: ^2.1.0

  # Maps
  google_maps_flutter: ^2.6.0

  # Animations
  lottie: ^3.0.0
  animations: ^2.0.0

  # Notifications
  flutter_local_notifications: ^17.0.0

  # UI
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  smooth_page_indicator: ^1.1.0
  flutter_rating_bar: ^4.0.0

  # Utilities
  uuid: ^4.3.0
  intl: ^0.19.0
  image_picker: ^1.0.0
  permission_handler: ^11.0.0
  url_launcher: ^6.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  hive_generator: ^2.0.0
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
  flutter_lints: ^3.0.0
  mockito: ^5.4.0
```

### 21.2 Google Maps Setup

- Obtain Google Maps API key (Android Maps SDK)
- Enable: Maps SDK for Android, Geocoding API
- Add to `AndroidManifest.xml`
- Use custom map style JSON for dark/light themes
- Restrict API key to app package name and SHA-1

### 21.3 Performance Recommendations

- Use `const` constructors wherever possible
- Use `RepaintBoundary` around map widget
- Lazy load ride history (pagination — 20 per page)
- Cache profile images locally (do not reload from disk repeatedly)
- Use `compute()` for any heavy data processing
- Dispose all AnimationControllers in `dispose()`
- Use `StreamSubscription` with proper cancellation

### 21.4 Code Quality Standards

- Enforce `flutter_lints` rules
- All public methods documented with `///`
- No file longer than 300 lines
- Single responsibility per class
- Dependency injection via Riverpod providers
- No raw strings — all in `AppStrings` constants

---

## 22. Development Milestones

### Phase 1 — Foundation (Week 1–2)
- [ ] Project setup, folder structure, theme, routing
- [ ] Hive setup and all models
- [ ] Splash + Onboarding screens
- [ ] Authentication screens (Login, OTP, Signup)
- [ ] Session management

**Deliverable:** Working auth flow, persisted session

---

### Phase 2 — Core Booking (Week 3–5)
- [ ] Home screen with Google Map
- [ ] Location search and selection
- [ ] Vehicle selection screen
- [ ] Manual fare input
- [ ] Ride confirmation screen
- [ ] Driver generator service

**Deliverable:** Complete pre-booking flow

---

### Phase 3 — Simulation (Week 6–8)
- [ ] Searching driver animation
- [ ] Driver assignment screen
- [ ] Live map simulation (driver movement)
- [ ] ETA countdown
- [ ] Ride start state
- [ ] Ride complete state
- [ ] Simulation engine complete

**Deliverable:** Full ride simulation working end-to-end

---

### Phase 4 — Payment + Rating (Week 9)
- [ ] Payment screen (all methods)
- [ ] Payment success animation
- [ ] Rating screen
- [ ] Local notification triggers

**Deliverable:** Complete post-ride flow

---

### Phase 5 — History + Profile (Week 10)
- [ ] Ride history list
- [ ] Ride detail screen
- [ ] Profile screen
- [ ] Edit profile
- [ ] Settings screen

**Deliverable:** All secondary screens complete

---

### Phase 6 — Polish (Week 11–12)
- [ ] All Lottie animations integrated
- [ ] All page transitions
- [ ] Dark mode complete
- [ ] Micro-interactions (button press, haptics)
- [ ] Empty states, loading states, error states
- [ ] Accessibility audit
- [ ] Performance profiling (60 FPS check)
- [ ] APK size optimization

**Deliverable:** Production-ready release build

---

### Phase 7 — Testing + QA (Week 13)
- [ ] Unit tests for all use cases
- [ ] Widget tests for core screens
- [ ] Integration tests for full ride flow
- [ ] Manual QA on 3 different device sizes
- [ ] Bug fixes

**Deliverable:** QA-approved release APK

---

## 23. QA Checklist

### 23.1 Authentication

- [ ] Login with any 10-digit phone works
- [ ] OTP field accepts only numbers
- [ ] Any OTP passes verification
- [ ] Signup stores user locally
- [ ] Returning user auto-navigated to home
- [ ] Logout clears session and returns to login
- [ ] Profile photo saved and loaded correctly

### 23.2 Home Screen

- [ ] Map loads and shows current location
- [ ] Location search opens on tap
- [ ] Recent locations displayed correctly
- [ ] Vehicle cards scroll and select correctly
- [ ] Fare input accepts numeric values
- [ ] Confirm button disabled when no destination/fare
- [ ] Confirm button enabled when both set
- [ ] Bottom navigation works on all tabs

### 23.3 Booking Flow

- [ ] Searching animation plays correctly
- [ ] Random delay is 3–8 seconds
- [ ] Driver generated with all required fields
- [ ] OTP is exactly 4 digits
- [ ] Map shows driver moving to pickup
- [ ] ETA countdown works
- [ ] Ride started state transitions correctly
- [ ] Driver moves from pickup to destination
- [ ] Ride complete triggers correctly

### 23.4 Payment

- [ ] All 4 payment methods selectable
- [ ] Fare matches user-entered amount exactly
- [ ] Processing animation plays
- [ ] Success screen shows transaction ID
- [ ] Success screen shows correct amount

### 23.5 Rating

- [ ] Star rating selectable 1–5
- [ ] Tags selectable (multi-select)
- [ ] Comment field optional
- [ ] Rating stored with ride record
- [ ] Skip navigates to home

### 23.6 History

- [ ] All completed rides appear
- [ ] Newest ride at top
- [ ] Filter tabs work
- [ ] Ride detail shows all correct data
- [ ] Empty state shows when no rides

### 23.7 Settings

- [ ] Dark mode toggle works instantly
- [ ] Delete history shows confirmation
- [ ] Delete history clears all ride records
- [ ] Reset app returns to onboarding
- [ ] App version displayed correctly

### 23.8 Performance

- [ ] Cold start < 2.5 seconds
- [ ] No visible jank during map animation
- [ ] Smooth bottom sheet animation
- [ ] No memory leak after 10+ rides
- [ ] App resumes correctly after backgrounding

### 23.9 Edge Cases

- [ ] Pickup = Destination shows error
- [ ] ₹0 fare shows error
- [ ] Cancel during search works
- [ ] Location permission denied handled gracefully
- [ ] First launch with no data shows correct empty states

---

## 24. Acceptance Criteria

### AC-001: Complete Ride Flow
**Given** a logged-in user
**When** they enter pickup, destination, fare, select vehicle, and confirm
**Then** the full simulation plays through to rating screen without errors
**And** a ride record is saved locally

### AC-002: Manual Fare Persistence
**Given** a user enters ₹350 as fare
**When** the ride progresses through all screens
**Then** ₹350 must appear on: confirmation, payment, success, history

### AC-003: Driver Randomization
**Given** two separate ride bookings
**When** drivers are assigned
**Then** names, vehicle numbers, and ratings must differ

### AC-004: Offline Operation
**Given** the device has no internet
**When** all core app functions are used
**Then** every feature works except live map tiles

### AC-005: Data Persistence
**Given** a user completes a ride and closes the app
**When** they reopen the app
**Then** the completed ride appears in history

### AC-006: Dark Mode
**Given** dark mode is enabled in settings
**When** any screen is visited
**Then** all screens use the dark theme correctly with no light-mode remnants

### AC-007: Session Persistence
**Given** a user is logged in and closes the app
**When** they reopen the app
**Then** they are taken directly to home screen without logging in again

### AC-008: 60 FPS Performance
**Given** a mid-range Android device (4GB RAM, Snapdragon 600 series)
**When** any animation plays
**Then** frame rate must not drop below 55 FPS

---

## 25. Appendix

### 25.1 Preset Indian Locations (Sample)

```dart
const List<Map<String, dynamic>> presetLocations = [
  {'name': 'Connaught Place', 'city': 'New Delhi', 'lat': 28.6315, 'lng': 77.2167},
  {'name': 'Bandra Kurla Complex', 'city': 'Mumbai', 'lat': 19.0596, 'lng': 72.8656},
  {'name': 'MG Road', 'city': 'Bangalore', 'lat': 12.9716, 'lng': 77.6099},
  {'name': 'T. Nagar', 'city': 'Chennai', 'lat': 13.0418, 'lng': 80.2341},
  {'name': 'Park Street', 'city': 'Kolkata', 'lat': 22.5535, 'lng': 88.3523},
  {'name': 'Banjara Hills', 'city': 'Hyderabad', 'lat': 17.4156, 'lng': 78.4347},
  {'name': 'C-Scheme', 'city': 'Jaipur', 'lat': 26.9124, 'lng': 75.7873},
  {'name': 'Koregaon Park', 'city': 'Pune', 'lat': 18.5362, 'lng': 73.8938},
  // ... 90+ more locations
];
```

### 25.2 Indian Driver Name Bank (Sample)

```dart
// 50+ realistic Indian driver names for simulation
const List<String> driverNameBank = [
  'Rajesh Kumar', 'Amit Singh', 'Suresh Yadav', 'Vikram Sharma',
  'Dinesh Patel', 'Manoj Tiwari', 'Ravi Gupta', 'Santosh Verma',
  'Deepak Chauhan', 'Ajay Mishra', 'Rakesh Nair', 'Vijay Patil',
  'Sanjay Reddy', 'Arun Pillai', 'Ganesh Iyer', 'Mohan Das',
  'Pradeep Rao', 'Naresh Joshi', 'Ramesh Dubey', 'Sunil Pandey',
  // ... 30+ more
];
```

### 25.3 Map Style Configuration

The app uses custom Google Maps JSON styles to match the app theme:
- **Light Mode:** Subtle, desaturated, minimal POI
- **Dark Mode:** Dark background, yellow roads, minimal labels

Custom map style JSON files are stored at:
- `assets/map_styles/dark_map_style.json`
- `assets/map_styles/light_map_style.json`

### 25.4 Fake Transaction ID Generator

```dart
String generateTransactionId() {
  const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  return 'TXN' + List.generate(12, (_) =>
    chars[Random().nextInt(chars.length)]).join();
}
// Example output: TXNA3F9K2M1PQR
```

### 25.5 Glossary

| Term | Definition |
|------|------------|
| Simulation Engine | The core service that generates fake drivers, routes, and ride events |
| Captain | Term used within app UI for the assigned driver |
| OTP | One-Time Password used for ride verification at pickup |
| AMC | App lifecycle event — Activity, Moving, Complete (internal ride state) |
| Fare | Amount manually entered by user before confirming ride |
| ETA | Estimated Time of Arrival (simulated countdown) |
| Hive Box | A collection (table equivalent) in the Hive local database |
| Provider | A Riverpod state container that holds and manages application state |
| Use Case | A domain-layer class containing a single business operation |
| Route | Either a navigation path (app routing) or a map path (GPS route) |

---

*End of PRD Document*

---

**Document Information**

| Field | Value |
|-------|-------|
| Document Title | RideFlow Simulator — Product Requirements Document |
| Version | 1.0 |
| Date | July 2026 |
| Status | Ready for Development |
| Total Sections | 25 |
| Prepared For | Development Team |

---

*RideFlow Simulator is an original simulation project. It does not use, replicate, or copy any assets, brand identity, proprietary design, or copyrighted material from any existing ride-hailing company.*
