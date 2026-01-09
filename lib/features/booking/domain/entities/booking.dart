import 'package:equatable/equatable.dart';

/// Entité Booking représentant une réservation
class Booking extends Equatable {
  final int? id;
  final int salonId;
  final String salonName;
  final String salonAddress;
  final String salonPhone;
  final String salonEmail;
  final String customerEmail;
  final String serviceType; // 'Haircut', 'Beard', 'Haircut & Beard'
  final String startTime;
  final String endTime;
  final DateTime? bookingDate;

  const Booking({
    this.id,
    required this.salonId,
    required this.salonName,
    required this.salonAddress,
    required this.salonPhone,
    required this.salonEmail,
    required this.customerEmail,
    required this.serviceType,
    required this.startTime,
    required this.endTime,
    this.bookingDate,
  });

  /// Format du créneau horaire pour l'affichage
  String get timeSlot => '$startTime - $endTime';

  @override
  List<Object?> get props => [
        id,
        salonId,
        salonName,
        salonAddress,
        salonPhone,
        salonEmail,
        customerEmail,
        serviceType,
        startTime,
        endTime,
        bookingDate,
      ];

  @override
  String toString() => 'Booking(id: $id, salon: $salonName, time: $timeSlot, type: $serviceType)';
}

