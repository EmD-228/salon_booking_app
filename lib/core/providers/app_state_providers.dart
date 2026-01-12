import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../constants/api_endpoints.dart';

/// Provider pour la date/heure actuelle formatée
final currentTimeProvider = Provider<String>((ref) {
  return DateFormat("HH:mm:ss").format(DateTime.now());
});

/// Notifier pour l'ID du salon sélectionné
class SelectedSalonIdNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  
  void setSalonId(int? id) {
    state = id;
  }
}

/// Provider pour l'ID du salon sélectionné
final selectedSalonIdProvider = NotifierProvider<SelectedSalonIdNotifier, int?>(() {
  return SelectedSalonIdNotifier();
});

/// Notifier pour le type de service sélectionné
class SelectedServiceTypeNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setServiceType(String? type) {
    state = type;
  }
}

/// Provider pour le type de service sélectionné (Haircut, Beard, etc.)
final selectedServiceTypeProvider = NotifierProvider<SelectedServiceTypeNotifier, String?>(() {
  return SelectedServiceTypeNotifier();
});

/// Notifier pour la position de la carte
class CardPositionNotifier extends Notifier<int?> {
  @override
  int? build() => null;
  
  void setPosition(int? position) {
    state = position;
  }
}

/// Provider pour la position de la carte (utilisé dans l'ancien code)
final cardPositionProvider = NotifierProvider<CardPositionNotifier, int?>(() {
  return CardPositionNotifier();
});

/// Notifier pour le nom du client
class CustomerNameNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  
  void setName(String? name) {
    state = name;
  }
}

/// Provider pour le nom du client
final customerNameProvider = NotifierProvider<CustomerNameNotifier, String?>(() {
  return CustomerNameNotifier();
});

/// Notifier pour l'état de chargement des créneaux horaires
class LoadingTimeSlotsNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  
  void setLoading(bool loading) {
    state = loading;
  }
}

/// Provider pour l'état de chargement des créneaux horaires
final loadingTimeSlotsProvider = NotifierProvider<LoadingTimeSlotsNotifier, bool>(() {
  return LoadingTimeSlotsNotifier();
});

/// Provider pour l'URL de base des images uploadées
final uploadedImagesBaseUrlProvider = Provider<String>((ref) {
  return ApiEndpoints.imagesBaseUrl;
});

