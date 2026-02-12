import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/chat_message_model.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';
import 'auth_service.dart';
import 'booking_repository.dart';

class ChatRepository extends StateNotifier<List<ChatMessage>> {
  ChatRepository() : super(MockData().chatMessages);

  /// Send a new message from the current user
  void sendMessage({
    required String bookingId,
    required String messageText,
    required User currentUser,
    bool isInternalNote = false,
  }) {
    final messageId = const Uuid().v4();

    ChatMessage newMessage;

    if (currentUser.role == UserRole.traveler) {
      // Traveler messages are always visible to traveler
      newMessage = ChatMessage.fromTraveler(
        id: messageId,
        bookingId: bookingId,
        travelerId: currentUser.id,
        messageText: messageText,
      );
    } else if (currentUser.role == UserRole.provider) {
      // Provider messages are visible to traveler unless marked as internal note
      newMessage = ChatMessage.fromProvider(
        id: messageId,
        bookingId: bookingId,
        providerId: currentUser.providerId ?? currentUser.id,
        messageText: messageText,
        isInternalNote: isInternalNote,
      );
    } else {
      // Admin messages (treated as provider messages for now)
      newMessage = ChatMessage(
        id: messageId,
        bookingId: bookingId,
        senderId: currentUser.id,
        senderRole: currentUser.role,
        messageText: messageText,
        timestamp: DateTime.now(),
        visibleToTraveler: false,
        isInternalNote: isInternalNote,
      );
    }

    state = [...state, newMessage];
  }

  /// Get all messages for a specific booking
  List<ChatMessage> getMessagesForBooking(String bookingId) {
    return state.where((msg) => msg.bookingId == bookingId).toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  /// Delete a message (if needed for moderation)
  void deleteMessage(String messageId) {
    state = state.where((msg) => msg.id != messageId).toList();
  }

  /// Update a message (if editing is allowed)
  void updateMessage(String messageId, String newText) {
    state = [
      for (final msg in state)
        if (msg.id == messageId) msg.copyWith(messageText: newText) else msg,
    ];
  }
}

/// Main chat provider
final chatProvider = StateNotifierProvider<ChatRepository, List<ChatMessage>>((
  ref,
) {
  return ChatRepository();
});

/// Filtered chat messages provider based on user role and booking
/// This is the SECURITY ENFORCEMENT LAYER
final filteredChatMessagesProvider = Provider.family<List<ChatMessage>, String>((
  ref,
  bookingId,
) {
  final user = ref.watch(authProvider);
  final allMessages = ref.watch(chatProvider);
  final bookings = ref.watch(bookingProvider);

  if (user == null) return [];

  // Get all messages for this booking
  final bookingMessages =
      allMessages.where((msg) => msg.bookingId == bookingId).toList()
        ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

  // Find the booking to verify access
  final booking = bookings.firstWhere(
    (b) => b.id == bookingId,
    orElse: () => throw Exception('Booking not found'),
  );

  // Access Control Logic:
  // Check if the user is the traveler OR the provider for this specific booking.
  // This allows a "Provider" user to still act as a "Traveler" on other bookings.

  final isTravelerOfBooking = booking.travelerId == user.id;
  final isProviderOfBooking =
      booking.providerId == (user.providerId ?? user.id);
  final isAdmin = user.role == UserRole.admin;

  if (isAdmin) {
    return bookingMessages;
  }

  if (isProviderOfBooking) {
    // Provider view: sees everything
    return bookingMessages;
  }

  if (isTravelerOfBooking) {
    // Traveler view: sees only messages visible to traveler
    // (Provider replies + their own messages)
    return bookingMessages
        .where((msg) => msg.visibleToTraveler == true)
        .toList();
  }

  // If neither, access denied
  throw Exception('403 Forbidden: Access denied to this chat');
});

/// Helper provider to check if user has chat access to a booking
final hasChatAccessProvider = Provider.family<bool, String>((ref, bookingId) {
  final user = ref.watch(authProvider);
  final bookings = ref.watch(bookingProvider);

  if (user == null) return false;

  try {
    final booking = bookings.firstWhere(
      (b) => b.id == bookingId,
      orElse: () => throw Exception('Booking not found'),
    );

    if (user.role == UserRole.admin) return true;

    final isTravelerOfBooking = booking.travelerId == user.id;
    final isProviderOfBooking =
        booking.providerId == (user.providerId ?? user.id);

    return isTravelerOfBooking || isProviderOfBooking;
  } catch (e) {
    return false;
  }
});
