import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../mock_data/mock_data.dart';
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
