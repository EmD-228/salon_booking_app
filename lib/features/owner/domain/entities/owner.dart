import 'package:equatable/equatable.dart';
import '../../../booking/domain/entities/booking.dart';

/// Entité Owner représentant un propriétaire de salon
class Owner extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String? imageName;
  final String? address;

  const Owner({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.imageName,
    this.address,
  });

  @override
  List<Object?> get props => [id, name, email, phoneNumber, imageName, address];

  @override
  String toString() => 'Owner(id: $id, name: $name, email: $email)';
}

/// Entité représentant les réservations du jour pour un propriétaire
class TodayBookings extends Equatable {
  final List<Booking> bookings;

  const TodayBookings({required this.bookings});

  @override
  List<Object> get props => [bookings];

  @override
  String toString() => 'TodayBookings(count: ${bookings.length})';
}

