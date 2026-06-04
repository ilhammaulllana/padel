import 'package:flutter/material.dart';

enum BookingStatus {
  pending,
  confirmed,
  completed,
  cancelled
}

extension BookingStatusExtension on BookingStatus {
  String get name {
    switch (this) {
      case BookingStatus.pending:
        return 'Pending';
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case BookingStatus.pending:
        return Colors.orangeAccent;
      case BookingStatus.confirmed:
        return Colors.blueAccent;
      case BookingStatus.completed:
        return Colors.greenAccent;
      case BookingStatus.cancelled:
        return Colors.redAccent;
    }
  }
}

class Booking {
  final String id;
  final String venueId;
  final String venueName;
  final String courtName;
  final String customerName;
  final String customerPhone;
  final DateTime bookingDate;
  final String timeSlot; // e.g. "08:00 - 09:00"
  BookingStatus status;

  Booking({
    required this.id,
    required this.venueId,
    required this.venueName,
    required this.courtName,
    required this.customerName,
    required this.customerPhone,
    required this.bookingDate,
    required this.timeSlot,
    this.status = BookingStatus.pending,
  });

  Booking copyWith({
    String? id,
    String? venueId,
    String? venueName,
    String? courtName,
    String? customerName,
    String? customerPhone,
    DateTime? bookingDate,
    String? timeSlot,
    BookingStatus? status,
  }) {
    return Booking(
      id: id ?? this.id,
      venueId: venueId ?? this.venueId,
      venueName: venueName ?? this.venueName,
      courtName: courtName ?? this.courtName,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      bookingDate: bookingDate ?? this.bookingDate,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
    );
  }
}
