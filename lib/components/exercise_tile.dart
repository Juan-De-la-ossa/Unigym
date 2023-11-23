import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget {
  final String excerciseName;
  final String weight;
  final String reps;
  final String sets;
  final bool isCompleted;
  void Function(bool?)? onCheckBoxChanged;

  ExerciseTile({
    super.key,
    required this.excerciseName,
    required this.weight,
    required this.reps,
    required this.sets,
    required this.isCompleted,
    required this.onCheckBoxChanged,
    });

  @override
  Widget build(BuildContext context) {
    return Container(
            color: Colors.grey[200],
            child: ListTile(
              title: Text(
                excerciseName,
              ),
              subtitle: Row(
                children: [
                  // weight
                  Chip(
                    label: Text(
                      "${weight}kg",
                    ),
                  ),
          
                  // reps
                  Chip(
                    label: Text(
                      "$reps repeticiones",
                    ),
                  ),
          
                  // sets
                  Chip(
                    label: Text(
                      "$sets series",
                    ),
                  )
                ],
              ), trailing: Checkbox(
                value: isCompleted,
                onChanged: (value) => onCheckBoxChanged!(value),
              ),
            ),
          );
  }
}