import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/splash_providers.dart';
import '../../routes/route_names.dart';

/// Écran de démarrage (Splash Screen) avec la nouvelle architecture
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // L'état sera vérifié automatiquement par le provider
  }

  void _handleSplashState(SplashUserState state) {
    if (!mounted) return;

    switch (state) {
      case SplashUserState.customerLoggedIn:
        context.go(RouteNames.home);
        break;
      case SplashUserState.ownerLoggedIn:
        context.go(RouteNames.ownerDashboard);
        break;
      case SplashUserState.notLoggedIn:
        context.go(RouteNames.userTypeSelection);
        break;
      case SplashUserState.checking:
        // Attendre que la vérification soit terminée
        break;
    }
  }

  void _showConnectionError() {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Connection Failed'),
        content: const Text('Turn on your internet connection'),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              SystemNavigator.pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Écouter les changements d'état et naviguer en conséquence
    ref.listen<AsyncValue<SplashUserState>>(
      splashNotifierProvider,
      (previous, next) {
        next.whenData((state) {
          _handleSplashState(state);
        });
        if (next.hasError) {
          final error = next.error;
          if (error != null && error.toString().contains('No internet connection')) {
            _showConnectionError();
          }
        }
      },
    );

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('images/splash.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

