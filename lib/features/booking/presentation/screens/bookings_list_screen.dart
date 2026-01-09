import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/booking_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

/// Écran affichant la liste des réservations de l'utilisateur
class BookingsListScreen extends ConsumerStatefulWidget {
  const BookingsListScreen({super.key});

  @override
  ConsumerState<BookingsListScreen> createState() => _BookingsListScreenState();
}

class _BookingsListScreenState extends ConsumerState<BookingsListScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les réservations au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
  }

  Future<void> _loadBookings() async {
    final authState = ref.read(authNotifierProvider);
    final user = authState.value;
    if (user != null) {
      await ref.read(bookingsNotifierProvider.notifier).loadBookings(user.email);
    }
  }

  Future<void> _callSalon(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '+91$phoneNumber',
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cannot make phone call'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingsAsync = ref.watch(bookingsNotifierProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text(
            'Your Bookings',
            style: GoogleFonts.ubuntu(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: bookingsAsync.when(
          data: (bookings) {
            if (bookings.isEmpty) {
              return Center(
                child: Text(
                  'No bookings found',
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
              );
            }
            return ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(10, 12, 10, 0),
                  child: Material(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              booking.timeSlot,
                              style: GoogleFonts.ubuntu(fontSize: 18),
                            ),
                            _BookingInfoRow(
                              icon: Icons.store,
                              text: booking.salonName,
                            ),
                            _BookingInfoRow(
                              icon: Icons.accessibility_new_sharp,
                              text: booking.serviceType,
                            ),
                            _BookingInfoRow(
                              icon: Icons.directions,
                              text: booking.salonAddress,
                            ),
                            _BookingInfoRow(
                              icon: Icons.email,
                              text: booking.salonEmail,
                            ),
                            _BookingInfoRow(
                              icon: Icons.phone,
                              text: booking.salonPhone,
                            ),
                            MaterialButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () => _callSalon(booking.salonPhone),
                              color: const Color.fromARGB(255, 100, 183, 251),
                              child: const Padding(
                                padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                                child: Icon(
                                  Icons.call,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error loading bookings',
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _loadBookings,
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget pour afficher une ligne d'information de réservation
class _BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _BookingInfoRow({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon),
        const SizedBox(width: 8),
        Flexible(child: Text(text)),
      ],
    );
  }
}

