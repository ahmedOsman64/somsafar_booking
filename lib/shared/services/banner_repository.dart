import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/banner_model.dart';

class BannerRepository extends StateNotifier<List<BannerImage>> {
  BannerRepository() : super(_initialBanners);

  static final List<BannerImage> _initialBanners = [
    const BannerImage(
      id: 'default_1',
      imageUrl:
          'https://images.unsplash.com/photo-1596417601532-931bf3ee8063?q=80&w=2071&auto=format&fit=crop',
      caption: 'Welcome to beautiful Somalia',
      order: 0,
    ),
    const BannerImage(
      id: 'default_2',
      imageUrl:
          'https://images.unsplash.com/photo-1544642981-6927c6276081?q=80&w=1974&auto=format&fit=crop',
      caption: 'Explore Mogadishu',
      order: 1,
    ),
  ];

  String? addBanner(String imageUrl, String? caption) {
    if (state.length >= 10) {
      return 'Maximum 10 images allowed.';
    }

    final newBanner = BannerImage(
      id: const Uuid().v4(),
      imageUrl: imageUrl,
      caption: caption,
      order: state.length,
    );

    state = [...state, newBanner];
    return null;
  }

  void removeBanner(String id) {
    state = state.where((b) => b.id != id).toList();
    _reorderBanners();
  }

  void updateOrder(List<BannerImage> newOrder) {
    state = newOrder.asMap().entries.map((entry) {
      return entry.value.copyWith(order: entry.key);
    }).toList();
  }

  void _reorderBanners() {
    state = state.asMap().entries.map((entry) {
      return entry.value.copyWith(order: entry.key);
    }).toList();
  }

  void toggleStatus(String id) {
    state = [
      for (final b in state)
        if (b.id == id) b.copyWith(isActive: !b.isActive) else b,
    ];
  }
}

final bannerProvider =
    StateNotifierProvider<BannerRepository, List<BannerImage>>((ref) {
      return BannerRepository();
    });

final activeBannersProvider = Provider<List<BannerImage>>((ref) {
  final banners = ref.watch(bannerProvider);
  final active = banners.where((b) => b.isActive).toList()
    ..sort((a, b) => a.order.compareTo(b.order));

  // If no active banners, return the default fallback image
  if (active.isEmpty) {
    return [
      const BannerImage(
        id: 'fallback',
        imageUrl:
            'https://images.unsplash.com/photo-1544642981-6927c6276081?q=80&w=1974&auto=format&fit=crop',
        caption: 'Welcome to SomSafar',
        order: 0,
      ),
    ];
  }
  return active;
});
