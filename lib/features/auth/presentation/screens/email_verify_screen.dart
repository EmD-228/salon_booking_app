import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_providers.dart';
import '../../../../core/utils/error_handler.dart';
import '../../../../routes/route_names.dart';

/// Écran de vérification d'email avec OTP
class EmailVerifyScreen extends ConsumerStatefulWidget {
  final String email;
  final String name;
  final String phoneNumber;
  final String password;

  const EmailVerifyScreen({
    super.key,
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.password,
  });

  @override
  ConsumerState<EmailVerifyScreen> createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends ConsumerState<EmailVerifyScreen> {
  final _otpController = TextEditingController();
  bool _isVerifying = false;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (_otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the OTP code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    final isValid = await ref
        .read(authNotifierProvider.notifier)
        .verifyEmail(widget.email, _otpController.text);

    if (isValid && mounted) {
      // Si l'OTP est valide, procéder à l'inscription
      await ref.read(authNotifierProvider.notifier).register(
            email: widget.email,
            name: widget.name,
            phoneNumber: widget.phoneNumber,
            password: widget.password,
          );

      // Écouter le résultat de l'inscription
      ref.listen<AsyncValue>(authNotifierProvider, (previous, next) {
        next.whenOrNull(
          data: (user) {
            if (user != null && mounted) {
              // Navigation vers Home avec GoRouter
              context.go(RouteNames.home);
            }
          },
          error: (error, stack) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(ErrorHandler.getErrorMessage(error)),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
        );
      });
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid OTP code. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    if (mounted) {
      setState(() {
        _isVerifying = false;
      });
    }
  }

  Future<void> _handleResendOtp() async {
    final otpSent = await ref
        .read(authNotifierProvider.notifier)
        .sendOtp(widget.email);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            otpSent
                ? 'OTP code sent successfully'
                : 'Failed to send OTP. Please try again.',
          ),
          backgroundColor: otpSent ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'images/verify.png',
                    height: 150,
                  ),
                  const SizedBox(height: 50.0),
                  const Text(
                    "Email Verification",
                    style: TextStyle(
                      fontSize: 38.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 26.0),
                  Text(
                    'Enter the code sent to your email\n${widget.email}',
                    style: const TextStyle(fontSize: 16.0),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30.0),
                  TextField(
                    controller: _otpController,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 5,
                    decoration: const InputDecoration(
                      focusColor: Colors.white,
                      border: OutlineInputBorder(),
                      labelText: 'Code',
                      hintText: 'Enter the code here',
                      counterText: '',
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextButton(
                    onPressed: _handleResendOtp,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  ElevatedButton(
                    onPressed: _isVerifying ? null : _handleVerify,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text(
                            "VERIFY & PROCEED",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.0,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

