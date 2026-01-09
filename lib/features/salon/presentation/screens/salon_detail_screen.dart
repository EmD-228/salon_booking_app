import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/salon_providers.dart';
import '../../../../core/constants/app_colors.dart';

/// Écran affichant les détails d'un salon spécifique
class SalonDetailScreen extends ConsumerStatefulWidget {
  final int salonId;

  const SalonDetailScreen({
    super.key,
    required this.salonId,
  });

  @override
  ConsumerState<SalonDetailScreen> createState() => _SalonDetailScreenState();
}

class _SalonDetailScreenState extends ConsumerState<SalonDetailScreen> {
  String? selectedService;

  @override
  void initState() {
    super.initState();
    // Charger les détails du salon
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(salonDetailsNotifierProvider.notifier).loadSalonDetails(widget.salonId);
    });
  }

  Future<void> _showServiceSelection(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    elevation: 5.0,
                    color: const Color.fromARGB(255, 225, 234, 237),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'images/haircut.png',
                          height: 95.0,
                          width: 95.0,
                        ),
                        Text(
                          'Haircut',
                          style: GoogleFonts.ubuntu(fontSize: 24.0),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        selectedService = 'Haircut';
                      });
                      Navigator.pop(context);
                      // TODO: Naviguer vers l'écran de sélection de créneaux horaires
                      // context.push(RouteNames.timeSlotPath(widget.salonId));
                    },
                  ),
                  MaterialButton(
                    elevation: 5.0,
                    color: const Color.fromARGB(255, 225, 234, 237),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Image.asset('images/beard.png'),
                        Text(
                          'Beard',
                          style: GoogleFonts.ubuntu(fontSize: 24.0),
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        selectedService = 'Beard';
                      });
                      Navigator.pop(context);
                      // TODO: Naviguer vers l'écran de sélection de créneaux horaires
                      // context.push(RouteNames.timeSlotPath(widget.salonId));
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: MaterialButton(
                  elevation: 5.0,
                  color: const Color.fromARGB(255, 225, 234, 237),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'images/haircut.png',
                            height: 120.0,
                            width: 120.0,
                          ),
                          const Text(
                            '+',
                            style: TextStyle(fontSize: 70.0),
                          ),
                          Image.asset('images/beard.png'),
                        ],
                      ),
                      Text(
                        'Haircut   &   Beard',
                        style: GoogleFonts.ubuntu(fontSize: 24.0),
                      ),
                    ],
                  ),
                  onPressed: () {
                    setState(() {
                      selectedService = 'Haircut & Beard';
                    });
                    Navigator.pop(context);
                    // TODO: Naviguer vers l'écran de sélection de créneaux horaires
                    // context.push(RouteNames.timeSlotPath(widget.salonId));
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final salonAsync = ref.watch(salonDetailsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: salonAsync.when(
        data: (salon) {
          if (salon == null) {
            return const Center(
              child: Text('Salon not found'),
            );
          }

          return SafeArea(
            child: Column(
              children: [
                Material(
                  elevation: 2.0,
                  child: Container(
                    width: double.infinity,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: NetworkImage(salon.imageUrl),
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.image_not_supported,
                          size: 200,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 6.0, left: 6.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(85.0, 8.0, 85.0, 0.0),
                            child: Divider(
                              color: Colors.black,
                              thickness: 5,
                            ),
                          ),
                          const SizedBox(height: 24.0),
                          Text(
                            salon.name,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              fontSize: 35.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            salon.address,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12.0),
                          Text(
                            salon.phoneNumber,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.ubuntu(fontSize: 18.0),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5.0,
                                color: AppColors.primary,
                                onPressed: () {
                                  context.pop();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Back',
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 45.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                elevation: 5.0,
                                color: AppColors.primary,
                                onPressed: () {
                                  _showServiceSelection(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Book',
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 45.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                'Error loading salon details',
                style: GoogleFonts.ubuntu(fontSize: 18),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.read(salonDetailsNotifierProvider.notifier).loadSalonDetails(widget.salonId);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

