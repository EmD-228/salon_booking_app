import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import '../features/auth/presentation/screens/email_verify_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/booking/presentation/screens/booking_confirmation_screen.dart';
import '../features/booking/presentation/screens/bookings_list_screen.dart';
import '../features/booking/presentation/screens/time_slot_screen.dart';
import '../features/owner/presentation/screens/owner_dashboard_screen.dart';
import '../features/owner/presentation/screens/owner_login_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/salon/presentation/screens/home_screen.dart';
import '../features/salon/presentation/screens/salon_detail_screen.dart';
import '../features/salon/presentation/screens/search_location_screen.dart';
import '../intro.dart';
// Import temporaire des anciens écrans (seront migrés progressivement)
import '../starting_screens/SpalshScreen.dart';
import 'route_names.dart';

/// Provider pour le router de l'application
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isOwnerLoggedIn = false; // TODO: Implémenter avec owner provider
      final currentLocation = state.matchedLocation;

      // Routes publiques (accessibles sans authentification)
      final publicRoutes = [
        RouteNames.splash,
        RouteNames.userTypeSelection,
        RouteNames.login,
        RouteNames.register,
        RouteNames.emailVerify,
        RouteNames.forgotPassword,
        RouteNames.changePassword,
        RouteNames.ownerLogin,
      ];

      final isPublicRoute = publicRoutes.contains(currentLocation);

      // Si l'utilisateur est sur une route publique, pas de redirection
      if (isPublicRoute) {
        return null;
      }

      // Si l'utilisateur n'est pas connecté et essaie d'accéder à une route protégée
      if (!isLoggedIn && !isOwnerLoggedIn) {
        return RouteNames.userTypeSelection;
      }

      // Si l'utilisateur est connecté et essaie d'accéder à login/register
      if (isLoggedIn && (currentLocation == RouteNames.login || currentLocation == RouteNames.register)) {
        return RouteNames.home;
      }

      return null;
    },
    routes: [
      // Splash Screen
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => Splash_Screen_Screen(),
      ),

      // User Type Selection
      GoRoute(
        path: RouteNames.userTypeSelection,
        name: 'userTypeSelection',
        builder: (context, state) => const App(),
      ),

      // Auth - Customer Routes
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: RouteNames.emailVerify,
        name: 'emailVerify',
        builder: (context, state) {
          final extra = state.extra as Map<String, String>?;
          return EmailVerifyScreen(
            email: extra?['email'] ?? '',
            name: extra?['name'] ?? '',
            phoneNumber: extra?['phoneNumber'] ?? '',
            password: extra?['password'] ?? '',
          );
        },
      ),
      GoRoute(
        path: RouteNames.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: 'changePassword',
        builder: (context, state) {
          final extra = state.extra as String?;
          return ChangePasswordScreen(email: extra ?? '');
        },
      ),

      // Auth - Owner Routes
      GoRoute(
        path: RouteNames.ownerLogin,
        name: 'ownerLogin',
        builder: (context, state) => const OwnerLoginScreen(),
      ),

      // Customer - Main Routes
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.salonDetail,
        name: 'salonDetail',
        builder: (context, state) {
          final salonId = int.parse(state.pathParameters['id']!);
          return SalonDetailScreen(salonId: salonId);
        },
      ),
      GoRoute(
        path: RouteNames.searchLocation,
        name: 'searchLocation',
        builder: (context, state) {
          final query = state.uri.queryParameters['q'] ?? '';
          return SearchLocationScreen(searchQuery: query);
        },
      ),
      GoRoute(
        path: RouteNames.profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.timeSlot,
        name: 'timeSlot',
        builder: (context, state) {
          final salonId = int.parse(state.pathParameters['id']!);
          final serviceType = state.extra as String? ?? 'Haircut';
          return TimeSlotScreen(
            salonId: salonId,
            serviceType: serviceType,
          );
        },
      ),
      GoRoute(
        path: RouteNames.bookingsList,
        name: 'bookingsList',
        builder: (context, state) => const BookingsListScreen(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmation,
        name: 'bookingConfirmation',
        builder: (context, state) => const BookingConfirmationScreen(),
      ),

      // Owner - Main Routes
      GoRoute(
        path: RouteNames.ownerDashboard,
        name: 'ownerDashboard',
        builder: (context, state) => const OwnerDashboardScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});

