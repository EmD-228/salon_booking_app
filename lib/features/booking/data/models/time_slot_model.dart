import '../../domain/entities/time_slot.dart';

/// Modèle de données pour un TimeSlot
class TimeSlotModel extends TimeSlot {
  const TimeSlotModel({
    required super.startTime,
    required super.endTime,
    super.isAvailable,
  });

  /// Factory constructor pour créer un TimeSlotModel depuis un Map JSON
  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: json['time_slot_start'] as String? ?? '',
      endTime: json['time_slot_end'] as String? ?? '',
      isAvailable: json['is_available'] as bool? ?? true,
    );
  }

  /// Convertit le TimeSlotModel en Map JSON
  Map<String, dynamic> toJson() {
    return {
      'time_slot_start': startTime,
      'time_slot_end': endTime,
      'is_available': isAvailable,
    };
  }

  /// Convertit le TimeSlotModel en entité TimeSlot
  TimeSlot toEntity() => TimeSlot(
        startTime: startTime,
        endTime: endTime,
        isAvailable: isAvailable,
      );
}

