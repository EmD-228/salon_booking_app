import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_providers.dart';

/// Écran de changement de mot de passe
class ChangePasswordScreen extends ConsumerStatefulWidget {
  final String email;

  const ChangePasswordScreen({
    super.key,
    required this.email,
  });

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Pour le changement de mot de passe après forgot password,
      // on n'a pas besoin de l'ancien mot de passe
      // L'API actuelle utilise seulement email et nouveau password
      // TODO: Adapter selon l'API réelle
      final success = await ref
          .read(authNotifierProvider.notifier)
          .changePassword(
            email: widget.email,
            oldPassword: '', // Pas nécessaire pour forgot password
            newPassword: _newPasswordController.text,
          );

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Password changed successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Naviguer vers Home - sera géré par GoRouter
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to change password. Please try again.'),
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
          'Change Password',
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
              const SizedBox(height: 30),
              Image.asset(
                'images/key.png',
                height: 200,
              ),
              Text(
                'Enter your New Password',
                style: GoogleFonts.ubuntu(fontSize: 28),
              ),
              const SizedBox(height: 30.0),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Material(
                  elevation: 1.0,
                  child: TextFormField(
                    controller: _newPasswordController,
                    style: GoogleFonts.ubuntu(fontSize: 20),
                    textAlign: TextAlign.center,
                    obscureText: _obscureNewPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      label: const Text('New Password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureNewPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureNewPassword = !_obscureNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your new password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Material(
                  elevation: 1.0,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    style: GoogleFonts.ubuntu(fontSize: 20),
                    textAlign: TextAlign.center,
                    obscureText: _obscureConfirmPassword,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          width: 3,
                          color: Colors.white,
                        ),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      label: const Text('Confirm Password'),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _newPasswordController.text) {
                        return 'Passwords do not match';
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
                onPressed: _isLoading ? null : _handleChangePassword,
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
                          'Change',
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

