import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/service_repository.dart';
import '../../shared/services/booking_repository.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/booking_model.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/models/user_model.dart';

class ProviderDashboardScreen extends ConsumerWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider);
    final services = ref.watch(filteredServicesProvider);
    final bookings = ref.watch(filteredBookingsProvider);
    final width = MediaQuery.of(context).size.width;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final providerType = user.providerType ?? ProviderType.hotel;

    // Filter services for this provider (assuming mock data handles this or we filter here)
    // Actually, requirement 6 says "Providers see only their own services"
    // For now, we'll assume the provider handles that, but we can filter by type if needed
    // or just assume all services in the list belong to the user.

    // Calculate KPIs
    final activeServices = services
        .where((s) => s.status == ServiceStatus.active)
        .length;
    final inactiveServices = services
        .where((s) => s.status == ServiceStatus.inactive)
        .length;
    final draftServices = services
        .where((s) => s.status == ServiceStatus.draft)
        .length;
    final pendingBookings = bookings
        .where((b) => b.status == BookingStatus.pending)
        .length;

    // Dynamic Labels & Icons
    String totalLabel = 'Total Services';
    String activeLabel = 'Active Listings';
    String inactiveLabel = 'Inactive';
    String pendingLabel = 'Pending Req.';
    String addActionLabel = '+ Add New Service';

    IconData totalIcon = Icons.list_alt;
    IconData activeIcon = Icons.check_circle;
    IconData inactiveIcon = Icons.hide_source;

    switch (providerType) {
      case ProviderType.hotel:
        totalLabel = 'Total Hotels';
        activeLabel = 'Active Rooms';
        inactiveLabel = 'Inactive Rooms';
        addActionLabel = '+ Add New Hotel';
        totalIcon = Icons.hotel;
        activeIcon = Icons.bedroom_parent;
        inactiveIcon = Icons.king_bed;
        break;
      case ProviderType.home:
        totalLabel = 'Total Homes';
        activeLabel = 'Active Homes';
        inactiveLabel = 'Inactive Homes';
        addActionLabel = '+ Add New Home';
        totalIcon = Icons.home;
        activeIcon = Icons.home_outlined;
        inactiveIcon = Icons.home_work;
        break;
      case ProviderType.apartment:
        totalLabel = 'Total Apartments';
        activeLabel = 'Active Apartments';
        inactiveLabel = 'Inactive Apartments';
        addActionLabel = '+ Add New Apartment';
        totalIcon = Icons.apartment;
        activeIcon = Icons.business;
        inactiveIcon = Icons.corporate_fare;
        break;
      case ProviderType.transport:
        totalLabel = 'Total Vehicles';
        activeLabel = 'Active Vehicles';
        inactiveLabel = 'Inactive Vehicles';
        addActionLabel = '+ Add New Vehicle';
        totalIcon = Icons.directions_car;
        activeIcon = Icons.drive_eta;
        inactiveIcon = Icons.car_repair;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: services.isEmpty
          ? _buildEmptyState(context, addActionLabel, providerType)
          : RefreshIndicator(
              onRefresh: () async {
                // Trigger refresh if needed
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: width > 600 ? 5 : 2,
                      childAspectRatio: width > 1000
                          ? 1.0
                          : width > 600
                          ? 0.85
                          : 1.0,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _KpiCard(
                          title: totalLabel,
                          value: services.length.toString(),
                          icon: totalIcon,
                          color: AppColors.primary,
                        ),
                        _KpiCard(
                          title: activeLabel,
                          value: activeServices.toString(),
                          icon: activeIcon,
                          color: AppColors.success,
                        ),
                        _KpiCard(
                          title: inactiveLabel,
                          value: inactiveServices.toString(),
                          icon: inactiveIcon,
                          color: AppColors.grey,
                        ),
                        _KpiCard(
                          title: 'Draft Listings',
                          value: draftServices.toString(),
                          icon: Icons.edit_note,
                          color: Colors.orange,
                        ),
                        _KpiCard(
                          title: pendingLabel,
                          value: pendingBookings.toString(),
                          icon: Icons.pending_actions,
                          color: AppColors.warning,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Quick Actions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              context.go('/provider/services/add');
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.add, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  addActionLabel,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              context.go('/provider/services');
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.all(20),
                              side: const BorderSide(color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.settings, color: AppColors.primary),
                                SizedBox(width: 8),
                                Text(
                                  'Manage Services',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    String actionLabel,
    ProviderType type,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              type == ProviderType.transport
                  ? Icons.directions_car
                  : type == ProviderType.hotel
                  ? Icons.hotel
                  : Icons.home,
              size: 80,
              color: AppColors.grey.withAlpha(100),
            ),
            const SizedBox(height: 24),
            Text(
              'No services found',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Start by adding your first ${type.name} to see stats here.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.go('/provider/services/add'),
              icon: const Icon(Icons.add),
              label: Text(actionLabel),
            ),
          ],
        ),
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _KpiCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.dark,
              ),
            ),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
