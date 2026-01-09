import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/booking_providers.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../routes/route_names.dart';

/// Écran affichant les créneaux horaires disponibles pour un salon
class TimeSlotScreen extends ConsumerStatefulWidget {
  final int salonId;
  final String serviceType;

  const TimeSlotScreen({
    super.key,
    required this.salonId,
    required this.serviceType,
  });

  @override
  ConsumerState<TimeSlotScreen> createState() => _TimeSlotScreenState();
}

class _TimeSlotScreenState extends ConsumerState<TimeSlotScreen> {
  @override
  void initState() {
    super.initState();
    // Charger les créneaux horaires au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(timeSlotsNotifierProvider.notifier).loadTimeSlots(widget.salonId);
    });
  }

  /// Vérifie si un créneau horaire est disponible (pas encore passé)
  bool _isTimeSlotAvailable(String timeSlot) {
    try {
      // Extraire l'heure du créneau (format: "HH:MM:SS AM/PM")
      final timeFormat = timeSlot.substring(timeSlot.length - 2);
      final timeParts = timeSlot.substring(0, 8).split(':');
      
      int hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      
      // Convertir en 24h
      if (timeFormat == 'PM' && hour != 12) {
        hour += 12;
      } else if (timeFormat == 'AM' && hour == 12) {
        hour = 0;
      }
      
      final now = DateTime.now();
      final slotTime = DateTime(now.year, now.month, now.day, hour, minute);
      
      // Le créneau est disponible s'il est dans le futur
      return slotTime.isAfter(now);
    } catch (e) {
      // En cas d'erreur de parsing, considérer comme disponible
      return true;
    }
  }

  Future<void> _createBooking(String timeSlot) async {
    final authState = ref.read(authNotifierProvider);
    final user = authState.value;
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please login to book'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Afficher un dialogue de chargement
    if (mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Booking Slot'),
          content: const LinearProgressIndicator(
            color: AppColors.primary,
          ),
        ),
      );
    }

    final success = await ref.read(createBookingNotifierProvider.notifier).createBooking(
          salonId: widget.salonId,
          customerEmail: user.email,
          serviceType: widget.serviceType,
          timeSlot: timeSlot,
        );

    if (mounted) {
      Navigator.pop(context); // Fermer le dialogue de chargement
      
      if (success) {
        // Naviguer vers l'écran de confirmation
        context.push(
          RouteNames.bookingConfirmation,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create booking'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeSlotsAsync = ref.watch(timeSlotsNotifierProvider);

    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: AppBar(
            flexibleSpace: Container(),
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            centerTitle: true,
            title: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                'Time Slots',
                style: GoogleFonts.ubuntu(
                  fontSize: 40.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            const SizedBox(height: 5),
            const SizedBox(height: 10),
            Expanded(
              child: timeSlotsAsync.when(
                data: (timeSlots) {
                  if (timeSlots.isEmpty) {
                    return Center(
                      child: Text(
                        'No time slots available',
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: timeSlots.length,
                    itemBuilder: (context, index) {
                      final timeSlot = timeSlots[index];
                      final isAvailable = _isTimeSlotAvailable(timeSlot.startTime);
                      
                      return GestureDetector(
                        onTap: isAvailable
                            ? () => _createBooking(timeSlot.startTime)
                            : null,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                          child: Material(
                            elevation: 5.0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: isAvailable
                                    ? AppColors.primary
                                    : const Color.fromARGB(255, 174, 190, 201),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10, bottom: 10),
                                child: Text(
                                  isAvailable
                                      ? '${timeSlot.startTime} - ${timeSlot.endTime}'
                                      : '${timeSlot.startTime} - ${timeSlot.endTime}\nNot Available',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.ubuntu(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                  ),
                                ),
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
                        'Error loading time slots',
                        style: GoogleFonts.ubuntu(fontSize: 18),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          ref.read(timeSlotsNotifierProvider.notifier).loadTimeSlots(widget.salonId);
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color.fromARGB(255, 252, 252, 252),
          onPressed: () {
            context.pop();
          },
          label: Text(
            'Back',
            style: GoogleFonts.ubuntu(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}

