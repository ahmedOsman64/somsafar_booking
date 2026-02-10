import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/booking_repository.dart';
import '../../shared/models/booking_model.dart';
import 'chat_screen.dart';

class TravelerBookingsScreen extends ConsumerWidget {
  const TravelerBookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookings = ref.watch(filteredBookingsProvider);
    if (bookings.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Bookings')),
        body: const Center(child: Text('No bookings yet')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('My Bookings')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: booking.statusColor.withAlpha(
                            (0.1 * 255).round(),
                          ),
                          borderRadius: BorderRadius.circular(8),
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
                        "${booking.date.day}/${booking.date.month}/${booking.date.year}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    booking.serviceTitle,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
                  if (booking.status == BookingStatus.confirmed) ...[
                    const Text(
                      'Your booking is confirmed! Pack your bags.',
                      style: TextStyle(color: AppColors.success),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                bookingId: booking.id,
                                chatTitle:
                                    'Provider', // In real app, fetch provider name
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.chat_bubble_outline),
                        label: const Text('Chat with Provider'),
                      ),
                    ),
                  ],
                  if (booking.status == BookingStatus.pending)
                    const Text(
                      'Waiting for provider approval.',
                      style: TextStyle(color: AppColors.warning),
                    ),
                  if (booking.status == BookingStatus.cancelled)
                    const Text(
                      'This booking was cancelled.',
                      style: TextStyle(color: AppColors.error),
                    ),
                  if (booking.status == BookingStatus.completed)
                    const Text(
                      'We hope you enjoyed your stay!',
                      style: TextStyle(color: AppColors.primary),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
