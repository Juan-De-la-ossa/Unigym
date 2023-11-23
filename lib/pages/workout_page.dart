import 'package:applogin/components/exercise_tile.dart';
import 'package:applogin/data/workout_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WorkoutPage extends StatefulWidget {
  final String workoutName;
  const WorkoutPage({super.key, required this.workoutName});

  @override
  State<WorkoutPage> createState() => _WorkoutPageState();
}

class _WorkoutPageState extends State<WorkoutPage> {

  //on checkbox was tapped
  void onCheckBoxChanged(String workoutName, String excerciseName) {
    Provider.of<WorkoutData>(context, listen: false)
    .checkoffExercise(workoutName, excerciseName);
  }

  //text controllers
  final exerciseNameController = TextEditingController();
  final weightController = TextEditingController();
  final repsController = TextEditingController();
  final setsController = TextEditingController();

  // create a new exercise
  void createNewExercise() {
    showDialog(
      context: context, 
      builder:(context) => AlertDialog(
        title: Text('Agregar un nuevo ejercicio'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // exercise name
            TextField(
              controller: exerciseNameController,
            ),

            // weight
            TextField(
              controller: weightController,
            ),

            // reps
            TextField(
              controller: repsController,
            ),

            // sets
            TextField(
              controller: setsController,
            ),
          ],
        ),
        actions: [
          //save button
            MaterialButton(
              onPressed: save,
              child: Text("Guardar"),
            ),

            //cancel button
            MaterialButton(
              onPressed: cancel,
              child: Text("cancelar"),
            ),
        ],
      ),
    );
  }

      // save workout
    void save() {
      //get exercise name from text controller
      String newExerciseName = exerciseNameController.text;
      String weight = weightController.text;
      String reps = repsController.text;
      String sets = setsController.text;

      //add exercise to workout
      Provider.of<WorkoutData>(context, listen: false).addExcercise(
        widget.workoutName, 
        newExerciseName, 
        weight, 
        reps, 
        sets
      );

      //pop dialog box
      Navigator.pop(context);
      Clear();
  }

    // cancel
    void cancel() {
      //pop dialog box
      Navigator.pop(context);
      Clear();
    }

    //Clear controllers
    void Clear() {
      exerciseNameController.clear();
      weightController.clear();
      repsController.clear();
      setsController.clear();
    }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(title: Text(widget.workoutName)),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewExercise,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.numberofExercisesInWorkout(widget.workoutName),
          itemBuilder: (context, index) => ExerciseTile(
            excerciseName: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .name, 
            weight: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .weight, 
            reps: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .reps, 
            sets: value
                  .getRelevantWorkout(widget.workoutName)
                  .exercises[index]
                  .sets, 
            isCompleted: value
            .getRelevantWorkout(widget.workoutName)
            .exercises[index]
            .isCompleted,
            onCheckBoxChanged: (val) => onCheckBoxChanged(
                widget.workoutName,
                value
                    .getRelevantWorkout(widget.workoutName)
                    .exercises[index]
                    .name,
                ),
          ),
        ),
      ),
    );
  }
}
