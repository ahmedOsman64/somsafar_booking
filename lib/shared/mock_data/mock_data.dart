import '../models/user_model.dart';
import '../models/service_model.dart';
import '../models/booking_model.dart';

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
    profileImage: 'https://i.pravatar.cc/150?u=u2',
  );

  final User adminUser = const User(
    id: 'u3',
    name: 'Farah Duale',
    email: 'farah@somsafar.so',
    password: 'adminpassword',
    role: UserRole.admin,
    profileImage: 'https://i.pravatar.cc/150?u=u3',
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
    profileImage: 'https://i.pravatar.cc/150?u=u7',
  );

  // Services
  final List<Service> services = [
    Service(
      id: 's1',
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
}
