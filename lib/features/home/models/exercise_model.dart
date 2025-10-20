import 'package:equatable/equatable.dart';

/// Exercise model representing a single exercise in a workout
class ExerciseModel extends Equatable {
  final String id;
  final String name;
  final String assetUrl;
  final String gifAssetUrl;
  final String equipment;

  const ExerciseModel({
    required this.id,
    required this.name,
    required this.assetUrl,
    required this.gifAssetUrl,
    required this.equipment,
  });

  /// Create from JSON
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: json['name'] ?? '',
      assetUrl: json['asset_url'] ?? '',
      gifAssetUrl: json['gif_asset_url'] ?? '',
      equipment: json['equipment'] ?? '',
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'asset_url': assetUrl,
      'gif_asset_url': gifAssetUrl,
      'equipment': equipment,
    };
  }

  /// Copy with method for immutability
  ExerciseModel copyWith({
    String? id,
    String? name,
    String? assetUrl,
    String? gifAssetUrl,
    String? equipment,
  }) {
    return ExerciseModel(
      id: id ?? this.id,
      name: name ?? this.name,
      assetUrl: assetUrl ?? this.assetUrl,
      gifAssetUrl: gifAssetUrl ?? this.gifAssetUrl,
      equipment: equipment ?? this.equipment,
    );
  }

  @override
  List<Object?> get props => [id, name, assetUrl, gifAssetUrl, equipment];
}

