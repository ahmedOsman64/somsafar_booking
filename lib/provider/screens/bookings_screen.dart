import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/booking_repository.dart';
import '../../shared/models/booking_model.dart';
import '../../traveler/screens/chat_screen.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';

class ProviderBookingsScreen extends ConsumerWidget {
  const ProviderBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(bookingProvider);
    final user = ref.watch(authProvider);
    final providerType = user?.providerType ?? ProviderType.hotel;

    String title = 'Booking Requests';
    switch (providerType) {
      case ProviderType.hotel:
        title = 'Room Bookings';
        break;
      case ProviderType.home:
        title = 'Home Bookings';
        break;
      case ProviderType.apartment:
        title = 'Apartment Bookings';
        break;
      case ProviderType.transport:
        title = 'Vehicle Rentals';
        break;
    }

    // Sort logic
    final sortedBookings = [...bookings];
    sortedBookings.sort((a, b) {
      // Pending first
      if (a.status == BookingStatus.pending &&
          b.status != BookingStatus.pending) {
        return -1;
      }
      if (a.status != BookingStatus.pending &&
          b.status == BookingStatus.pending) {
        return 1;
      }
      // Then date
      return a.date.compareTo(b.date);
    });

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: sortedBookings.isEmpty
          ? const Center(child: Text('No bookings yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedBookings.length,
              itemBuilder: (context, index) =>
                  _BookingCard(booking: sortedBookings[index], ref: ref),
            ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final WidgetRef ref;

  const _BookingCard({required this.booking, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Badge & Date
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: booking.statusColor.withAlpha(26),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: booking.statusColor.withAlpha(128),
                    ),
                  ),
                  child: Text(
                    booking.statusLabel,
                    style: TextStyle(
                      color: booking.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  "Booked: ${DateFormat('MMM dd').format(booking.date)}",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Service Title
            Text(
              booking.serviceTitle,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(height: 24),

            // Details Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.calendar_today,
                        'Dates',
                        '${DateFormat('MMM dd').format(booking.checkIn)} - ${DateFormat('MMM dd').format(booking.checkOut)}',
                      ),
                      const SizedBox(height: 12),
                      _buildDetailItem(
                        Icons.people,
                        'Guests',
                        '${booking.guests} Guests, ${booking.rooms} Rooms',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailItem(
                        Icons.person,
                        'Traveler',
                        booking.travelerName,
                      ),
                      const SizedBox(height: 12),
                      _buildDetailItem(
                        Icons.attach_money,
                        'Total Price',
                        '\$${booking.totalPrice.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),

            if (booking.specialRequests != null &&
                booking.specialRequests!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Note: ${booking.specialRequests}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 8),
            if (booking.contactPhone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      booking.contactPhone,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.email, size: 14, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      booking.contactEmail,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),
            _buildActions(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 10, color: Colors.grey[600]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActions(BuildContext context) {
    if (booking.status == BookingStatus.pending) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: () => _updateStatus(BookingStatus.cancelled),
            style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Reject'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () => _updateStatus(BookingStatus.confirmed),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text('Accept'),
          ),
        ],
      );
    } else if (booking.status == BookingStatus.confirmed) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(
                    bookingId: booking.id,
                    chatTitle: booking.travelerName,
                  ),
                ),
              );
            },
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text('Chat'),
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () => _updateStatus(BookingStatus.completed),
            child: const Text('Mark Completed'),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(BookingStatus status) {
    ref.read(bookingProvider.notifier).updateBookingStatus(booking.id, status);
  }
}
