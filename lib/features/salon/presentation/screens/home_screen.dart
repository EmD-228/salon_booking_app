import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/salon_providers.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../routes/route_names.dart';

/// Écran principal affichant la liste des salons à proximité
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salonsAsync = ref.watch(nearbySalonsNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 6.0, top: 8.0),
              child: GestureDetector(
                onTap: () {
                  context.push(RouteNames.profile);
                },
                child: const Icon(
                  Icons.account_circle_sharp,
                  size: 50.0,
                ),
              ),
            ),
          ],
          backgroundColor: AppColors.primary,
          title: Text(
            'Salon App',
            style: GoogleFonts.ubuntu(
              fontWeight: FontWeight.bold,
              fontSize: 35.0,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg2.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              // Barre de recherche
              GestureDetector(
                onTap: () {
                  showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(),
                  );
                },
                child: Material(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          Text(
                            'Search Location...',
                            style: GoogleFonts.ubuntu(fontSize: 20),
                          ),
                          const Spacer(),
                          Container(
                            height: double.infinity,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              color: AppColors.primary.withOpacity(0.8),
                            ),
                            child: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 40,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Liste des salons
              Expanded(
                child: salonsAsync.when(
                  data: (salons) {
                    if (salons.isEmpty) {
                      return Center(
                        child: Text(
                          'No salons found',
                          style: GoogleFonts.ubuntu(fontSize: 18),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: salons.length,
                      itemBuilder: (context, index) {
                        final salon = salons[index];
                        return GestureDetector(
                          onTap: () {
                            context.push(
                              RouteNames.salonDetailPath(salon.id),
                            );
                          },
                          child: Card(
                            shadowColor: const Color.fromARGB(255, 0, 2, 5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            color: AppColors.card,
                            elevation: 4.0,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Row(
                                children: [
                                  Container(
                                    height: 140,
                                    width: 180,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: Image(
                                        filterQuality: FilterQuality.high,
                                        fit: BoxFit.fill,
                                        image: NetworkImage(salon.imageUrl),
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.image_not_supported);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 30.0),
                                  Flexible(
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text: salon.name,
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: '\n\n${salon.address}',
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 15.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
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
                          'Error loading salons',
                          style: GoogleFonts.ubuntu(fontSize: 18),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            ref.read(nearbySalonsNotifierProvider.notifier).refresh();
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
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: () {
          ref.read(nearbySalonsNotifierProvider.notifier).refresh();
        },
        label: Text(
          'Refresh',
          style: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
        ),
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}

/// Delegate personnalisé pour la recherche de localisation
class CustomSearchDelegate extends SearchDelegate<String?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const SizedBox.shrink();
    }

    // Naviguer vers l'écran de recherche avec la requête
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.push('${RouteNames.searchLocation}?q=$query');
    });

    return const Center(child: CircularProgressIndicator());
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Pour l'instant, on retourne une liste vide
    // TODO: Implémenter les suggestions basées sur les salons chargés
    return const SizedBox.shrink();
  }
}

