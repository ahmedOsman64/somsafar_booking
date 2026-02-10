import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/services/service_repository.dart';
import 'package:go_router/go_router.dart';

class TravelerSearchScreen extends ConsumerStatefulWidget {
  const TravelerSearchScreen({super.key});

  @override
  ConsumerState<TravelerSearchScreen> createState() =>
      _TravelerSearchScreenState();
}

class _TravelerSearchScreenState extends ConsumerState<TravelerSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedCategory;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeServices = ref.watch(filteredServicesProvider);

    // Filter logic
    final filteredServices = activeServices.where((s) {
      final matchesSearch =
          s.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          s.location.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || s.category == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus:
              false, // Don't autofocus to avoid keyboard popping up immediately
          decoration: InputDecoration(
            hintText: 'Search destinations...',
            border: InputBorder.none,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            fillColor: Colors.transparent,
            prefixIcon: const Icon(Icons.search, color: Colors.white70),
            hintStyle: const TextStyle(color: Colors.white70),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  )
                : null,
          ),
          style: const TextStyle(color: Colors.white),
          onChanged: (val) {
            setState(() => _searchQuery = val);
          },
        ),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _selectedCategory == null,
                  onTap: () => setState(() => _selectedCategory = null),
                ),
                _FilterChip(
                  label: 'Hotels',
                  isSelected: _selectedCategory == 'Hotels',
                  onTap: () => setState(() => _selectedCategory = 'Hotels'),
                ),
                _FilterChip(
                  label: 'Homes',
                  isSelected: _selectedCategory == 'Home',
                  onTap: () => setState(() => _selectedCategory = 'Home'),
                ),
                _FilterChip(
                  label: 'Apartments',
                  isSelected: _selectedCategory == 'Apartment',
                  onTap: () => setState(() => _selectedCategory = 'Apartment'),
                ),
              ],
            ),
          ),

          // Results
          Expanded(
            child: filteredServices.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_off, size: 64, color: AppColors.grey),
                        SizedBox(height: 16),
                        Text('No results found'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredServices.length,
                    itemBuilder: (context, index) {
                      final service = filteredServices[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: InkWell(
                          onTap: () =>
                              context.push('/traveler/service/${service.id}'),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  service.images.first,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (c, o, s) => Container(
                                    width: 120,
                                    height: 120,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        service.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${service.category} • ${service.location}',
                                        style: const TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${service.price.toStringAsFixed(0)} / night',
                                        style: const TextStyle(
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
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.secondary.withAlpha((0.2 * 255).round()),
        checkmarkColor: AppColors.secondary,
        labelStyle: TextStyle(
          color: isSelected ? AppColors.secondary : AppColors.dark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}
