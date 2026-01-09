import 'package:equatable/equatable.dart';

/// Entité Salon représentant un salon de coiffure
/// 
/// Cette entité est pure et ne contient aucune logique de mapping
/// Elle représente le concept métier d'un salon
class Salon extends Equatable {
  final int id;
  final String name;
  final String address;
  final String searchAddress;
  final String phoneNumber;
  final String imageName;

  const Salon({
    required this.id,
    required this.name,
    required this.address,
    required this.searchAddress,
    required this.phoneNumber,
    required this.imageName,
  });

  /// URL complète de l'image du salon
  String get imageUrl => 'https://salonappmysql.000webhostapp.com/salon_image/$imageName';

  @override
  List<Object> get props => [
        id,
        name,
        address,
        searchAddress,
        phoneNumber,
        imageName,
      ];

  @override
  String toString() => 'Salon(id: $id, name: $name, address: $address)';
}

