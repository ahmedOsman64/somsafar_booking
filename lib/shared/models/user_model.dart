enum UserRole { traveler, provider, admin }

enum AdminRole { superAdmin, opsAdmin, supportAdmin }

enum UserStatus { active, blocked, suspended }

enum ProviderType { hotel, home, apartment, transport }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final AdminRole? adminRole; // Only for admin users
  final ProviderType? providerType; // Only for provider users
  final UserStatus status;
  final String? profileImage;
  final String password; // Mock password field

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.password,
    this.adminRole,
    this.providerType,
    this.status = UserStatus.active,
    this.profileImage,
  });

  User copyWith({
    String? name,
    String? email,
    UserRole? role,
    AdminRole? adminRole,
    ProviderType? providerType,
    UserStatus? status,
    String? profileImage,
    String? password,
  }) {
    return User(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      adminRole: adminRole ?? this.adminRole,
      providerType: providerType ?? this.providerType,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      password: password ?? this.password,
    );
  }
}
