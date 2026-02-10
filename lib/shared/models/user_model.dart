enum UserRole { traveler, provider, admin }

enum AdminRole { superAdmin, opsAdmin, financeAdmin, supportAdmin }

enum UserStatus { active, blocked, suspended }

enum ProviderType { hotel, home, apartment, transport }

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final AdminRole? adminRole; // Only for admin users
  final ProviderType? providerType; // Only for provider users
  final String? providerId; // Scoping ID for providers
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
    this.providerId,
    this.status = UserStatus.active,
    this.profileImage,
  });

  User copyWith({
    String? name,
    String? email,
    UserRole? role,
    AdminRole? adminRole,
    ProviderType? providerType,
    String? providerId,
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
      providerId: providerId ?? this.providerId,
      status: status ?? this.status,
      profileImage: profileImage ?? this.profileImage,
      password: password ?? this.password,
    );
  }

  bool get isSuperAdmin => adminRole == AdminRole.superAdmin;
  bool get isOpsAdmin => adminRole == AdminRole.opsAdmin;
  bool get isFinanceAdmin => adminRole == AdminRole.financeAdmin;
  bool get isSupportAdmin => adminRole == AdminRole.supportAdmin;

  bool get canManageAdmins => isSuperAdmin;
  bool get canManageFinance => isSuperAdmin || isFinanceAdmin;
  bool get canManageOps => isSuperAdmin || isOpsAdmin;
  bool get canManageSupport => isSuperAdmin || isSupportAdmin;
}
