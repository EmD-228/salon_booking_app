import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/salon.dart';
import '../../domain/repositories/salon_repository.dart';
import '../../domain/usecases/get_nearby_salons_usecase.dart';
import '../../domain/usecases/search_salons_usecase.dart';
import '../../domain/usecases/get_salon_details_usecase.dart';
import '../../data/providers/salon_data_providers.dart';

/// Provider pour le repository (interface)
final salonRepositoryInterfaceProvider = Provider<SalonRepository>((ref) {
  return ref.watch(salonRepositoryProvider);
});

/// Provider pour le usecase GetNearbySalons
final getNearbySalonsUsecaseProvider = Provider<GetNearbySalonsUsecase>((ref) {
  final repository = ref.watch(salonRepositoryInterfaceProvider);
  return GetNearbySalonsUsecase(repository);
});

/// Provider pour le usecase SearchSalons
final searchSalonsUsecaseProvider = Provider<SearchSalonsUsecase>((ref) {
  final repository = ref.watch(salonRepositoryInterfaceProvider);
  return SearchSalonsUsecase(repository);
});

/// Provider pour le usecase GetSalonDetails
final getSalonDetailsUsecaseProvider = Provider<GetSalonDetailsUsecase>((ref) {
  final repository = ref.watch(salonRepositoryInterfaceProvider);
  return GetSalonDetailsUsecase(repository);
});

/// Notifier pour gérer l'état des salons à proximité
class NearbySalonsNotifier extends Notifier<AsyncValue<List<Salon>>> {
  @override
  AsyncValue<List<Salon>> build() {
    loadSalons();
    return const AsyncValue.loading();
  }

  Future<void> loadSalons() async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getNearbySalonsUsecaseProvider);
      final salons = await usecase();
      state = AsyncValue.data(salons);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> refresh() async {
    await loadSalons();
  }
}

/// Provider pour le notifier des salons à proximité
final nearbySalonsNotifierProvider =
    NotifierProvider<NearbySalonsNotifier, AsyncValue<List<Salon>>>(() {
  return NearbySalonsNotifier();
});

/// Notifier pour gérer l'état de la recherche de salons
class SearchSalonsNotifier extends Notifier<AsyncValue<List<Salon>>> {
  @override
  AsyncValue<List<Salon>> build() {
    return const AsyncValue.data([]);
  }

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(searchSalonsUsecaseProvider);
      final salons = await usecase(query);
      state = AsyncValue.data(salons);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data([]);
  }
}

/// Provider pour le notifier de recherche de salons
final searchSalonsNotifierProvider =
    NotifierProvider<SearchSalonsNotifier, AsyncValue<List<Salon>>>(() {
  return SearchSalonsNotifier();
});

/// Notifier pour gérer l'état des détails d'un salon
class SalonDetailsNotifier extends Notifier<AsyncValue<Salon?>> {
  @override
  AsyncValue<Salon?> build() {
    return const AsyncValue.data(null);
  }

  Future<void> loadSalonDetails(int salonId) async {
    state = const AsyncValue.loading();
    try {
      final usecase = ref.read(getSalonDetailsUsecaseProvider);
      final salon = await usecase(salonId);
      state = AsyncValue.data(salon);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void clear() {
    state = const AsyncValue.data(null);
  }
}

/// Provider pour le notifier des détails d'un salon
final salonDetailsNotifierProvider =
    NotifierProvider<SalonDetailsNotifier, AsyncValue<Salon?>>(() {
  return SalonDetailsNotifier();
});

