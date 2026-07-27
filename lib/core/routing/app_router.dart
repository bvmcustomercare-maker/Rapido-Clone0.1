import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/ride/presentation/screens/active_ride_screen.dart';
import '../../features/ride/presentation/screens/payment_success_screen.dart';
import '../../features/ride/presentation/screens/ride_summary_screen.dart';
import '../../features/history/presentation/screens/ride_history_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/statistics_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/profile/presentation/screens/about_screen.dart';
import '../../features/profile/presentation/screens/privacy_screen.dart';
import 'route_paths.dart';

/// Riverpod provider for GoRouter instance (Dependency Injection container)
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.otp,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) {
          final phone = state.uri.queryParameters['phone'] ?? '';
          return SignupScreen(phone: phone);
        },
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/ride',
        builder: (context, state) => const ActiveRideScreen(),
      ),
      GoRoute(
        path: '/payment',
        builder: (context, state) => const PaymentSuccessScreen(),
      ),
      GoRoute(
        path: RoutePaths.rideSummary,
        builder: (context, state) => const RideSummaryScreen(),
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const RideHistoryScreen(),
      ),
      GoRoute(
        path: RoutePaths.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RoutePaths.statistics,
        builder: (context, state) => const StatisticsScreen(),
      ),
      GoRoute(
        path: RoutePaths.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.about,
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: RoutePaths.privacy, // Note: Need to verify if privacy is in route_paths
        builder: (context, state) => const PrivacyScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Routing Error: ${state.error}'),
      ),
    ),
  );
});

