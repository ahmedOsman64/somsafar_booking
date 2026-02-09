import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../mock_data/mock_data.dart';

class BookingRepository extends StateNotifier<List<Booking>> {
  BookingRepository() : super(MockData().bookings);

  void updateBookingStatus(String id, BookingStatus status) {
    state = [
      for (final b in state)
        if (b.id == id)
          Booking(
            id: b.id,
            serviceId: b.serviceId,
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
