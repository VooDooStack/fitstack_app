import 'package:FitStack/app/models/muscle/muscle_model.dart';
import 'package:FitStack/app/services/muscle_service.dart';
import 'package:flutter/material.dart';
import 'package:touchable/touchable.dart';

class ExerciseMuscleSelector extends StatelessWidget {
  final List<Muscle> majorMuscles;
  final List<Muscle> minorMuscles;
  final List<Muscle> frontMuscleList;
  final List<Muscle> backMuscleList;
  final Color majorMuscleColor;
  final void Function(LongPressEndDetails, Muscle) onMinorMuscleSelected;
  final void Function(TapUpDetails, Muscle) onMajorMuscleSelected;
  final Color minorMuscleColor;
  final int muscleAnatomyViewRotationIndex;
  final bool? showSelectionChips;
  final double? height;
  final double? width;

  const ExerciseMuscleSelector({
    Key? key,
    required this.majorMuscles,
    required this.minorMuscles,
    required this.frontMuscleList,
    required this.onMinorMuscleSelected,
    required this.majorMuscleColor,
    required this.minorMuscleColor,
    required this.onMajorMuscleSelected,
    required this.muscleAnatomyViewRotationIndex,
    required this.backMuscleList,
    this.showSelectionChips,
    this.height,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (showSelectionChips == true || showSelectionChips == null)
          SizedBox(
            height: 20,
            child: Wrap(
              spacing: 5,
              children: minorMuscles
                  .map(
                    (e) => Chip(
                      backgroundColor: minorMuscleColor,
                      label: Text(
                        e.name ?? '',
                        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  )
                  .followedBy(
                    majorMuscles.map(
                      (e) => Chip(
                        backgroundColor: majorMuscleColor,
                        label: Text(
                          e.name ?? '',
                          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        const SizedBox(height: 20),
        SizedBox(
          width: width ?? MediaQuery.of(context).size.width * .5,
          height: height ?? MediaQuery.of(context).size.height * .5,
          child: CanvasTouchDetector(
            gesturesToOverride: const [GestureType.onTapUp, GestureType.onLongPressEnd],
            builder: (context) => CustomPaint(
              painter: SelectionMusclePainter(
                context: context,
                muscleList: muscleAnatomyViewRotationIndex == 0 ? frontMuscleList : backMuscleList,
                majorMuscleList: majorMuscles,
                minorMuscleList: minorMuscles,
                onTapUp: onMajorMuscleSelected,
                onLongPressEnd: onMinorMuscleSelected,
                majorMuscleColor: majorMuscleColor,
                minorMuscleColor: minorMuscleColor,
                muscleAnatomyViewRotationIndex: muscleAnatomyViewRotationIndex,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
