import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../routes/route_names.dart';

/// Écran de sélection du type d'utilisateur (Customer ou Salon Owner)
class UserTypeSelectionScreen extends ConsumerWidget {
  const UserTypeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        final shouldPop = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Do you want to Exit?'),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                  child: const Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('No'),
                ),
              ],
            );
          },
        );
        return shouldPop ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          body: Center(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/choose.png'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 1,
                    color: Colors.transparent,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(RouteNames.login);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(35, 10, 35, 10),
                        child: Text(
                          'Customer',
                          style: GoogleFonts.ubuntu(
                            fontSize: 43,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        side: const BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 1,
                    color: Colors.transparent,
                    child: OutlinedButton(
                      onPressed: () {
                        context.push(RouteNames.ownerLogin);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          'Salon Owner',
                          style: GoogleFonts.ubuntu(
                            fontSize: 43,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        side: const BorderSide(color: Colors.white, width: 4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

