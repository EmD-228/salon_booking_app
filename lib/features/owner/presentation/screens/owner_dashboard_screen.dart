import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/owner_providers.dart';
import '../../../../core/constants/api_endpoints.dart';
import '../../../../routes/route_names.dart';

/// Écran du dashboard du propriétaire affichant les réservations du jour
class OwnerDashboardScreen extends ConsumerStatefulWidget {
  const OwnerDashboardScreen({super.key});

  @override
  ConsumerState<OwnerDashboardScreen> createState() => _OwnerDashboardScreenState();
}

class _OwnerDashboardScreenState extends ConsumerState<OwnerDashboardScreen> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Charger les réservations au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBookings();
    });
    // Rafraîchir automatiquement toutes les 10 minutes
    _refreshTimer = Timer.periodic(const Duration(minutes: 10), (_) {
      _loadBookings();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadBookings() async {
    final ownerState = ref.read(ownerNotifierProvider);
    final owner = ownerState.value;
    if (owner != null) {
      await ref.read(todayBookingsNotifierProvider.notifier).loadTodayBookings(owner.id);
    }
  }

  /// Vérifie si un créneau horaire est disponible (pas encore passé)
  bool _isTimeSlotAvailable(String timeSlot) {
    try {
      final timeFormat = timeSlot.substring(timeSlot.length - 2);
      final timeParts = timeSlot.substring(0, 8).split(':');
      
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      if (timeFormat == 'PM' && hour != 12) {
        hour += 12;
      } else if (timeFormat == 'AM' && hour == 12) {
        hour = 0;
      }
      
      final now = DateTime.now();
      final slotTime = DateTime(now.year, now.month, now.day, hour, minute);
      
      return slotTime.isAfter(now);
    } catch (e) {
      return true;
    }
  }

  Future<void> _callCustomer(String phoneNumber) async {
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

  void _logout() {
    ref.read(ownerNotifierProvider.notifier).logout();
    if (mounted) {
      context.go(RouteNames.ownerLogin);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ownerAsync = ref.watch(ownerNotifierProvider);
    final bookingsAsync = ref.watch(todayBookingsNotifierProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 199, 230, 255),
        body: ownerAsync.when(
          data: (owner) {
            if (owner == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No owner logged in'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => context.go(RouteNames.ownerLogin),
                      child: const Text('Go to Login'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  snap: false,
                  pinned: true,
                  floating: false,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      owner.name,
                      style: GoogleFonts.ubuntu(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 26.0,
                      ),
                    ),
                    background: owner.imageName != null && owner.imageName!.isNotEmpty
                        ? Image.network(
                            ApiEndpoints.imagesBaseUrl + owner.imageName!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.blue,
                                child: const Icon(Icons.store, size: 100, color: Colors.white),
                              );
                            },
                          )
                        : Container(
                            color: Colors.blue,
                            child: const Icon(Icons.store, size: 100, color: Colors.white),
                          ),
                  ),
                  expandedHeight: 230,
                  backgroundColor: Colors.blue,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return bookingsAsync.when(
                        data: (bookings) {
                          if (bookings.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Center(
                                child: Text('No bookings for today'),
                              ),
                            );
                          }
                          if (index >= bookings.length) {
                            return null;
                          }
                          final booking = bookings[index];
                          final isAvailable = _isTimeSlotAvailable(booking.startTime);

                          return Padding(
                            padding: const EdgeInsets.fromLTRB(10, 12, 12, 0),
                            child: Material(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              elevation: 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: isAvailable
                                        ? [
                                            const Color.fromARGB(255, 68, 171, 255),
                                            const Color.fromARGB(255, 46, 161, 255),
                                          ]
                                        : [
                                            const Color.fromARGB(255, 195, 206, 215),
                                            const Color.fromARGB(255, 162, 168, 173),
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        booking.timeSlot,
                                        style: GoogleFonts.ubuntu(fontSize: 22),
                                      ),
                                      const SizedBox(height: 4),
                                      _BookingInfoRow(
                                        icon: Icons.face,
                                        text: booking.customerEmail,
                                      ),
                                      _BookingInfoRow(
                                        icon: Icons.accessibility_new_sharp,
                                        text: booking.serviceType,
                                      ),
                                      _BookingInfoRow(
                                        icon: Icons.phone,
                                        text: booking.salonPhone,
                                      ),
                                      if (isAvailable) ...[
                                        const SizedBox(height: 8),
                                        MaterialButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(24),
                                          ),
                                          onPressed: () => _callCustomer(booking.salonPhone),
                                          color: const Color.fromARGB(255, 60, 190, 255),
                                          child: const Padding(
                                            padding: EdgeInsets.fromLTRB(90, 2, 90, 2),
                                            child: Icon(
                                              Icons.call,
                                              color: Colors.white,
                                              size: 40,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, stack) => Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(
                            child: Column(
                              children: [
                                Text('Error loading bookings: ${error.toString()}'),
                                const SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _loadBookings,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: bookingsAsync.when(
                      data: (bookings) => bookings.length,
                      loading: () => 1,
                      error: (_, __) => 1,
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: ${error.toString()}'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.go(RouteNames.ownerLogin),
                  child: const Text('Go to Login'),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromARGB(255, 93, 172, 250),
          onPressed: _loadBookings,
          label: Text(
            'Refresh',
            style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
          ),
          icon: const Icon(Icons.refresh),
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
        Icon(
          icon,
          color: const Color.fromARGB(255, 207, 233, 255),
          size: 30,
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}

