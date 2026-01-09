import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.g.dart';

/// Modèle User - Représentation avec sérialisation JSON
@JsonSerializable()
class UserModel extends User {
  const UserModel({
    required super.email,
    required super.name,
    super.phoneNumber,
    super.profilePicture,
    super.id,
  });

  /// Crée un UserModel depuis un JSON
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Convertit un UserModel en JSON
  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  /// Convertit un UserModel en entité User
  User toEntity() {
    return User(
      email: email,
      name: name,
      phoneNumber: phoneNumber,
      profilePicture: profilePicture,
      id: id,
    );
  }

  /// Crée un UserModel depuis une entité User
  factory UserModel.fromEntity(User user) {
    return UserModel(
      email: user.email,
      name: user.name,
      phoneNumber: user.phoneNumber,
      profilePicture: user.profilePicture,
      id: user.id,
    );
  }
}

