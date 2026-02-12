import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../shared/services/service_repository.dart';
import '../../shared/models/service_model.dart';
import '../../shared/models/user_model.dart';
import '../../shared/services/auth_service.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/form_widgets.dart';

class ProviderServiceFormScreen extends ConsumerStatefulWidget {
  final String? serviceId;

  const ProviderServiceFormScreen({this.serviceId, super.key});

  @override
  ConsumerState<ProviderServiceFormScreen> createState() =>
      _ProviderServiceFormScreenState();
}

class _ProviderServiceFormScreenState
    extends ConsumerState<ProviderServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'Hotels', 'name': 'Hotels', 'icon': Icons.hotel_outlined},
    {'id': 'Homes', 'name': 'Homes', 'icon': Icons.home_outlined},
    {
      'id': 'Transport',
      'name': 'Transport',
      'icon': Icons.directions_car_outlined,
    },
    {
      'id': 'Apartments',
      'name': 'Apartments',
      'icon': Icons.apartment_outlined,
    },
  ];

  String? _selectedCategory;
  ServiceStatus _status = ServiceStatus.active;
  List<String> _images = [];

  // Common Fields
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _locationController;
  late TextEditingController _descriptionController;

  // Hotel Specific
  late TextEditingController _hotelNameController;
  late TextEditingController _starRatingController;
  late TextEditingController _checkInController;
  late TextEditingController _checkOutController;
  late TextEditingController _hotelRoomsController;
  final List<String> _hotelAmenities = [];

  // Home Specific
  String? _homeType;
  late TextEditingController _bedroomsController;
  late TextEditingController _bathroomsController;
  late TextEditingController _maxGuestsController;
  bool _isFurnished = false;

  // Apartment Specific
  String? _apartmentType;
  late TextEditingController _floorNumberController;
  late TextEditingController _aptRoomsController;
  bool _hasElevator = false;
  bool _hasParking = false;

  // Transport Specific
  String? _vehicleType;
  String? _transmission;
  String? _fuelType;
  bool _driverIncluded = false;
  late TextEditingController _pickupLocationController;
  late TextEditingController _dropoffLocationController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _priceController = TextEditingController();
    _locationController = TextEditingController();
    _descriptionController = TextEditingController();

    // Hotel
    _hotelNameController = TextEditingController();
    _starRatingController = TextEditingController();
    _checkInController = TextEditingController();
    _checkOutController = TextEditingController();
    _hotelRoomsController = TextEditingController();

    // Home
    _bedroomsController = TextEditingController();
    _bathroomsController = TextEditingController();
    _maxGuestsController = TextEditingController();

    // Apartment
    _floorNumberController = TextEditingController();
    _aptRoomsController = TextEditingController();

    // Transport
    _pickupLocationController = TextEditingController();
    _dropoffLocationController = TextEditingController();

    if (widget.serviceId != null) {
      _loadServiceData();
    }
  }

  void _loadServiceData() {
    Future.microtask(() {
      final services = ref.read(filteredServicesProvider);

      try {
        final service = services.firstWhere((s) => s.id == widget.serviceId);
        setState(() {
          _titleController.text = service.title;
          _selectedCategory = service.category;
          _priceController.text = service.price.toString();
          _locationController.text = service.location;
          _descriptionController.text = service.description;
          _status = service.status;
          _images = List.from(service.images);

          // Populate metadata if available
          if (service.metadata.isNotEmpty) {
            _populateMetadata(service.category, service.metadata);
          }
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error loading service data')),
          );
        }
      }
    });
  }

  void _populateMetadata(String category, Map<String, dynamic> metadata) {
    switch (category) {
      case 'Hotels':
        _hotelNameController.text = metadata['hotelName'] ?? '';
        _starRatingController.text = metadata['starRating']?.toString() ?? '';
        _checkInController.text = metadata['checkIn'] ?? '';
        _checkOutController.text = metadata['checkOut'] ?? '';
        _hotelRoomsController.text = metadata['rooms']?.toString() ?? '';
        if (metadata['amenities'] != null) {
          _hotelAmenities.addAll(List<String>.from(metadata['amenities']));
        }
        break;
      case 'Homes':
        _homeType = metadata['homeType'];
        _bedroomsController.text = metadata['bedrooms']?.toString() ?? '';
        _bathroomsController.text = metadata['bathrooms']?.toString() ?? '';
        _maxGuestsController.text = metadata['maxGuests']?.toString() ?? '';
        _isFurnished = metadata['furnished'] ?? false;
        break;
      case 'Apartments':
        _apartmentType = metadata['apartmentType'];
        _floorNumberController.text = metadata['floorNumber']?.toString() ?? '';
        _aptRoomsController.text = metadata['rooms']?.toString() ?? '';
        _hasElevator = metadata['elevator'] ?? false;
        _hasParking = metadata['parking'] ?? false;
        break;
      case 'Transport':
        _vehicleType = metadata['vehicleType'];
        _transmission = metadata['transmission'];
        _fuelType = metadata['fuelType'];
        _driverIncluded = metadata['driverIncluded'] ?? false;
        _pickupLocationController.text = metadata['pickupLocation'] ?? '';
        _dropoffLocationController.text = metadata['dropoffLocation'] ?? '';
        break;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (_titleController.text.isNotEmpty) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Unsaved Changes'),
          content: const Text('Do you want to discard your changes?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Discard', style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  Future<void> _pickImage() async {
    if (_images.length >= 5) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Max 5 images allowed')));
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() {
          _images.add(image.path); // Store local path
        });
      }
    } catch (e) {
      if (context.mounted) {
        String message = 'Error picking image: $e';
        if (e.toString().contains('channel-error')) {
          message =
              'Native plugin not linked. Please STOP the app and RUN it again (full restart required).';
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 5),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _saveService() async {
    if (_formKey.currentState!.validate()) {
      if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one image')),
        );
        return;
      }

      final title = _titleController.text;
      final category = _selectedCategory!;
      final price = double.parse(_priceController.text);
      final location = _locationController.text;
      final description = _descriptionController.text;

      // Collect Metadata
      final Map<String, dynamic> metadata = {};
      switch (category) {
        case 'Hotels':
          metadata['hotelName'] = _hotelNameController.text;
          metadata['starRating'] = int.tryParse(_starRatingController.text);
          metadata['checkIn'] = _checkInController.text;
          metadata['checkOut'] = _checkOutController.text;
          metadata['rooms'] = int.tryParse(_hotelRoomsController.text);
          metadata['amenities'] = _hotelAmenities;
          break;
        case 'Homes':
          metadata['homeType'] = _homeType;
          metadata['bedrooms'] = int.tryParse(_bedroomsController.text);
          metadata['bathrooms'] = int.tryParse(_bathroomsController.text);
          metadata['maxGuests'] = int.tryParse(_maxGuestsController.text);
          metadata['furnished'] = _isFurnished;
          break;
        case 'Apartments':
          metadata['apartmentType'] = _apartmentType;
          metadata['floorNumber'] = int.tryParse(_floorNumberController.text);
          metadata['rooms'] = int.tryParse(_aptRoomsController.text);
          metadata['elevator'] = _hasElevator;
          metadata['parking'] = _hasParking;
          break;
        case 'Transport':
          metadata['vehicleType'] = _vehicleType;
          metadata['transmission'] = _transmission;
          metadata['fuelType'] = _fuelType;
          metadata['driverIncluded'] = _driverIncluded;
          metadata['pickupLocation'] = _pickupLocationController.text;
          metadata['dropoffLocation'] = _dropoffLocationController.text;
          break;
      }

      if (widget.serviceId != null) {
        // Update existsing
        final existingService = ref
            .read(filteredServicesProvider)
            .firstWhere((s) => s.id == widget.serviceId!);

        final updatedService = existingService.copyWith(
          title: title,
          category: category,
          price: price,
          location: location,
          description: description,
          status: _status,
          images: _images,
          metadata: metadata,
        );
        await ref.read(serviceProvider.notifier).updateService(updatedService);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service updated successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        // Create new
        final user = ref.read(authProvider);
        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: User session invalid. Please login again.'),
            ),
          );
          return;
        }

        // Use providerId if set, otherwise fall back to the user's id
        final providerIdToUse = user.providerId ?? user.id;

        final newService = Service(
          id: '', // Repo generates ID
          providerId: providerIdToUse,
          title: title,
          category: category,
          price: price,
          location: location,
          description: description,
          status: _status,
          images: _images,
          metadata: metadata,
        );
        await ref.read(serviceProvider.notifier).addService(newService);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Service created successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }

      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.serviceId != null;
    final user = ref.watch(authProvider);
    final providerType = user?.providerType ?? ProviderType.hotel;

    // Filter categories based on provider type
    final List<Map<String, dynamic>> filteredCategories = _categories.where((
      c,
    ) {
      final catId = c['id'] as String;
      switch (providerType) {
        case ProviderType.hotel:
          return catId == 'Hotels';
        case ProviderType.home:
          return catId == 'Homes';
        case ProviderType.apartment:
          return catId == 'Apartments';
        case ProviderType.transport:
          return catId == 'Transport';
      }
    }).toList();

    // Auto-select category if not set and it's a new service
    if (_selectedCategory == null &&
        !isEditing &&
        filteredCategories.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _selectedCategory == null) {
          setState(
            () => _selectedCategory = filteredCategories.first['id'] as String,
          );
        }
      });
    }

    String typeLabel = 'Service';
    switch (providerType) {
      case ProviderType.hotel:
        typeLabel = 'Hotel';
        break;
      case ProviderType.home:
        typeLabel = 'Home';
        break;
      case ProviderType.apartment:
        typeLabel = 'Apartment';
        break;
      case ProviderType.transport:
        typeLabel = 'Vehicle';
        break;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit $typeLabel' : 'Add New $typeLabel'),
          actions: [
            if (isEditing)
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline, color: Colors.white),
              ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (filteredCategories.length > 1) ...[
                  _buildCategorySelection(filteredCategories),
                  const SizedBox(height: 32),
                ],

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _selectedCategory == null
                      ? const SizedBox.shrink()
                      : Column(
                          key: ValueKey(_selectedCategory),
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCommonFields(),
                            const SizedBox(height: 32),
                            _buildCategorySpecificFields(),
                            const SizedBox(height: 32),
                            _buildDescriptionSection(),
                            const SizedBox(height: 32),
                            _buildImageSection(),
                            const SizedBox(height: 32),
                            _buildStatusSection(),
                            const SizedBox(height: 48),
                            _buildActionButtons(),
                          ],
                        ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelection(List<Map<String, dynamic>> categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Category'),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((c) {
              final id = c['id'] as String;
              final name = c['name'] as String;
              final icon = c['icon'] as IconData;
              final isSelected = _selectedCategory == id;
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: CategoryCard(
                  name: name,
                  icon: icon,
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedCategory = id),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCommonFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Basic Information'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _titleController,
          label: 'Service Title *',
          hint: 'enter title for your service',
          validator: (val) =>
              val == null || val.isEmpty ? 'Title is required' : null,
          prefixIcon: const Icon(Icons.title),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppTextField(
                controller: _locationController,
                label: 'Location *',
                hint: 'City, Country',
                prefixIcon: const Icon(Icons.location_on_outlined),
                validator: (val) =>
                    val == null || val.isEmpty ? 'Location is required' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                controller: _priceController,
                label: _selectedCategory == 'Transport'
                    ? 'Price per Day *'
                    : 'Price per Night *',
                hint: '0.00',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefixIcon: const Icon(Icons.attach_money),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Required';
                  final num = double.tryParse(val);
                  if (num == null || num <= 0) return 'Invalid price';
                  return null;
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategorySpecificFields() {
    switch (_selectedCategory) {
      case 'Hotels':
        return _buildHotelFields();
      case 'Homes':
        return _buildHomeFields();
      case 'Apartments':
        return _buildApartmentFields();
      case 'Transport':
        return _buildTransportFields();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildHotelFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Hotel Details'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _hotelNameController,
          label: 'Hotel Name *',
          hint: 'Enter hotel name',
          prefixIcon: const Icon(Icons.hotel),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _starRatingController,
                label: 'Star Rating (1-5) *',
                hint: 'e.g. 5',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.star_border),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                controller: _hotelRoomsController,
                label: 'Number of Rooms *',
                hint: 'e.g. 20',
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.meeting_room_outlined),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _checkInController,
                label: 'Check-in Time *',
                hint: 'enter time in HH:MM AM/PM format',
                prefixIcon: const Icon(Icons.login),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                controller: _checkOutController,
                label: 'Check-out Time *',
                hint: 'enter time out in HH:MM AM/PM format',
                prefixIcon: const Icon(Icons.logout),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Amenities', style: TextStyle(fontWeight: FontWeight.bold)),
        Wrap(
          spacing: 8,
          children: ['WiFi', 'Breakfast', 'Pool', 'Parking'].map((amenity) {
            final isAdded = _hotelAmenities.contains(amenity);
            return FilterChip(
              label: Text(amenity),
              selected: isAdded,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _hotelAmenities.add(amenity);
                  } else {
                    _hotelAmenities.remove(amenity);
                  }
                });
              },
              selectedColor: AppColors.primary.withAlpha(50),
              checkmarkColor: AppColors.primary,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildHomeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Home Details'),
        const SizedBox(height: 16),
        AppDropdown<String>(
          label: 'Home Type *',
          value: _homeType,
          items: [
            'Villa',
            'House',
            'Guest House',
          ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _homeType = val),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _bedroomsController,
                label: 'Bedrooms *',
                hint: 'e.g. 3',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                controller: _bathroomsController,
                label: 'Bathrooms *',
                hint: 'e.g. 2',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _maxGuestsController,
          label: 'Max Guests *',
          hint: 'e.g. 6',
          keyboardType: TextInputType.number,
          prefixIcon: const Icon(Icons.group_outlined),
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Furnished'),
          value: _isFurnished,
          onChanged: (val) => setState(() => _isFurnished = val),
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildApartmentFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Apartment Details'),
        const SizedBox(height: 16),
        AppDropdown<String>(
          label: 'Apartment Type *',
          value: _apartmentType,
          items: [
            'Studio',
            '1BHK',
            '2BHK',
            '3BHK',
          ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _apartmentType = val),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _floorNumberController,
                label: 'Floor Number',
                hint: 'e.g. 5',
                keyboardType: TextInputType.number,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppTextField(
                controller: _aptRoomsController,
                label: 'Number of Rooms *',
                hint: 'e.g. 3',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        CheckboxListTile(
          title: const Text('Elevator Available'),
          value: _hasElevator,
          onChanged: (val) => setState(() => _hasElevator = val!),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        CheckboxListTile(
          title: const Text('Parking Available'),
          value: _hasParking,
          onChanged: (val) => setState(() => _hasParking = val!),
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          controlAffinity: ListTileControlAffinity.leading,
        ),
      ],
    );
  }

  Widget _buildTransportFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Vehicle Details'),
        const SizedBox(height: 16),
        AppDropdown<String>(
          label: 'Vehicle Type *',
          value: _vehicleType,
          items: [
            'Car',
            'Bus',
            'Van',
            'SUV',
          ].map((t) => DropdownMenuItem(value: t, child: Text(t))).toList(),
          onChanged: (val) => setState(() => _vehicleType = val),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: AppDropdown<String>(
                label: 'Transmission *',
                value: _transmission,
                items: ['Manual', 'Automatic']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _transmission = val),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: AppDropdown<String>(
                label: 'Fuel Type *',
                value: _fuelType,
                items: ['Petrol', 'Diesel', 'Electric', 'Hybrid']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setState(() => _fuelType = val),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          title: const Text('Driver Included'),
          value: _driverIncluded,
          onChanged: (val) => setState(() => _driverIncluded = val),
          contentPadding: EdgeInsets.zero,
          activeThumbColor: AppColors.primary,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _pickupLocationController,
          label: 'Pickup Location *',
          hint: 'Enter pickup location',
          prefixIcon: const Icon(Icons.location_on),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: _dropoffLocationController,
          label: 'Drop-off Location *',
          hint: 'Enter drop-off location',
          prefixIcon: const Icon(Icons.location_on_outlined),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Description'),
        const SizedBox(height: 16),
        AppTextField(
          controller: _descriptionController,
          label: 'Service Description *',
          hint: 'Detailed description of what you offer...',
          maxLines: 5,
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Description is required';
            }
            if (val.length < 30) {
              return 'Must be at least 30 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Service Images'),
        const Text('Add up to 5 images.', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 16),
        _buildImageGrid(),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Status'),
        const SizedBox(height: 16),
        AppDropdown<ServiceStatus>(
          label: 'Availability Status',
          value: _status,
          items: [
            DropdownMenuItem(
              value: ServiceStatus.draft,
              child: _buildStatusChip(ServiceStatus.draft),
            ),
            DropdownMenuItem(
              value: ServiceStatus.active,
              child: _buildStatusChip(ServiceStatus.active),
            ),
            DropdownMenuItem(
              value: ServiceStatus.inactive,
              child: _buildStatusChip(ServiceStatus.inactive),
            ),
          ],
          onChanged: (val) => setState(() => _status = val!),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    final isEditing = widget.serviceId != null;
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              if (await _onWillPop() && context.mounted) {
                context.pop();
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _saveService,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(isEditing ? 'Update Service' : 'Save Service'),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const Divider(),
      ],
    );
  }

  Widget _buildStatusChip(ServiceStatus status) {
    Color color;
    switch (status) {
      case ServiceStatus.active:
        color = Colors.green;
        break;
      case ServiceStatus.inactive:
        color = Colors.grey;
        break;
      case ServiceStatus.draft:
        color = Colors.orange;
        break;
      default:
        color = Colors.blue;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.name.toUpperCase(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1,
      ),
      itemCount: _images.length + 1,
      itemBuilder: (context, index) {
        if (index == _images.length) {
          // Add button
          return InkWell(
            onTap: _pickImage,
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grey,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey[100],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, color: AppColors.primary),
                    SizedBox(height: 4),
                    Text('Upload', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ),
          );
        }

        final imagePath = _images[index];
        final isNetwork =
            imagePath.startsWith('http') ||
            imagePath.startsWith('blob:') ||
            kIsWeb;

        return Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: isNetwork
                  ? Image.network(
                      imagePath,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                    )
                  : Image.file(
                      io.File(imagePath),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, o, s) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: Colors.black.withAlpha((0.5 * 255).round()),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.close, size: 16, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      _images.removeAt(index);
                    });
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 100,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.grey.withAlpha(50),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withAlpha(50)
                  : Colors.black.withAlpha(10),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  size: 32,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
                if (isSelected)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: AppColors.primary,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: isSelected ? Colors.white : AppColors.dark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
