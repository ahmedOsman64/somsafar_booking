import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../shared/services/service_repository.dart';
import '../../shared/models/service_model.dart';
import '../../core/theme/app_colors.dart';

class AdminServicesScreen extends ConsumerStatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  ConsumerState<AdminServicesScreen> createState() =>
      _AdminServicesScreenState();
}

class _AdminServicesScreenState extends ConsumerState<AdminServicesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(serviceProvider);

    // Filter by search
    final filteredServices = services.where((s) {
      return s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    // Split by status
    final pendingServices = filteredServices
        .where((s) => s.status == ServiceStatus.pendingApproval)
        .toList();
    final activeServices = filteredServices
        .where((s) => s.status == ServiceStatus.active)
        .toList();
    final otherServices = filteredServices
        .where(
          (s) =>
              s.status != ServiceStatus.active &&
              s.status != ServiceStatus.pendingApproval,
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Services'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/admin/dashboard'),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.accent,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Moderation'),
                  if (pendingServices.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${pendingServices.length}',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(text: 'Active (${activeServices.length})'),
            const Tab(text: 'Others'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search services...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ServiceList(services: pendingServices, isModeration: true),
                _ServiceList(services: activeServices),
                _ServiceList(services: otherServices),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceList extends ConsumerWidget {
  final List<Service> services;
  final bool isModeration;

  const _ServiceList({required this.services, this.isModeration = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (services.isEmpty) {
      return const Center(child: Text('No services found in this category'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Card(
          elevation: isModeration ? 4 : 1,
          margin: const EdgeInsets.only(bottom: 16),
          shape: isModeration
              ? RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.orange, width: 2),
                  borderRadius: BorderRadius.circular(12),
                )
              : null,
          child: ExpansionTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                service.images.first,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (c, o, s) =>
                    Container(width: 50, height: 50, color: Colors.grey),
              ),
            ),
            title: Text(
              service.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('${service.category} • \$${service.price}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: service.statusColor.withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                service.statusLabel,
                style: TextStyle(
                  color: service.statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Description:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(service.description),
                    const SizedBox(height: 16),
                    _buildActions(context, ref, service),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context, WidgetRef ref, Service service) {
    if (service.status == ServiceStatus.pendingApproval) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              icon: const Icon(Icons.close),
              onPressed: () => _updateStatus(
                ref,
                service,
                ServiceStatus.draft,
              ), // Reject back to draft
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              label: const Text('Reject'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.check),
              onPressed: () =>
                  _updateStatus(ref, service, ServiceStatus.active),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
              ),
              label: const Text('Approve'),
            ),
          ),
        ],
      );
    } else if (service.status == ServiceStatus.active) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _updateStatus(ref, service, ServiceStatus.blocked),
          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Block Service (Violation)'),
        ),
      );
    } else if (service.status == ServiceStatus.blocked) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: () => _updateStatus(ref, service, ServiceStatus.active),
          child: const Text('Unblock Service'),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  void _updateStatus(WidgetRef ref, Service service, ServiceStatus status) {
    ref
        .read(serviceProvider.notifier)
        .updateService(service.copyWith(status: status));
  }
}
