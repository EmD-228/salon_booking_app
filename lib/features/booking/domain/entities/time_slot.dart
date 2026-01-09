import 'package:equatable/equatable.dart';

/// Entité TimeSlot représentant un créneau horaire disponible
class TimeSlot extends Equatable {
  final String startTime;
  final String endTime;
  final bool isAvailable;

  const TimeSlot({
    required this.startTime,
    required this.endTime,
    this.isAvailable = true,
  });

  @override
  List<Object> get props => [startTime, endTime, isAvailable];

  @override
  String toString() => 'TimeSlot($startTime - $endTime, available: $isAvailable)';
}

