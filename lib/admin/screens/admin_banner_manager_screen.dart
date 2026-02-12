import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../shared/services/banner_repository.dart';
import '../../shared/models/banner_model.dart';
import '../../core/theme/app_colors.dart';

class AdminBannerManagerScreen extends ConsumerStatefulWidget {
  const AdminBannerManagerScreen({super.key});

  @override
  ConsumerState<AdminBannerManagerScreen> createState() =>
      _AdminBannerManagerScreenState();
}

class _AdminBannerManagerScreenState
    extends ConsumerState<AdminBannerManagerScreen> {
  final _imageUrlController = TextEditingController();
  final _captionController = TextEditingController();
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedFile = File(image.path);
        // simulation: use the local path as the "uploaded" URL
        _imageUrlController.text = image.path;
      });
    }
  }

  void _addBanner() {
    final imageUrl = _imageUrlController.text;
    final caption = _captionController.text;

    if (imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an image URL')),
      );
      return;
    }

    final error = ref
        .read(bannerProvider.notifier)
        .addBanner(imageUrl, caption);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    } else {
      _imageUrlController.clear();
      _captionController.clear();
      setState(() {
        _selectedFile = null;
      });
      Navigator.pop(context);
    }
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(32),
            topRight: Radius.circular(32),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 32,
          top: 32,
          left: 32,
          right: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Add New Banner',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: _selectedFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: kIsWeb
                              ? Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                )
                              : Image.file(_selectedFile!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tap to select image',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(
                labelText: 'Image URL (Auto-filled on pick)',
                hintText: 'https://...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                labelText: 'Caption (Optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _addBanner,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text('Add Banner'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final banners = ref.watch(bannerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Banners'), centerTitle: true),
      body: banners.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.image_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No banners yet',
                    style: TextStyle(color: Colors.grey[600], fontSize: 18),
                  ),
                ],
              ),
            )
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: banners.length,
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                final items = List<BannerImage>.from(banners);
                final item = items.removeAt(oldIndex);
                items.insert(newIndex, item);
                ref.read(bannerProvider.notifier).updateOrder(items);
              },
              itemBuilder: (context, index) {
                final banner = banners[index];
                return _BannerListTile(
                  key: ValueKey(banner.id),
                  banner: banner,
                  onDelete: () =>
                      ref.read(bannerProvider.notifier).removeBanner(banner.id),
                  onToggle: () =>
                      ref.read(bannerProvider.notifier).toggleStatus(banner.id),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: banners.length >= 10 ? null : _showAddDialog,
        backgroundColor: banners.length >= 10 ? Colors.grey : AppColors.primary,
        icon: const Icon(Icons.add),
        label: Text('Add Banner (${banners.length}/10)'),
      ),
    );
  }
}

class _BannerListTile extends StatelessWidget {
  final BannerImage banner;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _BannerListTile({
    super.key,
    required this.banner,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.drag_indicator, color: Colors.grey),
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: banner.imageUrl.startsWith('http') || kIsWeb
                  ? Image.network(
                      banner.imageUrl,
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 80,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 20),
                      ),
                    )
                  : Image.file(
                      File(banner.imageUrl),
                      width: 80,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        width: 80,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image, size: 20),
                      ),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.caption ?? 'No caption',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    banner.isActive ? 'Active' : 'Inactive',
                    style: TextStyle(
                      color: banner.isActive ? Colors.green : Colors.red,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: banner.isActive,
              onChanged: (_) => onToggle(),
              activeThumbColor: AppColors.primary,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Banner'),
                    content: const Text(
                      'Are you sure you want to delete this banner?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          onDelete();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
