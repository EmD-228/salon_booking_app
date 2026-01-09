import '../../domain/entities/salon.dart';

/// Modèle de données pour un Salon
/// 
/// Extend l'entité Salon et ajoute la sérialisation JSON
class SalonModel extends Salon {
  const SalonModel({
    required super.id,
    required super.name,
    required super.address,
    required super.searchAddress,
    required super.phoneNumber,
    required super.imageName,
  });

  /// Factory constructor pour créer un SalonModel depuis un Map JSON
  factory SalonModel.fromJson(Map<String, dynamic> json) {
    return SalonModel(
      id: int.parse(json['salonid'] as String? ?? '0'),
      name: json['Name'] as String? ?? '',
      address: json['address'] as String? ?? '',
      searchAddress: json['search_address'] as String? ?? '',
      phoneNumber: json['number'] as String? ?? '',
      imageName: json['image_name'] as String? ?? '',
    );
  }

  /// Convertit le SalonModel en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'salonid': id.toString(),
      'Name': name,
      'address': address,
      'search_address': searchAddress,
      'number': phoneNumber,
      'image_name': imageName,
    };
  }

  /// Convertit le SalonModel en entité Salon
  Salon toEntity() => Salon(
        id: id,
        name: name,
        address: address,
        searchAddress: searchAddress,
        phoneNumber: phoneNumber,
        imageName: imageName,
      );
}

