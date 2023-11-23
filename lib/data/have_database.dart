import 'package:applogin/datetime/date_time.dart';
import 'package:applogin/models/exercise.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/workout.dart';

class HiveDatabase {
  // reference our hive box
  final _mybox = Hive.box("Workout_database1");

  // check if there is already data stored, if not, record the star date
  bool previousDataExists() {
    if (_mybox.isEmpty) {
      print("los datos anteriores no existen");
      _mybox.put("START_DATE", todaysDateYYYYMMDD());
      return false;
    } else {
      print("los datos anteriores si existen");
      return true;
    }
  }

  // return star date as yyyymmdd
  String getStarDate(){
    return _mybox.get("START_DATE");
  }

  // write data
  void saveToDatabase(List<Workout> workouts){
    // convert workout objects into list of strings so that we can save in hive
    final workoutList = convertObjectToWorkoutList(workouts);
    final exerciseList = convertObjectToExerciseList(workouts);

    /*

    check if any exercises have been done
    we will put a 0 or 1 for each yyyymmdd

    */

    if(excerciseCompleted(workouts)){
      _mybox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 1);
    } else {
      _mybox.put("COMPLETION_STATUS_${todaysDateYYYYMMDD()}", 0);
    }

    //save into have
    _mybox.put("WORKOUTS", workoutList);
    _mybox.put("EXERCISES", exerciseList);
  }

  // read data, and return a list of workouts
  List<Workout> readFromDatabase() {
    List<Workout> mySavedWorkouts = [];

    List<String> workoutNames = _mybox.get("WORKOUTS");
    final exerciseDetails = _mybox.get("EXERCISES");

    // Create Workout objects
    for (int i=0; i < workoutNames.length; i++) {
      //each  workout can have multiple exercises
      List<Exercise> exerciseInEachWorkout = [];

      for (int j=0; j< exerciseDetails[i].length; j++) {
        // so add each exercise into a list 
        exerciseInEachWorkout.add(
          Exercise(
            name: exerciseDetails[i][j][0], 
            weight: exerciseDetails[i][j][1], 
            reps: exerciseDetails[i][j][2], 
            sets: exerciseDetails[i][j][3],
            isCompleted: exerciseDetails[i][j][4] == "true" ? true : false,
          ),
        );
      }

      // create individual workout
      Workout workout =
        Workout(name: workoutNames[i], exercises: exerciseInEachWorkout);

        // add individual workout to overall list
        mySavedWorkouts.add(workout);
    }

    return mySavedWorkouts;
  }

  // check if any exercises have been done
  bool excerciseCompleted(List<Workout> workouts) {
    // go thru each workout
    for (var workout in workouts) {
      // go thru each exercise in workout
      for (var exercise in workout.exercises) {
        if (exercise.isCompleted) {
          return true;
        }
      }
    }
    return false;
  }

  // return completion status of a given date yyyymmdd
  int getCompletionStatus(String yyyymmdd) {
    // returns 0 or 1, if null the return 0
    int completionStatus = _mybox.get("COMPLETION_STATUS_$yyyymmdd") ?? 0;
    return completionStatus;
  }
}

  // coverts workout objects into a list
  List<String> convertObjectToWorkoutList(List<Workout> workouts) {
    List<String> workoutList = [
      // eg. [ upperbody, lowerbody ]
    ];

    for (int i = 0; i < workouts.length; i++) {
      // in each workout, add the name, followed by lists of exercises
      workoutList.add(
        workouts[i].name,
      );
    }

    return workoutList;
  }

  // converts the exercises in a workout object into a list of strings
  List<List<List<String>>> convertObjectToExerciseList(List<Workout> workouts){
    List<List<List<String>>> excerciseList = [
      /*

        [

          Upper Body
          [ [biceps, 10kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ],

          Lower Body
          [ [squats, 25kg, 10reps, 3sets], [legraise, 30kg, 10reps, 3sets], [calf, 10kg, 10reps, 3sets] ],

        ]

        */
    ];

    // go through each workout
    for (int i = 0; i < workouts.length; i++) {
      //get exercises from each workout
      List<Exercise> exercisesInWorkout = workouts[i].exercises;

      List<List<String>> individualWorkout = [
        //Upper Body
        //[ [biceps, 10kg, 10reps, 3sets], [triceps, 20kg, 10reps, 3sets] ],
      ];

      //go through each exercise in exerciseList
      for (int j = 0; j < exercisesInWorkout.length; j++) {
        List<String> individualExercise = [
          //[biceps, 10kg, 10reps, 3sets]
        ];
        individualExercise.addAll(
          [
            exercisesInWorkout[j].name,
            exercisesInWorkout[j].weight,
            exercisesInWorkout[j].reps,
            exercisesInWorkout[j].sets,
            exercisesInWorkout[j].isCompleted.toString(),
          ],
        );
        individualWorkout.add(individualExercise);
      }

      excerciseList.add(individualWorkout);
    }

    return excerciseList;
  }
