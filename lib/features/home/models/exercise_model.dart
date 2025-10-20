import 'package:equatable/equatable.dart';
import 'exercise_state_model.dart';

class ExerciseModel extends Equatable {
  final String name;
  final String assetUrl;
  final String gifAssetUrl;
  final String equipment;
  final ExerciseStateModel exerciseState;

  const ExerciseModel({
    required this.name,
    required this.assetUrl,
    required this.gifAssetUrl,
    required this.equipment,
    this.exerciseState = const ExerciseStateModel(exerciseIndex: -1),
  });

  /// Create from JSON
  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json['name'] ?? '',
      assetUrl: json['asset_url'] ?? '',
      gifAssetUrl: json['gif_asset_url'] ?? '',
      equipment: json['equipment'] ?? '',
    );
  }

  /// Copy with method for immutability
  ExerciseModel copyWith({
    String? name,
    String? assetUrl,
    String? gifAssetUrl,
    String? equipment,
    ExerciseStateModel? exerciseState,
  }) {
    return ExerciseModel(
      name: name ?? this.name,
      assetUrl: assetUrl ?? this.assetUrl,
      gifAssetUrl: gifAssetUrl ?? this.gifAssetUrl,
      equipment: equipment ?? this.equipment,
      exerciseState: exerciseState ?? this.exerciseState,
    );
  }

  @override
  List<Object?> get props => [name, assetUrl, gifAssetUrl, equipment, exerciseState];
}

