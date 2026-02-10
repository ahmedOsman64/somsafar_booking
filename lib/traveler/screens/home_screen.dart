import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/auth_service.dart';
import '../../shared/services/service_repository.dart';
import '../../shared/models/service_model.dart';

class TravelerHomeScreen extends ConsumerStatefulWidget {
  const TravelerHomeScreen({super.key});

  @override
  ConsumerState<TravelerHomeScreen> createState() => _TravelerHomeScreenState();
}

class _TravelerHomeScreenState extends ConsumerState<TravelerHomeScreen> {
  String _selectedCategory = 'All';

  final List<Map<String, dynamic>> _categories = [
    {'icon': Icons.grid_view, 'label': 'All'},
    {'icon': Icons.hotel, 'label': 'Hotels'},
    {'icon': Icons.home, 'label': 'Homes'},
    {'icon': Icons.directions_car, 'label': 'Transport'},
    {'icon': Icons.apartment, 'label': 'Apartments'},
  ];

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);
    final services = ref.watch(filteredServicesProvider);
    final displayName = (user != null && user.name.trim().isNotEmpty)
        ? user.name
        : 'Traveler';

    // Filter active services based on selection AND status
    final featuredServices = services.where((s) {
      if (s.status != ServiceStatus.active) return false;
      if (_selectedCategory == 'All') return true;

      // Mapping UI category to Data category
      // UI: 'Hotels' -> Data: 'Hotel'
      // UI: 'Homes' -> Data: 'Home'
      // UI: 'Transport' -> Data: 'Transport'
      // UI: 'Apartments' -> Data: 'Apartment'

      // Simple singularization for matching (strip 's' if present, handle special cases if needed)
      // Actually, let's look at the labels.
      // 'Hotels' -> startsWith('Hotel') might be safer if data is 'Hotel'.

      String dataCategory = s.category; // e.g., 'Home', 'Apartment', 'Tour'

      switch (_selectedCategory) {
        case 'Hotels':
          return dataCategory == 'Hotel';
        case 'Homes':
          return dataCategory == 'Home';
        case 'Transport':
          // Assuming 'Transport' or 'Tour' might be related, but let's stick to exact match or specific logic.
          // In mock data we have 'Tour'. User asked for 'Transport'.
          // Let's assume 'Transport' in UI maps to 'Transport' in data if it exists.
          // If the mock data has 'Tour', maybe we should include 'Tour' under 'Transport' or just strictly match.
          // Given the prompt: "Selecting “Transport” → show only transport".
          return dataCategory == 'Transport';
        case 'Apartments':
          return dataCategory == 'Apartment';
        default:
          return false;
      }
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Light background
      body: CustomScrollView(
        slivers: [
          // 1. Header Section with Gradient
          SliverAppBar(
            pinned: true,
            expandedHeight: 180.0,
            backgroundColor: AppColors.primary,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF0A3D62),
                      Color(0xFF06253B),
                    ], // Navy/Dark Blue
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 16.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48), // Top padding for status bar
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Welcome back,',
                                  style: TextStyle(
                                    color: Colors.white.withAlpha(200),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  displayName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Optional Profile Avatar
                          Container(
                            margin: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withAlpha(50),
                                width: 2,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 24,
                              backgroundColor: Colors.white.withAlpha(30),
                              backgroundImage: user?.profileImage != null
                                  ? NetworkImage(user!.profileImage!)
                                  : null,
                              child: user?.profileImage == null
                                  ? const Icon(
                                      Icons.person,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(80),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                color: Colors
                    .transparent, // Let gradient show through or use white overlap?
                // Design usually has search bar half-overlapping or inside header.
                // Let's put it inside the bottom slot cleanly.
                child: GestureDetector(
                  onTap: () => context.go('/traveler/search'),
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(20),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: 28,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Where do you want to go?',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withAlpha(20),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 2. Categories Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Removed "Categories" title for cleaner look?
                  // The prompt said "UI CLEANUP & SIMPLICITY ... Remove unused or inactive UI elements".
                  // But let's keep the title if not explicitly asked to remove, but maybe make it cleaner.
                  // The prompt says "Remove unused or inactive UI elements". The title is useful context.
                  // However, for Simplicity, often the list speaks for itself.
                  // Prompt validation: "Categories are simple, selectable, and user-friendly".
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Text(
                      'Categories',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        final label = cat['label'] as String;
                        final isSelected = label == _selectedCategory;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategory = label;
                            });
                          },
                          child: _CategoryItem(
                            icon: cat['icon'] as IconData,
                            label: label,
                            isSelected: isSelected,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 3. Featured Services Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Featured Services', // Maybe change this to match category? E.g., "Top Hotels"
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.dark,
                              ),
                        ),
                        TextButton(
                          onPressed: () => context.go('/traveler/search'),
                          child: const Text('See All'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (featuredServices.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            'No $_selectedCategory found.',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    SizedBox(
                      height: 280, // Height for the horizontal cards
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        scrollDirection: Axis.horizontal,
                        itemCount: featuredServices.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 16),
                        itemBuilder: (context, index) {
                          return _FeaturedServiceCard(
                            service: featuredServices[index],
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Bottom spacer for navigation bar
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _CategoryItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              if (!isSelected)
                BoxShadow(
                  color: Colors.grey.withAlpha(20),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.white : AppColors.grey,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.primary : AppColors.grey,
          ),
        ),
      ],
    );
  }
}

class _FeaturedServiceCard extends StatelessWidget {
  final Service service;

  const _FeaturedServiceCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/traveler/service/${service.id}'),
      child: Container(
        width: 240, // Fixed width for horizontal scrolling
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(10),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                Image.network(
                  service.images.isNotEmpty ? service.images.first : '',
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) => Container(
                    height: 140,
                    color: Colors.grey[200],
                    child: const Icon(
                      Icons.image_not_supported,
                      color: Colors.grey,
                    ),
                  ),
                ),
                // NO RATING BADGE HERE
              ],
            ),

            // Details
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    service.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppColors.grey,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          service.location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$${service.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const TextSpan(
                          text: ' / night',
                          style: TextStyle(fontSize: 12, color: AppColors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
