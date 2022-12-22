import 'package:FitStack/app/models/muscle/muscle_model.dart';
import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    Key? key,
    required this.totalValue,
    required this.partialValue,
    required this.muscle,
    required this.rawMuscleList,
    required this.muscleColorList,
  }) : super(key: key);
  final double totalValue;
  final double partialValue;
  final Muscle muscle;
  final List<Muscle> rawMuscleList;
  final List<Color> muscleColorList;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final List<Path> paths = [];
    for (final rawMuscle in rawMuscleList) {
      if (muscle.group == rawMuscle.group) {
        paths.add(Path.from(rawMuscle.svgPath!));
      }
    }

    //color based on recoveryValue
    final recoveryValue = now.difference(muscle.updatedAt!).inHours < 72 ? (now.difference(muscle.updatedAt!).inHours / 72) : 1;
    final barColor = muscleColorList[recoveryValue < .5
        ? 0
        : recoveryValue < .75
            ? 1
            : 2];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * .64,
                child: ListTile(
                  dense: true,
                  title: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        muscle.group.name,
                        style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${now.difference(muscle.updatedAt!).inHours < 72 ? (now.difference(muscle.updatedAt!).inHours / 72 * 100).toInt() : 100}%',
                        style: TextStyle(color: barColor, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      const SizedBox(height: 3),
                    ],
                  ),
                  subtitle: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: SizedBox(
                      height: 6,
                      width: double.infinity,
                      child: LinearProgressIndicator(
                        backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(.1),
                        color: barColor,
                        value: recoveryValue.toDouble(),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5),
            ],
          ),
        ],
      ),
    );
  }
}
