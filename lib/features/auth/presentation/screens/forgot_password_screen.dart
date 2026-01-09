import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';
import '../../../../routes/route_names.dart';

/// Écran de récupération de mot de passe
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final success = await ref
          .read(authNotifierProvider.notifier)
          .forgotPassword(_emailController.text.trim());

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          // Naviguer vers l'écran de changement de mot de passe avec GoRouter
          context.push(
            RouteNames.changePassword,
            extra: _emailController.text.trim(),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No such email found. Try to Sign up first.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFc6ece6),
        title: Text(
          'Forget Password',
          style: GoogleFonts.ubuntu(
            fontSize: 32.0,
            fontWeight: FontWeight.bold,
            shadows: const [
              Shadow(
                offset: Offset(-1.0, -1.0),
                color: Color.fromARGB(255, 196, 196, 196),
              ),
              Shadow(
                offset: Offset(1.0, -1.0),
                color: Color.fromARGB(255, 196, 196, 196),
              ),
              Shadow(
                offset: Offset(1.0, 1.0),
                color: Color.fromARGB(255, 196, 196, 196),
              ),
              Shadow(
                offset: Offset(-1.0, 1.0),
                color: Color.fromARGB(255, 196, 196, 196),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset(
                'images/lock.png',
                height: 200,
              ),
              const SizedBox(height: 30.0),
              Text(
                'Enter your email here',
                style: GoogleFonts.ubuntu(fontSize: 28),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Material(
                  elevation: 1.0,
                  child: TextFormField(
                    controller: _emailController,
                    style: GoogleFonts.ubuntu(fontSize: 20),
                    keyboardType: TextInputType.emailAddress,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(width: 5),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      label: const Text('email'),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60.0),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(
                    width: 2.5,
                    color: Color.fromARGB(255, 57, 255, 225),
                  ),
                ),
                onPressed: _isLoading ? null : _handleSubmit,
                child: _isLoading
                    ? const Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 28.0,
                            color: Color.fromARGB(255, 57, 255, 225),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

