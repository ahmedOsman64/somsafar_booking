import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';
import 'auth_service.dart';

class BookingRepository extends StateNotifier<List<Booking>> {
  BookingRepository() : super(MockData().bookings);

  void updateBookingStatus(String id, BookingStatus status) {
    state = [
      for (final b in state)
        if (b.id == id)
          Booking(
            id: b.id,
            serviceId: b.serviceId,
            providerId: b.providerId,
            serviceTitle: b.serviceTitle,
            travelerId: b.travelerId,
            travelerName: b.travelerName,
            date: b.date,
            checkIn: b.checkIn,
            checkOut: b.checkOut,
            guests: b.guests,
            rooms: b.rooms,
            totalPrice: b.totalPrice,
            contactPhone: b.contactPhone,
            contactEmail: b.contactEmail,
            specialRequests: b.specialRequests,
            status: status,
            paymentStatus: b.paymentStatus,
          )
        else
          b,
    ];
  }

  void createBooking(Booking booking) {
    state = [...state, booking];
  }

  List<Booking> get pendingBookings =>
      state.where((b) => b.status == BookingStatus.pending).toList();
}

final bookingProvider = StateNotifierProvider<BookingRepository, List<Booking>>(
  (ref) {
    return BookingRepository();
  },
);

// Selector for role-based data isolation
final filteredBookingsProvider = Provider<List<Booking>>((ref) {
  final user = ref.watch(authProvider);
  final bookings = ref.watch(bookingProvider);

  if (user == null) return [];

  switch (user.role) {
    case UserRole.traveler:
      // Traveler can only see their own bookings
      return bookings.where((b) => b.travelerId == user.id).toList();
    case UserRole.provider:
      // Provider can only see bookings for their services
      return bookings.where((b) => b.providerId == user.providerId).toList();
    case UserRole.admin:
      // Admins (Super, Ops, Finance) can see all bookings for management
      return bookings;
  }
});
