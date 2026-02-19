import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mechiebro/features/admin/presentation/admin_screen.dart';
import 'package:mechiebro/features/auth/application/auth_controller.dart';
import 'package:mechiebro/features/auth/presentation/login_screen.dart';
import 'package:mechiebro/features/bookings/presentation/bookings_screen.dart';
import 'package:mechiebro/features/emergency/presentation/emergency_request_screen.dart';
import 'package:mechiebro/features/home/presentation/home_screen.dart';
import 'package:mechiebro/features/mechanic/presentation/mechanic_onboarding_screen.dart';
import 'package:mechiebro/features/payments/presentation/payment_screen.dart';
import 'package:mechiebro/features/profile/presentation/profile_screen.dart';
import 'package:mechiebro/features/ratings/presentation/rating_screen.dart';
import 'package:mechiebro/features/settings/presentation/settings_screen.dart';
import 'package:mechiebro/features/support/presentation/support_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final loggedIn = auth.valueOrNull != null;
      const protectedRoutes = {'/emergency', '/bookings', '/profile', '/mechanic-onboarding'};
      if (!loggedIn && protectedRoutes.contains(state.matchedLocation)) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
      GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
      GoRoute(path: '/emergency', builder: (_, __) => const EmergencyRequestScreen()),
      GoRoute(path: '/bookings', builder: (_, __) => const BookingsScreen()),
      GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      GoRoute(path: '/support', builder: (_, __) => const SupportScreen()),
      GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
      GoRoute(path: '/mechanic-onboarding', builder: (_, __) => const MechanicOnboardingScreen()),
      GoRoute(path: '/admin', builder: (_, __) => const AdminScreen()),
      GoRoute(path: '/payment', builder: (_, __) => const PaymentScreen()),
      GoRoute(path: '/rating', builder: (_, __) => const RatingScreen()),
    ],
    errorBuilder: (_, __) => const Scaffold(body: Center(child: Text('Route not found'))),
  );
});
