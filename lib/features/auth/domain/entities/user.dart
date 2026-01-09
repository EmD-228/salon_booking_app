import 'package:equatable/equatable.dart';

/// Entité User - Représentation pure du domaine
/// Ne contient aucune logique de sérialisation ou dépendance externe
class User extends Equatable {
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profilePicture;
  final String? id;

  const User({
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profilePicture,
    this.id,
  });

  @override
  List<Object?> get props => [email, name, phoneNumber, profilePicture, id];

  /// Crée un User avec des valeurs mises à jour
  User copyWith({
    String? email,
    String? name,
    String? phoneNumber,
    String? profilePicture,
    String? id,
  }) {
    return User(
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePicture: profilePicture ?? this.profilePicture,
      id: id ?? this.id,
    );
  }
}

