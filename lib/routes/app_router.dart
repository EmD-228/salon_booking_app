import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/email_verify_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/change_password_screen.dart';
import 'route_names.dart';

// Import temporaire des anciens écrans (seront migrés progressivement)
import '../starting_screens/SpalshScreen.dart';
import '../intro.dart';
import '../Home_page/HomePage.dart';
import '../shopowner/Shopowner_login.dart';
import '../shopowner/customerpage.dart';

/// Provider pour le router de l'application
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.value?.value != null;
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
        builder: (context, state) => Shop_owner_login(),
      ),

      // Customer - Main Routes
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const Home_Page_Screen(),
      ),
      // TODO: Ajouter les autres routes customer quand elles seront migrées
      // GoRoute(
      //   path: RouteNames.salonDetail,
      //   name: 'salonDetail',
      //   builder: (context, state) {
      //     final salonId = int.parse(state.pathParameters['id']!);
      //     return SalonDetailScreen(salonId: salonId);
      //   },
      // ),

      // Owner - Main Routes
      GoRoute(
        path: RouteNames.ownerDashboard,
        name: 'ownerDashboard',
        builder: (context, state) => const customer(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
});

