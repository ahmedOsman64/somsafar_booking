import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';
import 'auth_service.dart';
import 'package:uuid/uuid.dart';

class ServiceRepository extends StateNotifier<List<Service>> {
  ServiceRepository() : super(MockData().services);

  void addService(Service service) {
    final newService = service.copyWith(id: const Uuid().v4());
    state = [...state, newService];
  }

  void updateService(Service updatedService) {
    state = [
      for (final s in state)
        if (s.id == updatedService.id) updatedService else s,
    ];
  }

  void deleteService(String id) {
    state = state.where((s) => s.id != id).toList();
  }

  // Provider specific functions
  List<Service> get activeServices =>
      state.where((s) => s.status == ServiceStatus.active).toList();
  List<Service> get draftServices =>
      state.where((s) => s.status == ServiceStatus.draft).toList();
  List<Service> get pendingServices =>
      state.where((s) => s.status == ServiceStatus.pendingApproval).toList();
  List<Service> get inactiveServices => state
      .where(
        (s) =>
            s.status == ServiceStatus.inactive ||
            s.status == ServiceStatus.blocked,
      )
      .toList();
}

final serviceProvider = StateNotifierProvider<ServiceRepository, List<Service>>(
  (ref) {
    return ServiceRepository();
  },
);

// Selector for role-based data isolation
final filteredServicesProvider = Provider<List<Service>>((ref) {
  final user = ref.watch(authProvider);
  final services = ref.watch(serviceProvider);

  if (user == null) {
    // If not logged in (e.g. browsing as guest if allowed), see only active
    return services.where((s) => s.status == ServiceStatus.active).toList();
  }

  switch (user.role) {
    case UserRole.traveler:
      // Travelers see all active services
      return services.where((s) => s.status == ServiceStatus.active).toList();
    case UserRole.provider:
      // Providers only see THEIR SITUATION
      return services.where((s) => s.providerId == user.providerId).toList();
    case UserRole.admin:
      // Admins see all for moderation
      return services;
  }
});
