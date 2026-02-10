import 'package:flutter/material.dart';

enum BookingStatus { pending, confirmed, completed, cancelled }

class Booking {
  final String id;
  final String serviceId;
  final String providerId; // Owner of the service being booked
  final String serviceTitle;
  final String travelerId;
  final String travelerName;
  final DateTime date; // Booking creation date or primary date
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final int rooms;
  final double totalPrice;
  final String contactPhone;
  final String contactEmail;
  final String? specialRequests;
  BookingStatus status;
  BookingPaymentStatus paymentStatus;

  Booking({
    required this.id,
    required this.serviceId,
    required this.providerId,
    required this.serviceTitle,
    required this.travelerId,
    required this.travelerName,
    required this.date,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.rooms,
    required this.totalPrice,
    required this.contactPhone,
    required this.contactEmail,
    this.specialRequests,
    required this.status,
    this.paymentStatus = BookingPaymentStatus.pending,
  });

  Color get statusColor {
    switch (status) {
      case BookingStatus.confirmed:
        return const Color(0xFF27AE60); // Success
      case BookingStatus.completed:
        return const Color(0xFF2F80ED); // Info
      case BookingStatus.cancelled:
        return const Color(0xFFEB5757); // Error
      case BookingStatus.pending:
        return const Color(0xFFF2C94C); // Warning
    }
  }

  String get statusLabel =>
      status.name[0].toUpperCase() + status.name.substring(1);
}

enum BookingPaymentStatus { pending, paid, failed }
