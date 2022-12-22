// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:FitStack/app/models/muscle/muscle_recovery_model.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'muscle_model.g.dart';

@JsonSerializable(includeIfNull: true, explicitToJson: true, anyMap: true)
class Muscle extends Equatable {
  @JsonKey(name: 'id')
  final int? id;
  @JsonKey(name: 'action')
  final String? action;
  @JsonKey(name: 'group')
  final MuscleGroup group;
  @JsonKey(name: 'child_muscles')
  final ChildMuscle? child;
  @JsonKey(ignore: true)
  final String? name;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(ignore: true)
  final Path? svgPath;
  @JsonKey(name: 'recovery')
  final MuscleRecovery? recovery;
  const Muscle({
    required this.group,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.recovery,
    this.id,
    this.action,
    this.svgPath,
    this.child,
    this.image,
  });

  @override
  List<Object?> get props => [group, name, image, svgPath, child, recovery, id, action, createdAt, updatedAt];

  Muscle copyWith({
    int? id,
    String? action,
    MuscleGroup? group,
    String? name,
    String? image,
    Path? svgPath,
    ChildMuscle? child,
    MuscleRecovery? recovery,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Muscle(
      id: id ?? this.id,
      action: action ?? this.action,
      child: child ?? this.child,
      group: group ?? this.group,
      name: name ?? this.name,
      image: image ?? this.image,
      svgPath: svgPath ?? this.svgPath,
      recovery: recovery ?? this.recovery,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Muscle.fromJson(Map<String, dynamic> json) => _$MuscleFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleToJson(this);

  //empty factory
  factory Muscle.empty() => const Muscle(
        group: MuscleGroup.Empty,
      );
}

enum MuscleGroup {
  Arms,
  Chest,
  Legs,
  Abdominals,
  Glutes,
  Calves,
  Forearms,
  Traps,
  Neck,
  UpperBack,
  LowerBack,
  HipFlexors,
  Adductors,
  Abductors,
  PlantarFlexors,
  Dorsiflexors,
  Invertors,
  Empty,
}

enum ChildMuscle {
  BicepsBrachii,
  Triceps,
  PectoralisMajor,
  PectoralisMinor,
  Quadriceps,
  Hamstrings,
  RectusAbdominis,
  Obliques,
  GluteusMaximus,
  GluteusMedius,
  GluteusMinimus,
  Gastrocnemius,
  Soleus,
  Flexors,
  Extensors,
  Sternocleidomastoid,
  Splenius,
  Rhomboids,
  LatissimusDorsi,
  ErectorSpinae,
  Iliopsoas,
  RectusFemoris,
  Gracilis,
  AdductorBrevis,
  AdductorLongus,
  GluteusMediusMinimus,
  TensorFasciaeLatae,
  TibialisAnterior,
  TibialisPosterior,
  ExtensorDigitorumLongus,
  FlexorDigitorumLongus,
  Empty,
}

const Map<MuscleGroup, List<String>> muscleMap = {
  MuscleGroup.Chest: ['Pectoralis Major', 'Pectoralis Minor'],
  MuscleGroup.Arms: ['Biceps Brachii', 'Triceps'],
  MuscleGroup.Legs: ['Quadriceps', 'Hamstrings'],
  MuscleGroup.Abdominals: ['Rectus Abdominis', 'Obliques'],
  MuscleGroup.Glutes: ['Gluteus Maximus', 'Gluteus Medius', 'Gluteus Minimus'],
  MuscleGroup.Calves: ['Gastrocnemius', 'Soleus'],
  MuscleGroup.Forearms: ['Flexors', 'Extensors', 'flexor carpi'],
  MuscleGroup.Traps: ['Sternocleidomastoid', 'Splenius'],
  MuscleGroup.Neck: ['Sternocleidomastoid'],
  MuscleGroup.UpperBack: ['Rhomboids', 'Latissimus Dorsi'],
  MuscleGroup.LowerBack: ['Erector Spinae'],
  MuscleGroup.HipFlexors: ['Iliopsoas'],
  MuscleGroup.Adductors: ['Rectus Femoris', 'Gracilis', 'Adductor Brevis', 'Adductor Longus'],
  MuscleGroup.Abductors: ['Gluteus Medius Minimus'],
  MuscleGroup.Dorsiflexors: [],
  MuscleGroup.Invertors: [],
};
