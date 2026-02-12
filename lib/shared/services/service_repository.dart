import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import '../models/user_model.dart';
import '../mock_data/mock_data.dart';
import 'auth_service.dart';
import 'package:uuid/uuid.dart';

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceRepository extends StateNotifier<List<Service>> {
  ServiceRepository() : super(MockData().services) {
    _loadFromPrefs();
  }

  static const String _storageKey = 'somsafar_services';

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storedData = prefs.getString(_storageKey);

    if (storedData != null) {
      final List<dynamic> decoded = jsonDecode(storedData);
      state = decoded.map((json) => Service.fromJson(json)).toList();
    } else {
      // First run: save mock data to prefs
      _saveToPrefs();
    }
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(state.map((s) => s.toJson()).toList());
    await prefs.setString(_storageKey, encoded);
  }

  Future<void> addService(Service service) async {
    // Generate ID if empty
    final newId = service.id.isEmpty ? const Uuid().v4() : service.id;
    final newService = service.copyWith(id: newId);
    state = [...state, newService];
    await _saveToPrefs();
  }

  Future<void> updateService(Service updatedService) async {
    state = [
      for (final s in state)
        if (s.id == updatedService.id) updatedService else s,
    ];
    await _saveToPrefs();
  }

  Future<void> deleteService(String id) async {
    state = state.where((s) => s.id != id).toList();
    await _saveToPrefs();
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
      // Providers only see their services. If providerId isn't set on the
      // user (e.g. newly created provider record), fall back to the user's
      // own id so the provider still sees services they created.
      final providerKey = user.providerId ?? user.id;
      return services.where((s) => s.providerId == providerKey).toList();
    case UserRole.admin:
      // Admins see all for moderation
      return services;
  }
});
