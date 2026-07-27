# RideFlow Simulator — Complete Design System & Specification

**Version:** 1.0
**Platform:** Android (Flutter, Material 3)
**Type:** Fully offline ride-booking simulator (no backend, no real drivers, no real payments)
**Audience:** UI/UX Designers, Flutter Engineers

---

## Table of Contents

1. [Project Overview & Design Goals](#1-project-overview--design-goals)
2. [Color System](#2-color-system)
3. [Typography](#3-typography)
4. [Iconography](#4-iconography)
5. [Spacing System](#5-spacing-system)
6. [Border Radius](#6-border-radius)
7. [Elevation](#7-elevation)
8. [Button System](#8-button-system)
9. [Input System](#9-input-system)
10. [Card System](#10-card-system)
11. [Bottom Sheets](#11-bottom-sheets)
12. [Map Design](#12-map-design)
13. [Navigation](#13-navigation)
14. [Screen Specifications](#14-screen-specifications)
15. [Animation System](#15-animation-system)
16. [Accessibility](#16-accessibility)
17. [Design Tokens](#17-design-tokens)
18. [Flutter Implementation Guide](#18-flutter-implementation-guide)
19. [Developer Notes & Checklists](#19-developer-notes--checklists)

---

## 1. Project Overview & Design Goals

**RideFlow Simulator** is a fully offline ride-booking simulator that replicates the end-to-end experience of a modern ride-hailing app — search, vehicle selection, driver matching, live tracking, payment, and rating — entirely with simulated data. No network calls, no real GPS drivers, no real transactions.

### Design Goals

| Goal | How the design achieves it |
|---|---|
| Speed | Snappy 150–250ms transitions, skeleton loaders instead of blank states, minimal taps to book |
| Trust | Consistent iconography, clear status communication, driver/vehicle detail transparency |
| Simplicity | Progressive disclosure via bottom sheets, single primary action per screen |
| Confidence | High-contrast CTAs, clear typographic hierarchy, deliberate motion (nothing jittery) |
| Mobility | Map-first layouts, directional motion cues, route-forward visual language |
| Modern Technology | Material 3 dynamic surfaces, soft elevation, rounded geometry |
| Premium Quality | Generous whitespace, refined micro-interactions, restrained color usage |

### Visual Style Pillars
- **Premium & Minimal** — generous negative space, no visual clutter
- **Mobile First** — every layout designed for one-handed thumb reach first
- **Material 3** — dynamic color roles, tonal elevation, updated component shapes
- **Rounded Corners** — soft geometric language throughout (see [Border Radius](#6-border-radius))
- **Floating Bottom Sheets** — the primary interaction surface sits above the map
- **Soft Elevation** — shadows are diffuse and low-opacity, never harsh
- **High Contrast** — WCAG AA minimum everywhere, AAA for critical text
- **Motion Rich** — every state change is animated, but motion always serves clarity

---

## 2. Color System

### Brand Palette (Mobility-Inspired: Yellow / Black / White)

| Token | Light HEX | Dark HEX | Usage |
|---|---|---|---|
| `primary` | `#FFD400` | `#FFD400` | Primary CTAs, active states, brand accents, selected vehicle card |
| `primary-container` | `#FFF3B0` | `#4A3F00` | Backgrounds behind primary content (badges, highlighted rows) |
| `on-primary` | `#1A1A1A` | `#1A1A1A` | Text/icons on top of primary yellow (always near-black for contrast) |
| `secondary` | `#1A1A1A` | `#F5F5F5` | Secondary buttons, headers, nav bar icons |
| `secondary-container` | `#EDEDED` | `#2C2C2C` | Chips, secondary surfaces |
| `on-secondary` | `#FFFFFF` | `#1A1A1A` | Text/icons on secondary surfaces |
| `accent` | `#2F6FED` | `#5B8FFF` | Links, informational highlights, route preview accents |
| `success` | `#1AAE6F` | `#3FD08C` | Ride complete, payment success, positive status |
| `warning` | `#F2A900` | `#F2C14E` | Surge pricing, low battery, caution states |
| `error` | `#E5484D` | `#FF6B6E` | Cancellations, failed states, validation errors |
| `info` | `#2F6FED` | `#5B8FFF` | Informational banners, tooltips |
| `surface` | `#FFFFFF` | `#121212` | Cards, sheets, dialogs |
| `surface-variant` | `#F7F7F7` | `#1E1E1E` | Alternate surface for layering (e.g. nested cards) |
| `background` | `#FAFAFA` | `#0B0B0B` | Screen background |
| `divider` | `#E3E3E3` | `#2A2A2A` | Hairlines, list separators |
| `disabled` | `#C9C9C9` | `#3A3A3A` | Disabled fills |
| `on-disabled` | `#8A8A8A` | `#6B6B6B` | Disabled text/icons |
| `border` | `#DDDDDD` | `#333333` | Input borders, outlined buttons/cards |

### Neutral Gray Scale

| Token | HEX |
|---|---|
| Gray 50 | `#FAFAFA` |
| Gray 100 | `#F5F5F5` |
| Gray 200 | `#EDEDED` |
| Gray 300 | `#DDDDDD` |
| Gray 400 | `#C9C9C9` |
| Gray 500 | `#A0A0A0` |
| Gray 600 | `#707070` |
| Gray 700 | `#4A4A4A` |
| Gray 800 | `#2C2C2C` |
| Gray 900 | `#1A1A1A` |

### Usage Rules
- **Primary Yellow (`#FFD400`)** is reserved for the single most important action on a screen (e.g. "Confirm Ride", selected vehicle card border, active tab indicator). Never use it for large background fills — it is an accent, not a canvas color.
- **Black/near-black (`#1A1A1A`)** carries text hierarchy, the bottom navigation bar, and secondary buttons — it grounds the yellow.
- **White/Gray surfaces** provide the premium, breathable canvas that lets yellow accents pop.
- **Semantic colors** (success/warning/error/info) are used only for status communication — never decoratively.
- Dark Mode keeps the same brand yellow (`#FFD400`) since it retains strong contrast against near-black surfaces; only neutrals and containers shift.

---

## 3. Typography

**Font family:** [**Inter**](https://fonts.google.com/specimen/Inter) (Google Font) — chosen for its high legibility at small sizes, neutral geometric character that conveys speed and clarity, and excellent numeral tabular figures for fares/ETAs.

| Style | Size | Weight | Line Height | Letter Spacing | Usage |
|---|---|---|---|---|---|
| Display Large | 40px | 700 (Bold) | 48px | -0.5px | Splash headline, onboarding hero text |
| Display Medium | 32px | 700 (Bold) | 40px | -0.25px | Ride-complete fare total |
| Display Small | 28px | 600 (SemiBold) | 36px | 0px | Screen hero numbers (ETA countdown) |
| Heading | 24px | 700 (Bold) | 32px | 0px | Screen titles ("Choose a ride") |
| Title | 20px | 600 (SemiBold) | 28px | 0px | Sheet titles, section headers |
| Subtitle | 16px | 600 (SemiBold) | 24px | 0px | Card titles, driver name |
| Body Large | 16px | 400 (Regular) | 24px | 0px | Primary body copy |
| Body Medium | 14px | 400 (Regular) | 20px | 0px | Secondary descriptions |
| Body Small | 12px | 400 (Regular) | 16px | 0.1px | Helper text, metadata |
| Caption | 11px | 500 (Medium) | 14px | 0.2px | Timestamps, fine print |
| Label | 12px | 600 (SemiBold) | 16px | 0.4px | Form labels, input hints (uppercase optional) |
| Button | 15px | 600 (SemiBold) | 20px | 0.1px | All button text |

**Numeral usage:** Enable tabular (lining) figures for fares, ETAs, and OTP fields so digits don't shift width during countdown animations.

---

## 4. Iconography

**Primary system:** **Material Symbols** (Rounded variant) for full Material 3 alignment and Flutter-native support.
**Secondary/accent system:** **Lucide** icons may be used for custom illustrative moments (empty states, onboarding) where Material Symbols feels too systemic.

| Property | Spec |
|---|---|
| Icon sizes | 16px (inline/caption), 20px (body/list), 24px (default/nav), 32px (feature/empty state), 48px (illustrative) |
| Stroke width | 1.5–2px equivalent (Rounded weight 400) |
| Filled vs Outlined | Outlined = default/inactive state; Filled = active/selected state (e.g. active bottom nav tab) |
| Color usage | Icons inherit `on-surface` by default; active icons use `primary` or `on-primary` depending on container |
| Disabled icons | `on-disabled` (#8A8A8A light / #6B6B6B dark), 38% opacity overlay |
| Navigation icons | 24px, Outlined inactive → Filled + primary color active, with 150ms crossfade |

---

## 5. Spacing System

8-point grid. All margins, paddings, and gaps must be multiples of these tokens.

| Token | Value | Typical Usage |
|---|---|---|
| `space-1` | 4px | Icon-to-label gap, chip internal padding |
| `space-2` | 8px | Compact stack spacing, small internal padding |
| `space-3` | 12px | Input internal padding, list item gap |
| `space-4` | 16px | Standard screen margin, card padding |
| `space-5` | 20px | Section internal padding |
| `space-6` | 24px | Section-to-section spacing |
| `space-8` | 32px | Large section breaks, sheet top padding |
| `space-10` | 40px | Hero spacing (splash/onboarding) |
| `space-12` | 48px | Major screen divisions |
| `space-16` | 64px | Splash logo offset, large empty-state spacing |

**Screen margin standard:** 16px left/right on all screens (20px optional for tablets/large phones).

---

## 6. Border Radius

| Element | Radius |
|---|---|
| Buttons (default) | 16px |
| Buttons (pill/FAB) | 28px (fully rounded) |
| Cards | 20px |
| Vehicle Cards | 24px |
| Bottom Sheets (top corners) | 28px |
| Dialogs | 24px |
| Inputs | 14px |
| Avatars | 50% (circular) |
| Map container / preview cards | 20px |
| Chips / Badges | 100px (pill) |

---

## 7. Elevation

Material 3 tonal elevation is preferred over heavy drop shadows — elevation is communicated primarily through subtle surface-tint shifts, with soft shadows layered on top.

| Component | Elevation Level | Shadow Spec |
|---|---|---|
| Cards (resting) | 1 | `0px 1px 3px rgba(0,0,0,0.06)` |
| Vehicle Cards (selected) | 3 | `0px 4px 12px rgba(0,0,0,0.10)` + 2px primary border |
| Dialogs | 4 | `0px 8px 24px rgba(0,0,0,0.16)` |
| Bottom Sheets | 3 | `0px -4px 20px rgba(0,0,0,0.12)` |
| Floating Buttons / FAB | 3 | `0px 4px 10px rgba(0,0,0,0.14)` |
| Snackbars | 4 | `0px 6px 16px rgba(0,0,0,0.18)` |
| Ride Status Cards (live tracking) | 3 | `0px 4px 14px rgba(0,0,0,0.12)` |
| Bottom Navigation Bar | 2 | `0px -1px 6px rgba(0,0,0,0.08)` |

Dark mode reduces shadow usage in favor of a subtle lighter-surface overlay (elevation overlay 5–12% white) since shadows read poorly on dark backgrounds.

---

## 8. Button System

| Button | Height | Radius | Fill | Text Color | Typography | States |
|---|---|---|---|---|---|---|
| Primary | 56px | 16px | `primary` #FFD400 | `on-primary` #1A1A1A | Button/SemiBold 15px | Default, Pressed (scale 0.97 + 8% darken), Disabled (`disabled` fill), Loading (spinner replaces label) |
| Secondary | 56px | 16px | `secondary` #1A1A1A | `on-secondary` #FFFFFF | Button/SemiBold 15px | Same pattern, pressed = 8% lighten |
| Outlined | 52px | 16px | Transparent | `on-surface` | Button/SemiBold 15px | Border `border` 1.5px; pressed = `surface-variant` fill fade-in |
| Text Button | 44px | 8px | Transparent | `primary`/`accent` | Button/SemiBold 15px | Pressed = 8% tinted background ripple |
| Danger | 56px | 16px | `error` #E5484D | `#FFFFFF` | Button/SemiBold 15px | Used for cancel-ride, delete actions |
| Success | 56px | 16px | `success` #1AAE6F | `#FFFFFF` | Button/SemiBold 15px | Used for confirm-payment, completion actions |
| Loading | 56px | 16px | Same as source variant, 80% opacity | — | — | Centered 20px spinner, label hidden, button non-interactive |
| Disabled | 56px | 16px | `disabled` #C9C9C9 | `on-disabled` #8A8A8A | Button/SemiBold 15px | No ripple, no elevation |
| FAB | 56×56px | 28px (circular) | `primary` | `on-primary` | Icon 24px | Elevation 3, scale-bounce on press |

**Animation:** All buttons use a 100ms scale-down (0.97) + opacity easing on press (`Curves.easeOut`), returning with `Curves.easeOutBack` on release (120ms).

---

## 9. Input System

| Input | Spec |
|---|---|
| Phone Number | 56px height, leading country-code selector, tabular numerals, radius 14px |
| OTP | 6 individual 48×56px boxes, radius 12px, auto-advance focus, shake animation on error |
| Search (Pickup/Destination) | 52px height, leading location-pin icon, trailing clear (×) icon, radius 14px, `surface-variant` fill |
| Manual Fare | Large centered numeric input, Display Small typography, currency prefix fixed |
| Feedback | Multiline expandable text area, 96px min height, radius 14px, 200 char counter |
| Profile (Name/Email) | 56px height, floating label pattern, radius 14px |

**States:**
- **Default:** `border` 1px, `surface` fill, `on-surface-variant` placeholder
- **Focused:** `primary` 2px border, subtle `primary-container` glow (4px, 12% opacity)
- **Error:** `error` 2px border, error icon trailing, helper text in `error` color, shake animation (±4px, 3 cycles, 300ms total)
- **Success:** `success` 2px border, checkmark trailing icon
- **Disabled:** `disabled` fill, `on-disabled` text, no border emphasis

---

## 10. Card System

| Card | Structure | Radius | Elevation | Key Details |
|---|---|---|---|---|
| Vehicle Card | Leading vehicle illustration (64px), name, capacity chip, ETA, trailing price (Subtitle/Bold) | 24px | 1 (3 selected) | Selected state = 2px primary border + `primary-container` tint background |
| Driver Card | Circular avatar (56px), name, rating chip (star + number), vehicle plate, call/message icon buttons | 20px | 1 | Rating chip uses `warning` star icon + Body Small text |
| History Card | Route icon column (pickup dot → line → destination pin), addresses, date/fare trailing | 20px | 1 | Tap expands to Ride Details |
| Payment Card | Card-brand icon, masked number, radio selector | 16px | 1 | Selected = primary radio + subtle `primary-container` fill |
| Statistics Card | Icon, large stat number (Display Small), label caption | 20px | 1 | Used in grid of 2 on Statistics screen |
| Settings Card | Leading icon, label, trailing chevron or switch | 16px (list-style, 0px between grouped items) | 0 (flat list) | Grouped in sections with dividers |
| Notification Card | Leading icon/avatar, title, timestamp, unread dot indicator | 20px | 0 (flat, divider-separated) | Unread = `primary-container` left accent bar (3px) |
| Ride Summary Card | Map thumbnail, route addresses, fare breakdown table | 24px | 2 | Used on Ride Complete & Ride Details screens |

Standard internal card padding: 16px. Standard gap between stacked cards: 12px.

---

## 11. Bottom Sheets

All sheets: top corner radius 28px, drag handle (32×4px, `border` color, centered, 8px top margin), elevation 3, `surface` background, max-height 90% of screen with internal scroll.

| Sheet | Detents | Content Summary |
|---|---|---|
| Vehicle Selection | Half (55%) → Full (90%) | Scrollable vehicle card list + sticky "Confirm" button footer |
| Ride Confirmation | Fixed (~45%) | Pickup/destination summary, fare, payment method row, Confirm CTA |
| Driver Assigned | Fixed (~50%) | Driver Card, vehicle plate, ETA countdown, Cancel text button |
| Ride Complete | Fixed (~60%) | Ride Summary Card, "Rate your ride" prompt, Done CTA |
| Payment | Half (50%) | Payment method list (Payment Cards), "Add method" text button |
| Rating | Fixed (~55%) | 5-star selector (large, 40px stars), optional feedback input, Submit CTA |
| Settings | Full (95%) | Grouped Settings Cards by category |
| Search | Full (95%), opens directly at full | Search input pinned top, Recent Places list below |
| Recent Places | Half (45%) → Full | List of saved/recent History Cards, "Add home/work" shortcuts |

**Entry animation:** slide-up 280ms `Curves.easeOutCubic` + backdrop fade-in (0→40% black scrim) 200ms.
**Dismiss:** drag-down gesture with velocity-based fling-to-close, or backdrop tap (except for required flows like Ride Confirmation).

---

## 12. Map Design

| Element | Spec |
|---|---|
| Marker Style | Custom flat-design pins, 2px white stroke, drop shadow `0px 2px 4px rgba(0,0,0,0.2)` |
| Pickup Marker | Solid `primary` yellow circle (16px) with white dot core |
| Destination Marker | `secondary` black teardrop pin (24px) with white flag icon |
| Driver Marker | Top-down vehicle icon (28px), rotates to match simulated heading, subtle drop shadow |
| Route Style | 5px solid line, `primary` yellow with 30% black outline (8px) for contrast on any basemap; dashed 4px `on-surface-variant` for alternate/unselected routes |
| Camera Behaviour | Auto-fit bounds on route display (60px padding); follows driver marker with `Curves.easeInOut` pan during live tracking; tilts 15° during "arriving" state for a dynamic feel |
| Zoom Levels | City overview: 12; Pickup/destination selection: 16; Live tracking: 17; Arrival close-up: 18 |
| User Location Indicator | Pulsing blue dot (Material standard), 12px core + animated 24px opacity-fading ring (1.5s loop) |

---

## 13. Navigation

| Element | Spec |
|---|---|
| Bottom Navigation | 4 items (Home, Activity, Wallet, Account), 64px height, `secondary`/black background, icon+label, active = Filled icon + `primary` label & icon tint |
| Navigation Bar (top app bar) | 56px height, transparent-over-map on Home, `surface` elevated on inner screens, centered or leading title (Title style) |
| Back Button | 40×40px circular tap target, `surface` translucent (80% opacity) background when floating over map, chevron-left 24px icon |
| Floating Buttons | Recenter-map FAB (bottom-right, above sheet), 48×48px, elevation 3 |
| Transitions | Push: slide-from-right 250ms `Curves.easeOutCubic`; Modal/sheet: slide-up (see §11); Tab switch: crossfade 150ms |
| Deep Links | `rideflow://ride/{id}`, `rideflow://history`, `rideflow://profile` — used for simulated notification taps |
| Navigation Animations | Shared-element transition for vehicle illustration (Vehicle Card → Confirmation sheet), Hero animation duration 300ms |

---

## 14. Screen Specifications

> Format per screen: Purpose · Layout · Component Tree · Spacing · Colors · Typography · Buttons · Icons · States · Animations · Navigation · Accessibility · Responsive Behaviour

### 14.1 Splash
- **Purpose:** Brand entry, initialize simulated session state.
- **Layout:** Centered logo lockup on `background`, vertically centered with 40px offset upward for optical balance.
- **Component Tree:** `Scaffold > Center > Column [Logo(96px), space-4, Wordmark(Display Small)]`
- **Spacing:** Logo-to-wordmark gap `space-4` (16px).
- **Colors:** Background `#0B0B0B` or `#FAFAFA`; logo full-color yellow/black.
- **Typography:** Wordmark = Display Small, `on-surface`.
- **Buttons:** None.
- **Icons:** None (logo mark only).
- **States:** Loading (default) → auto-navigate after 1.2s simulated init.
- **Animations:** Logo scale-in 0.8→1.0 with fade, 400ms `Curves.easeOutBack`.
- **Navigation:** Auto-forward to Onboarding (first launch) or Home (returning user).
- **Accessibility:** Screen-reader announces "RideFlow Simulator, loading."
- **Responsive:** Logo scales proportionally on tablets; max width 120px.

### 14.2 Onboarding
- **Purpose:** Communicate app value in 3 swipeable slides.
- **Layout:** Full-bleed illustration (top 60%), text block (bottom 40%) with page indicator dots and Skip/Next controls.
- **Component Tree:** `PageView > [Illustration, space-6, Title(Heading), space-2, Body(Body Large), space-8, DotsIndicator, space-4, Buttons Row]`
- **Spacing:** Screen margin 24px; illustration-to-text `space-8`.
- **Colors:** `background`; accent illustrations use `primary` + `secondary` duotone.
- **Typography:** Title = Heading; Body = Body Large, `on-surface-variant`.
- **Buttons:** Text Button "Skip" (top-right), Primary Button "Next"/"Get Started" (final slide).
- **Icons:** Dot indicators (8px inactive `border`, 24px pill active `primary`).
- **States:** Slide 1/2/3, final CTA swaps label.
- **Animations:** Parallax illustration shift on swipe; dot indicator morph 200ms.
- **Navigation:** → Login on completion.
- **Accessibility:** Each slide announced with heading + body; Skip always reachable.
- **Responsive:** Illustration max-height capped at 420px on large screens.

### 14.3 Login
- **Purpose:** Simulated phone-number entry point.
- **Layout:** Top logo mark, headline, phone input, primary CTA, legal footnote.
- **Component Tree:** `Column [Logo(48px), space-6, Heading, space-2, Subtitle, space-6, PhoneInput, space-6, PrimaryButton, space-4, LegalText]`
- **Spacing:** Screen margin 16px; field-to-button `space-6`.
- **Colors:** `background`; input `surface-variant`.
- **Typography:** Heading "Enter your phone number"; Legal = Caption, `on-surface-variant`.
- **Buttons:** Primary "Continue" (disabled until valid 10-digit input).
- **Icons:** Country flag/chevron in phone input prefix.
- **States:** Empty, Valid, Invalid (shake + error helper), Loading (button spinner during simulated "send OTP").
- **Animations:** Button enable = fade+scale 150ms.
- **Navigation:** → OTP screen.
- **Accessibility:** Input labeled "Phone number, required"; error announced via live region.
- **Responsive:** Full-width input up to 480px max on tablets, then centered column.

### 14.4 OTP
- **Purpose:** Simulated 6-digit verification.
- **Layout:** Headline referencing masked phone number, 6-box OTP input, resend timer, CTA.
- **Component Tree:** `Column [Heading, space-2, Subtitle(masked phone), space-8, OTPBoxes(6), space-4, ResendRow, space-8, PrimaryButton]`
- **Colors/Typography:** Standard per §3/§2.
- **Buttons:** Primary "Verify" (auto-submits on 6th digit in simulator).
- **States:** Entering, Error (shake, red border, "Invalid code" helper), Success (green flash → auto-advance).
- **Animations:** Box focus glow 150ms; success checkmark burst 300ms before navigating.
- **Navigation:** → Profile Setup (first-time) or Home (returning).
- **Accessibility:** Each box announces position ("Digit 1 of 6"); resend button disabled state announced with countdown.
- **Responsive:** Box size scales down proportionally on narrow (<360px) devices.

### 14.5 Profile Setup
- **Purpose:** Collect simulated display name, email, avatar.
- **Layout:** Circular avatar picker top-center, form fields below, CTA pinned bottom.
- **Component Tree:** `Column [AvatarPicker(96px + edit badge), space-6, NameInput, space-4, EmailInput, space-8, PrimaryButton]`
- **Buttons:** Primary "Continue"; Text Button "Skip for now".
- **States:** Validation per §9.
- **Animations:** Avatar picker bounce on tap 150ms.
- **Navigation:** → Home.
- **Accessibility:** Avatar button labeled "Change profile photo".
- **Responsive:** Centered max-width 480px column.

### 14.6 Home
- **Purpose:** Primary hub — map + destination search entry.
- **Layout:** Full-bleed map background, floating top bar (greeting + notification bell), floating search sheet docked at bottom (peek height 120px).
- **Component Tree:** `Stack [Map, TopBar(floating), BottomSheet(SearchEntry + Recent Places shortcuts + Saved Places chips)]`
- **Colors:** Map full-color; floating elements `surface` at 95% opacity.
- **Typography:** Greeting = Subtitle; "Where to?" search field = Body Large placeholder.
- **Buttons:** Search field acts as tap-target button → opens Search sheet full; Recenter FAB.
- **Icons:** Bell (notifications), profile avatar (top-left/right), location-pin (search field prefix).
- **States:** Default, Location-permission-denied (banner prompt), Saved-places-empty.
- **Animations:** Sheet peek subtle bounce on load 400ms; map pin drop 250ms on load.
- **Navigation:** → Destination Search, → Notifications, → Profile.
- **Accessibility:** Map marked decorative for screen readers; search field is primary focus target.
- **Responsive:** Sheet peek height increases slightly on tablets for better thumb reach parity.

### 14.7 Pickup Search
- **Purpose:** Confirm/adjust simulated pickup location.
- **Layout:** Full sheet with search input pinned top, current-location shortcut row, results list.
- **Component Tree:** `Column [SearchInput, space-3, CurrentLocationRow, Divider, ResultsList]`
- **Buttons:** Text Button-style list rows ("Use current location").
- **States:** Typing (live-filtered simulated results), Empty query (recent places shown), No results.
- **Animations:** List item insert/remove via `AnimatedList`, 200ms.
- **Navigation:** → Destination Search or back to Home with pickup set.
- **Accessibility:** Each result row announces name + address.

### 14.8 Destination Search
- Mirrors Pickup Search structure with destination-specific copy ("Where are you going?"), plus a persistent mini pickup-summary chip at top showing the already-selected pickup.
- **Navigation:** → Vehicle Selection once both points are set.

### 14.9 Vehicle Selection
- **Purpose:** Choose simulated ride tier.
- **Layout:** Map shrinks to top 40%, Vehicle Selection sheet (§11) occupies remainder.
- **Component Tree:** `Column [RouteSummaryRow, Divider, VehicleCardList(scrollable), StickyFooter[PaymentMethodChip, ConfirmButton]]`
- **States:** Loading fares (skeleton cards, 3× shimmer 800ms loop), Loaded, Selected (border+tint).
- **Animations:** Card selection = scale 1.0→1.02→1.0 bounce 200ms + border color transition.
- **Navigation:** → Ride Confirmation, or → Manual Fare (if "Enter your own fare" option tapped).
- **Accessibility:** Selected card announces "Selected, [vehicle name], [price]".

### 14.10 Manual Fare
- **Purpose:** Simulate custom fare negotiation flow.
- **Layout:** Centered large numeric input (Display Small), quick-suggestion chips, CTA.
- **Buttons:** Primary "Request at this fare".
- **States:** Below-minimum (error), Valid.
- **Animations:** Chip tap fills input with count-up animation 300ms.
- **Navigation:** → Ride Confirmation.

### 14.11 Ride Confirmation
- **Purpose:** Final review before simulated dispatch.
- **Layout:** Bottom sheet (§11) with route mini-map, fare breakdown, payment row, Confirm CTA.
- **Animations:** Sheet content fade-in staggered by 40ms per row.
- **Navigation:** → Searching Driver.

### 14.12 Searching Driver
- **Purpose:** Simulated matching animation.
- **Layout:** Full-screen map with animated radar-pulse rings centered on pickup pin, status text below, Cancel text button.
- **Animations:** Concentric pulse rings (3 rings, staggered 400ms, 2s loop, `primary` 20% opacity); status text crossfades through simulated phases ("Finding nearby drivers…" → "Matching you with a driver…") every 2.5s.
- **States:** Searching (default), Matched (transitions to Driver Assigned), Timeout (rare simulated fallback → retry prompt).
- **Navigation:** Auto-advances to Driver Assigned after simulated delay (3–5s).
- **Accessibility:** Live region announces phase changes for screen readers.

### 14.13 Driver Assigned
- **Purpose:** Reveal simulated driver + vehicle details.
- **Layout:** Map shows driver marker en route to pickup; Driver Assigned sheet (§11) with Driver Card, ETA, Cancel option.
- **Animations:** Sheet slides up with a celebratory subtle scale-bounce (1.0→1.03→1.0, 300ms); driver marker animates along simulated path.
- **Navigation:** Auto-transitions to Driver Arriving as simulated ETA nears 1 min.

### 14.14 Driver Arriving
- **Purpose:** Heighten anticipation as simulated driver nears pickup.
- **Layout:** Same as Driver Assigned but ETA badge pulses, map camera tilts (§12), "Driver is arriving" banner.
- **Animations:** ETA number count-down with digit-roll transition each second; banner slide-in from top 250ms.
- **Navigation:** → Live Tracking once simulated pickup occurs.

### 14.15 Live Tracking
- **Purpose:** Simulate the in-ride journey.
- **Layout:** Full map with route polyline, driver marker moving along path, collapsed Ride Status Card (peek 96px) showing ETA + destination, expandable to show trip details.
- **Animations:** Marker interpolates position every 1s along path (`Curves.linear` between points); route "consumed" portion dims to `on-surface-variant` behind the marker.
- **States:** In-progress, Approaching destination (banner), Arrived.
- **Navigation:** Auto-transitions to Ride Complete on simulated arrival.
- **Accessibility:** ETA updates announced politely (not interrupting), max once per 30s.

### 14.16 Ride Complete
- **Purpose:** Wrap-up and transition to payment/rating.
- **Layout:** Ride Complete sheet (§11): success checkmark animation, Ride Summary Card, "Continue to payment" CTA.
- **Animations:** Success checkmark draws on (SVG stroke animation, 500ms `Curves.easeOut`) with a soft haptic-style scale pulse.
- **Navigation:** → Payment Success (simulated instant) → Rating.

### 14.17 Payment Success
- **Purpose:** Confirm simulated payment processed.
- **Layout:** Centered success illustration, fare total (Display Medium), payment method used, Done/Continue CTA.
- **Animations:** Illustration bounces in (scale 0.8→1.0, `Curves.elasticOut`, 500ms); confetti-style particle burst (subtle, brand colors only, 800ms, respects reduced-motion).
- **Navigation:** → Rating.

### 14.18 Rating
- **Purpose:** Simulated post-ride feedback.
- **Layout:** Rating sheet (§11): driver avatar, 5-star selector, optional comment input, Submit CTA, "Skip" text link.
- **Animations:** Each star fills with a sequential pop (60ms stagger) as user drags/taps across the row.
- **Navigation:** → Home.

### 14.19 Ride History
- **Purpose:** List of simulated past rides.
- **Layout:** Top app bar "Activity", filter chips row (All/This Week/This Month), scrollable list of History Cards grouped by date headers.
- **States:** Empty (illustration + "No rides yet"), Loaded.
- **Animations:** List entrance stagger 30ms per item on first load.
- **Navigation:** → Ride Details on card tap.

### 14.20 Ride Details
- **Purpose:** Deep-dive into one simulated past ride.
- **Layout:** Static route map thumbnail top, Ride Summary Card, fare breakdown table, driver recap, "Rebook similar ride" secondary button.
- **Navigation:** Back to Ride History; → Vehicle Selection (pre-filled) on Rebook.

### 14.21 Notifications
- **Purpose:** Simulated system/promo notifications feed.
- **Layout:** Top app bar, list of Notification Cards grouped by Today/Earlier.
- **States:** Empty, Unread (accent bar), Read.
- **Animations:** Swipe-to-dismiss with `Curves.easeOut`, 200ms.

### 14.22 Profile
- **Purpose:** Account overview hub.
- **Layout:** Header card (avatar, name, member-since), grid of quick links (History, Statistics, Payment, Settings).
- **Navigation:** → respective sub-screens.

### 14.23 Statistics
- **Purpose:** Simulated usage insights (fun/gamified).
- **Layout:** 2-column grid of Statistics Cards (Total Rides, Distance, CO2 Saved-equivalent, Favorite Vehicle), chart of rides-per-month below.
- **Animations:** Number count-up animation on load (0→value, 800ms `Curves.easeOutExpo`); bar chart bars grow from baseline 400ms staggered 40ms each.

### 14.24 Settings
- **Purpose:** App preferences.
- **Layout:** Settings sheet/full screen with grouped Settings Cards (Account, Notifications, Appearance [Light/Dark/System], Privacy, About).
- **States:** Toggle switches (on/off animated 150ms slide).

### 14.25 About
- **Purpose:** App info, version, simulated disclaimers, credits.
- **Layout:** Centered logo, version string (Caption), short description, links list (Licenses, Privacy Policy placeholder).

---

## 15. Animation System

| Motion | Duration | Curve | Notes |
|---|---|---|---|
| Page Transitions (push) | 250ms | `Curves.easeOutCubic` | Slide from right, 8% opacity fade-in on incoming |
| Bottom Sheet Open | 280ms | `Curves.easeOutCubic` | Slide up + scrim fade 0→40% |
| Bottom Sheet Close | 220ms | `Curves.easeInCubic` | Slide down + scrim fade out |
| Button Press | 100ms down / 120ms up | `Curves.easeOut` / `Curves.easeOutBack` | Scale 1.0→0.97→1.0 |
| Map Camera Move | 600–900ms | `Curves.easeInOut` | Bounds-fit or marker-follow |
| Marker Movement (live tracking) | 1000ms per tick | `Curves.linear` | Interpolated GPS-like motion |
| Loading Indicators (shimmer) | 800ms loop | `Curves.easeInOut` | Skeleton cards, left-to-right sweep |
| Driver Search Radar | 2000ms loop, 3 rings staggered 400ms | `Curves.easeOut` | Opacity 40%→0%, scale 1.0→2.2 |
| Ride Progress Bar | Continuous, tied to simulated ETA | `Curves.linear` | Fill proportion updates |
| Success Checkmark Draw | 500ms | `Curves.easeOut` | SVG path stroke-dashoffset animation |
| Success Confetti/Particles | 800ms | `Curves.decelerate` | Subtle, brand-colored, disabled under reduced-motion |
| Number Count-Up | 600–800ms | `Curves.easeOutExpo` | Fares, stats, ETA digits |
| List Item Stagger | 30–40ms increment per item | `Curves.easeOut` | Cap total stagger at ~400ms regardless of list length |

All durations above are baseline; respect the OS-level "reduce motion" accessibility setting by collapsing non-essential motion (confetti, radar pulses, parallax) to simple fades ≤150ms.

---

## 16. Accessibility

| Requirement | Spec |
|---|---|
| Minimum Touch Target | 48×48dp for all interactive elements, including icon-only buttons |
| Contrast Ratios | 4.5:1 minimum for body text, 3:1 for large text (≥24px) and icons; primary yellow always paired with near-black text/icons to guarantee ≥4.5:1 |
| Screen Reader Labels | Every icon-only control has a semantic label (`Semantics(label:)`); status changes (driver assigned, ride complete) announced via live regions |
| Dynamic Font Scaling | All text uses `MediaQuery.textScaler`; layouts tested up to 130% scale without truncation (use `FittedBox`/flexible layouts for critical numerals) |
| Color Blind Support | Status is never conveyed by color alone — success/warning/error always paired with icon + text label |
| Keyboard Navigation | Full tab-order support for external keyboard/Android accessibility scanning; visible focus rings (`2px primary outline`, 2px offset) |

---

## 17. Design Tokens

```json
{
  "color": {
    "primary": { "light": "#FFD400", "dark": "#FFD400" },
    "primaryContainer": { "light": "#FFF3B0", "dark": "#4A3F00" },
    "onPrimary": { "light": "#1A1A1A", "dark": "#1A1A1A" },
    "secondary": { "light": "#1A1A1A", "dark": "#F5F5F5" },
    "onSecondary": { "light": "#FFFFFF", "dark": "#1A1A1A" },
    "accent": { "light": "#2F6FED", "dark": "#5B8FFF" },
    "success": { "light": "#1AAE6F", "dark": "#3FD08C" },
    "warning": { "light": "#F2A900", "dark": "#F2C14E" },
    "error": { "light": "#E5484D", "dark": "#FF6B6E" },
    "info": { "light": "#2F6FED", "dark": "#5B8FFF" },
    "surface": { "light": "#FFFFFF", "dark": "#121212" },
    "background": { "light": "#FAFAFA", "dark": "#0B0B0B" },
    "divider": { "light": "#E3E3E3", "dark": "#2A2A2A" },
    "disabled": { "light": "#C9C9C9", "dark": "#3A3A3A" },
    "border": { "light": "#DDDDDD", "dark": "#333333" }
  },
  "spacing": {
    "1": 4, "2": 8, "3": 12, "4": 16, "5": 20,
    "6": 24, "8": 32, "10": 40, "12": 48, "16": 64
  },
  "radius": {
    "button": 16, "buttonPill": 28, "card": 20, "vehicleCard": 24,
    "sheet": 28, "dialog": 24, "input": 14, "avatar": 9999, "chip": 9999
  },
  "elevation": {
    "card": 1, "cardSelected": 3, "dialog": 4, "sheet": 3,
    "fab": 3, "snackbar": 4, "navBar": 2
  },
  "opacity": {
    "disabled": 0.38, "scrim": 0.4, "pressedOverlay": 0.08, "focusGlow": 0.12
  },
  "duration": {
    "instant": 100, "fast": 150, "base": 250, "sheet": 280,
    "loading": 800, "radar": 2000, "countUp": 700
  },
  "iconSize": { "xs": 16, "sm": 20, "md": 24, "lg": 32, "xl": 48 },
  "typography": {
    "displayLarge": { "size": 40, "weight": 700, "lineHeight": 48, "tracking": -0.5 },
    "displayMedium": { "size": 32, "weight": 700, "lineHeight": 40, "tracking": -0.25 },
    "displaySmall": { "size": 28, "weight": 600, "lineHeight": 36, "tracking": 0 },
    "heading": { "size": 24, "weight": 700, "lineHeight": 32, "tracking": 0 },
    "title": { "size": 20, "weight": 600, "lineHeight": 28, "tracking": 0 },
    "subtitle": { "size": 16, "weight": 600, "lineHeight": 24, "tracking": 0 },
    "bodyLarge": { "size": 16, "weight": 400, "lineHeight": 24, "tracking": 0 },
    "bodyMedium": { "size": 14, "weight": 400, "lineHeight": 20, "tracking": 0 },
    "bodySmall": { "size": 12, "weight": 400, "lineHeight": 16, "tracking": 0.1 },
    "caption": { "size": 11, "weight": 500, "lineHeight": 14, "tracking": 0.2 },
    "label": { "size": 12, "weight": 600, "lineHeight": 16, "tracking": 0.4 },
    "button": { "size": 15, "weight": 600, "lineHeight": 20, "tracking": 0.1 }
  }
}
```

---

## 18. Flutter Implementation Guide

### 18.1 ThemeData / ColorScheme

```dart
final ColorScheme rideFlowLightScheme = ColorScheme.light(
  primary: Color(0xFFFFD400),
  onPrimary: Color(0xFF1A1A1A),
  primaryContainer: Color(0xFFFFF3B0),
  secondary: Color(0xFF1A1A1A),
  onSecondary: Color(0xFFFFFFFF),
  error: Color(0xFFE5484D),
  surface: Color(0xFFFFFFFF),
  onSurface: Color(0xFF1A1A1A),
  surfaceContainerHighest: Color(0xFFF7F7F7),
  outline: Color(0xFFDDDDDD),
);

final ThemeData rideFlowLightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: rideFlowLightScheme,
  scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  fontFamily: 'Inter',
);
```

### 18.2 TextTheme
Map each typographic role in §3 to Flutter's `TextTheme` slots (e.g. `displayLarge`, `headlineMedium` → Heading, `titleMedium` → Title, `bodyLarge`/`bodyMedium`/`bodySmall`, `labelLarge` → Button, `labelSmall` → Caption). Define as a `TextTheme` constant and pass into `ThemeData(textTheme:)`, keeping the token JSON in §17 as the single source of truth.

### 18.3 ButtonTheme
Use `ElevatedButtonThemeData`, `OutlinedButtonThemeData`, `TextButtonThemeData` with:
- `shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))`
- `minimumSize: Size.fromHeight(56)`
- `textStyle:` Button token
- Custom `ButtonStyle.overlayColor` for the 8% pressed-state tint

### 18.4 InputDecorationTheme
```dart
InputDecorationTheme(
  filled: true,
  fillColor: Color(0xFFF7F7F7),
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Color(0xFFDDDDDD)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Color(0xFFFFD400), width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(14),
    borderSide: BorderSide(color: Color(0xFFE5484D), width: 2),
  ),
)
```

### 18.5 BottomSheetTheme
```dart
BottomSheetThemeData(
  backgroundColor: Colors.white,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
  ),
  elevation: 3,
  modalBarrierColor: Colors.black.withOpacity(0.4),
)
```

### 18.6 CardTheme
```dart
CardTheme(
  color: Colors.white,
  elevation: 1,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  margin: EdgeInsets.zero,
)
```

### 18.7 NavigationBarTheme
```dart
NavigationBarThemeData(
  backgroundColor: Color(0xFF1A1A1A),
  height: 64,
  indicatorColor: Color(0xFFFFD400).withOpacity(0.15),
  labelTextStyle: MaterialStateProperty.resolveWith((states) =>
    TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: states.contains(MaterialState.selected)
          ? Color(0xFFFFD400)
          : Colors.white70,
    )),
)
```

### 18.8 IconTheme
```dart
IconThemeData(color: Color(0xFF1A1A1A), size: 24)
```

### 18.9 Extensions
Create a `RideFlowTokens` `ThemeExtension` to expose custom tokens not covered by `ColorScheme`/`TextTheme` (e.g. `success`, `warning`, `info`, elevation shadows, spacing constants) so they're accessible via `Theme.of(context).extension<RideFlowTokens>()`.

```dart
class RideFlowTokens extends ThemeExtension<RideFlowTokens> {
  final Color success;
  final Color warning;
  final Color info;
  final EdgeInsets screenMargin;

  const RideFlowTokens({
    required this.success,
    required this.warning,
    required this.info,
    required this.screenMargin,
  });

  @override
  RideFlowTokens copyWith({...}) => ...;

  @override
  RideFlowTokens lerp(ThemeExtension<RideFlowTokens>? other, double t) => this;
}
```

---

## 19. Developer Notes & Checklists

### 19.1 Build Checklist
- [ ] Implement `RideFlowLightTheme` and `RideFlowDarkTheme` from §18.1 with `ThemeMode.system` default
- [ ] Register `Inter` font (Google Fonts package or bundled assets) with all required weights (400/500/600/700)
- [ ] Build reusable `AppButton` widget covering all 9 variants in §8 via a single enum-driven component
- [ ] Build reusable `AppInput` widget covering states in §9
- [ ] Build `VehicleCard`, `DriverCard`, `HistoryCard`, etc. as independent, prop-driven widgets per §10
- [ ] Implement `RideFlowBottomSheet` wrapper enforcing radius/elevation/handle/scrim consistency (§11)
- [ ] Mock all map behavior with a simulated `FakeMapController` — no real Maps SDK network calls required; static tile assets or a lightweight vector map package are acceptable
- [ ] Build a central `SimulationEngine` service that drives fake timers for driver search, ETA countdowns, and marker movement — keeping all screens reactive to one source of truth
- [ ] Implement reduced-motion checks (`MediaQuery.disableAnimations`) across all custom animations in §15
- [ ] Verify all 25 screens in §14 against their individual Accessibility notes
- [ ] Run contrast-ratio audits on every color pairing in §2 against §16 requirements

### 19.2 Component Library Priority (build order)
1. Design tokens (§17) as Dart constants
2. Typography + Theme setup (§18.1–18.2)
3. `AppButton`, `AppInput` (§8–9)
4. `VehicleCard`, `DriverCard`, `RideSummaryCard` (§10)
5. `RideFlowBottomSheet` + all sheet content (§11)
6. Map mock layer + marker system (§12)
7. Navigation shell (bottom nav + app bars) (§13)
8. Screen assembly in the order listed in §14
9. Animation polish pass (§15)
10. Accessibility audit pass (§16)

### 19.3 Notes for Designers Handing Off to Flutter
- All spacing/radius/color values must map 1:1 to the tokens in §17 — no ad hoc values in Figma.
- Vehicle illustrations should be delivered as SVG for crisp rendering at all densities, sized to a consistent 64×64 bounding box.
- Provide both Light and Dark exports for every screen; dark mode is not an afterthought — it uses distinct container tokens, not a simple color invert.
- Motion specs (§15) should be documented directly on Figma Smart Animate transitions where possible, using the same duration/curve names so engineering can 1:1 match them in Flutter's `Curves` class.
