import '../../domain/entities/owner.dart';

/// Modèle de données pour un Owner
class OwnerModel extends Owner {
  const OwnerModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    super.imageName,
    super.address,
  });

  /// Factory constructor pour créer un OwnerModel depuis un Map JSON
  factory OwnerModel.fromJson(Map<String, dynamic> json) {
    return OwnerModel(
      id: json['id']?.toString() ?? '',
      name: json['Name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phoneNumber: json['number'] as String? ?? '',
      imageName: json['image_name'] as String?,
      address: json['address'] as String?,
    );
  }

  /// Convertit le OwnerModel en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'email': email,
      'number': phoneNumber,
      if (imageName != null) 'image_name': imageName,
      if (address != null) 'address': address,
    };
  }

  /// Convertit le OwnerModel en entité Owner
  Owner toEntity() => Owner(
        id: id,
        name: name,
        email: email,
        phoneNumber: phoneNumber,
        imageName: imageName,
        address: address,
      );
}

