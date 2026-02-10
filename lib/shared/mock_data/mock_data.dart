import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';
import '../models/chat_message_model.dart';

class MockData {
  static final MockData _instance = MockData._internal();
  factory MockData() => _instance;
  MockData._internal();

  // Users
  final User travelerUser = const User(
    id: 'u1',
    name: 'John Traveler',
    email: 'john@example.com',
    password: 'password123',
    role: UserRole.traveler,
    profileImage: 'https://i.pravatar.cc/150?u=u1',
  );

  final User providerUser = const User(
    id: 'u2',
    name: 'Sarah Host',
    email: 'sarah@example.com',
    password: 'password123',
    role: UserRole.provider,
    providerType: ProviderType.home,
    providerId: 'p1',
    profileImage: 'https://i.pravatar.cc/150?u=u2',
  );

  final User adminUser = const User(
    id: 'u3',
    name: 'Farah Duale',
    email: 'farah@somsafar.so',
    password: 'adminpassword',
    role: UserRole.admin,
    adminRole: AdminRole.superAdmin,
    profileImage: 'https://i.pravatar.cc/150?u=u3',
  );

  final User financeAdmin = const User(
    id: 'u8',
    name: 'Mohamed Finance',
    email: 'finance@somsafar.so',
    password: 'financepassword',
    role: UserRole.admin,
    adminRole: AdminRole.financeAdmin,
    profileImage: 'https://i.pravatar.cc/150?u=u8',
  );

  final User opsAdmin = const User(
    id: 'u9',
    name: 'Omar Ops',
    email: 'ops@somsafar.so',
    password: 'opspassword',
    role: UserRole.admin,
    adminRole: AdminRole.opsAdmin,
    profileImage: 'https://i.pravatar.cc/150?u=u9',
  );

  final User supportAdmin = const User(
    id: 'u10',
    name: 'Sahra Support',
    email: 'support@somsafar.so',
    password: 'supportpassword',
    role: UserRole.admin,
    adminRole: AdminRole.supportAdmin,
    profileImage: 'https://i.pravatar.cc/150?u=u10',
  );

  final User travelerAhmed = const User(
    id: 'u4',
    name: 'Ahmed Mohamed',
    email: 'ahmed@somsafar.so',
    password: 'password123',
    role: UserRole.traveler,
    profileImage: 'https://i.pravatar.cc/150?u=u4',
  );

  final User providerAsha = const User(
    id: 'u5',
    name: 'Asha Omar',
    email: 'asha@somsafar.so',
    password: 'password123',
    role: UserRole.provider,
    providerType: ProviderType.hotel,
    providerId: 'p2',
    profileImage: 'https://i.pravatar.cc/150?u=u5',
  );

  final User travelerDeeqa = const User(
    id: 'u6',
    name: 'Deeqa Hassan',
    email: 'deeqa@somsafar.so',
    password: 'password123',
    role: UserRole.traveler,
    profileImage: 'https://i.pravatar.cc/150?u=u6',
  );

  final User providerLiban = const User(
    id: 'u7',
    name: 'Liban Abdi',
    email: 'liban@somsafar.so',
    password: 'password123',
    role: UserRole.provider,
    providerType: ProviderType.transport,
    providerId: 'p3',
    profileImage: 'https://i.pravatar.cc/150?u=u7',
  );

  // Services
  final List<Service> services = [
    Service(
      id: 's1',
      providerId: 'p1', // Sarah Host
      title: 'Luxury Villa with Sea View',
      category: 'Home',
      price: 150.0,
      location: 'Mogadishu, Somalia',
      description:
          'Beautiful 3 bedroom villa over looking the Indian Ocean. Includes wifi, pool, and breakfast.',
      status: ServiceStatus.active,
      images: ['https://placehold.co/600x400/0A3D62/FFF?text=Villa'],
    ),
    Service(
      id: 's2',
      providerId: 'p2', // Asha Omar
      title: 'City Center Apartment',
      category: 'Apartment',
      price: 80.0,
      location: 'Hargeisa, Somalia',
      description:
          'Modern apartment in the heart of the city. Close to markets and transport.',
      status: ServiceStatus.active,
      images: ['https://placehold.co/600x400/1DD1A1/FFF?text=Apartment'],
    ),
    Service(
      id: 's3',
      providerId: 'p3', // Liban Abdi
      title: 'Safari Tour Package',
      category: 'Tour',
      price: 200.0,
      location: 'Kismayo, Somalia',
      description: '3 day guided safari tour. Meals and transport included.',
      status: ServiceStatus.draft,
      images: ['https://placehold.co/600x400/F2994A/FFF?text=Safari'],
    ),
  ];

  // Bookings
  final List<Booking> bookings = [
    Booking(
      id: 'b1',
      serviceId: 's1',
      providerId: 'p1',
      serviceTitle: 'Luxury Villa with Sea View',
      travelerId: 'u1',
      travelerName: 'John Traveler',
      date: DateTime.now().subtract(const Duration(days: 1)),
      checkIn: DateTime.now().add(const Duration(days: 2)),
      checkOut: DateTime.now().add(const Duration(days: 5)),
      guests: 2,
      rooms: 1,
      totalPrice: 450.0,
      contactPhone: '12345678',
      contactEmail: 'john@example.com',
      status: BookingStatus.pending,
      paymentStatus: BookingPaymentStatus.paid,
    ),
    Booking(
      id: 'b2',
      serviceId: 's2',
      providerId: 'p2',
      serviceTitle: 'City Center Apartment',
      travelerId: 'u4',
      travelerName: 'Alice Guest',
      date: DateTime.now().subtract(const Duration(days: 10)),
      checkIn: DateTime.now().subtract(const Duration(days: 5)),
      checkOut: DateTime.now().subtract(const Duration(days: 2)),
      guests: 1,
      rooms: 1,
      totalPrice: 240.0,
      contactPhone: '87654321',
      contactEmail: 'alice@example.com',
      status: BookingStatus.completed,
      paymentStatus: BookingPaymentStatus.paid,
    ),
    Booking(
      id: 'b3',
      serviceId: 's1',
      providerId: 'p1',
      serviceTitle: 'Luxury Villa with Sea View',
      travelerId: 'u5',
      travelerName: 'Bob Tourist',
      date: DateTime.now().subtract(const Duration(days: 20)),
      checkIn: DateTime.now().add(const Duration(days: 10)),
      checkOut: DateTime.now().add(const Duration(days: 15)),
      guests: 4,
      rooms: 2,
      totalPrice: 1500.0,
      contactPhone: '11223344',
      contactEmail: 'bob@example.com',
      status: BookingStatus.confirmed,
      paymentStatus: BookingPaymentStatus.paid,
    ),
  ];

  // Chat Messages
  final List<ChatMessage> chatMessages = [
    // Booking b1: John Traveler (u1) -> Sarah Host (p1)
    ChatMessage.fromTraveler(
      id: 'msg1',
      bookingId: 'b1',
      travelerId: 'u1',
      messageText: 'Hi! I have a question about the check-in time.',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ChatMessage.fromProvider(
      id: 'msg2',
      bookingId: 'b1',
      providerId: 'p1',
      messageText: 'Hello! Check-in is at 2 PM. Welcome!',
      timestamp: DateTime.now().subtract(const Duration(hours: 2, minutes: 45)),
    ),
    ChatMessage.fromTraveler(
      id: 'msg3',
      bookingId: 'b1',
      travelerId: 'u1',
      messageText: 'Is parking available at the villa?',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    ChatMessage.fromProvider(
      id: 'msg4',
      bookingId: 'b1',
      providerId: 'p1',
      messageText: 'Yes, free parking is available.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    ChatMessage.fromProvider(
      id: 'msg5',
      bookingId: 'b1',
      providerId: 'p1',
      messageText: 'Internal note: Guest arriving from airport, arrange pickup',
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      isInternalNote: true,
    ),

    // Booking b3: Bob Tourist (u5) -> Sarah Host (p1)
    ChatMessage.fromTraveler(
      id: 'msg6',
      bookingId: 'b3',
      travelerId: 'u5',
      messageText: 'Can we do early check-in?',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChatMessage.fromProvider(
      id: 'msg7',
      bookingId: 'b3',
      providerId: 'p1',
      messageText: 'Early check-in available for \$25 extra.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 22)),
    ),
    ChatMessage.fromTraveler(
      id: 'msg8',
      bookingId: 'b3',
      travelerId: 'u5',
      messageText: 'That works! Please arrange it.',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 20)),
    ),
  ];
}
