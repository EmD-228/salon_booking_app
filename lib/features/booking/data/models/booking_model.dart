import '../../domain/entities/booking.dart';

/// Modèle de données pour un Booking
class BookingModel extends Booking {
  const BookingModel({
    super.id,
    required super.salonId,
    required super.salonName,
    required super.salonAddress,
    required super.salonPhone,
    required super.salonEmail,
    required super.customerEmail,
    required super.serviceType,
    required super.startTime,
    required super.endTime,
    super.bookingDate,
  });

  /// Factory constructor pour créer un BookingModel depuis un Map JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] != null ? int.tryParse(json['id'].toString()) : null,
      salonId: json['salonid'] != null
          ? int.parse(json['salonid'].toString())
          : 0,
      salonName: json['Name'] as String? ?? '',
      salonAddress: json['address'] as String? ?? '',
      salonPhone: json['number'] as String? ?? '',
      salonEmail: json['email'] as String? ?? '',
      customerEmail: json['customer_email'] as String? ?? '',
      serviceType: json['type'] as String? ?? '',
      startTime: json['time_slot_start'] as String? ?? '',
      endTime: json['time_slot_end'] as String? ?? '',
      bookingDate: json['booking_date'] != null
          ? DateTime.tryParse(json['booking_date'].toString())
          : null,
    );
  }

  /// Convertit le BookingModel en Map JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'salonid': salonId,
      'Name': salonName,
      'address': salonAddress,
      'number': salonPhone,
      'email': salonEmail,
      'customer_email': customerEmail,
      'type': serviceType,
      'time_slot_start': startTime,
      'time_slot_end': endTime,
      if (bookingDate != null) 'booking_date': bookingDate!.toIso8601String(),
    };
  }

  /// Convertit le BookingModel en entité Booking
  Booking toEntity() => Booking(
        id: id,
        salonId: salonId,
        salonName: salonName,
        salonAddress: salonAddress,
        salonPhone: salonPhone,
        salonEmail: salonEmail,
        customerEmail: customerEmail,
        serviceType: serviceType,
        startTime: startTime,
        endTime: endTime,
        bookingDate: bookingDate,
      );
}

