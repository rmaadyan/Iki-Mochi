import 'package:hive/hive.dart';

part 'services_model.g.dart';

@HiveType(typeId: 0)
class ServicesModel extends HiveObject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String serviceName;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int price;

  @HiveField(4)
  final DateTime? createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  ServicesModel({
    this.id,
    required this.serviceName,
    required this.description,
    required this.price,
    this.createdAt,
    this.updatedAt,
  });

  /// Create model from Supabase / JSON map
  factory ServicesModel.fromJson(Map<String, dynamic> json) {
    return ServicesModel(
      id: json['id'] is int ? json['id'] as int : (json['id'] != null ? int.tryParse(json['id'].toString()) : null),
      serviceName: json['serviceName'] as String? ?? json['service_name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] is int ? json['price'] as int : int.tryParse((json['price'] ?? '0').toString()) ?? 0,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : (json['createdAt'] != null ? DateTime.tryParse(json['createdAt'].toString()) : null),
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at'].toString()) : (json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null),
    );
  }

  /// Convert full model to JSON (useful to sync/store locally)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'description': description,
      'price': price,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Convert model to payload suitable for inserting to Supabase.
  /// Usually supabase will set `id` and `created_at`, so exclude them here.
  Map<String, dynamic> toJsonForInsert() {
    return {
      'serviceName': serviceName,
      'description': description,
      'price': price,
      // don't include id/created_at/updated_at unless you intend to set them
    };
  }

  /// Optional helper if your Supabase column names differ (map keys)
  Map<String, dynamic> toJsonForUpsert() => toJsonForInsert();
}
