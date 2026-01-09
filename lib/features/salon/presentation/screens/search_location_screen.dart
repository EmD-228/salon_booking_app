import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/salon_providers.dart';
import '../../../../routes/route_names.dart';

/// Écran affichant les résultats de recherche de salons par localisation
class SearchLocationScreen extends ConsumerWidget {
  final String searchQuery;

  const SearchLocationScreen({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Déclencher la recherche au chargement
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(searchSalonsNotifierProvider.notifier).search(searchQuery);
    });

    final searchResults = ref.watch(searchSalonsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search: $searchQuery',
          style: GoogleFonts.ubuntu(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("images/bg2.gif"),
            fit: BoxFit.cover,
          ),
        ),
        child: searchResults.when(
          data: (salons) {
            if (salons.isEmpty) {
              return Center(
                child: Text(
                  'No salons found for "$searchQuery"',
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
                    color: const Color.fromARGB(255, 243, 242, 242),
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
                  'Error searching salons',
                  style: GoogleFonts.ubuntu(fontSize: 18),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    ref.read(searchSalonsNotifierProvider.notifier).search(searchQuery);
                  },
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

