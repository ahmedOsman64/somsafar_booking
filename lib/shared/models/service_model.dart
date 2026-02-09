import 'package:flutter/material.dart';

enum ServiceStatus { active, inactive, draft, pendingApproval, blocked }

class Service {
  final String id;
  String title;
  String category;
  double price;
  String location;
  String description;
  ServiceStatus status;
  List<String> images;
  Map<String, dynamic> metadata;

  Service({
    required this.id,
    required this.title,
    required this.category,
    required this.price,
    required this.location,
    required this.description,
    required this.status,
    required this.images,
    this.metadata = const {},
  });

  Color get statusColor {
    switch (status) {
      case ServiceStatus.active:
        return const Color(0xFF27AE60);
      case ServiceStatus.inactive:
        return const Color(0xFF9CA3AF);
      case ServiceStatus.draft:
        return const Color(0xFFF2C94C);
      case ServiceStatus.pendingApproval:
        return const Color(0xFF2F80ED);
      case ServiceStatus.blocked:
        return const Color(0xFFEB5757);
    }
  }

  String get statusLabel {
    // Camel case specific handling
    if (status == ServiceStatus.pendingApproval) return 'Pending';
    return status.name[0].toUpperCase() + status.name.substring(1);
  }

  Service copyWith({
    String? id,
    String? title,
    String? category,
    double? price,
    String? location,
    String? description,
    ServiceStatus? status,
    List<String>? images,
    Map<String, dynamic>? metadata,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      price: price ?? this.price,
      location: location ?? this.location,
      description: description ?? this.description,
      status: status ?? this.status,
      images: images ?? this.images,
      metadata: metadata ?? this.metadata,
    );
  }
}
