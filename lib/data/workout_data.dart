import 'package:applogin/data/have_database.dart';
import 'package:applogin/models/exercise.dart';
import 'package:applogin/models/workout.dart';
import 'package:flutter/material.dart';


class WorkoutData extends ChangeNotifier {
  final db = HiveDatabase();

  /*

  WORKOUT DATA STRUCTURE

  - This overall list contains the different workouts
  - Each workout has and name, and list of exercises

  */

  List<Workout> workoutList = [
    // default workout
    Workout(
      name: "Entrenamientos parte superior", 
      exercises: [
        Exercise(
          name: "Flexiones de biceps", 
          weight: "10", 
          reps: "10", 
          sets: "3",
        ),
      ],
    ),
    Workout(
      name: "Entrenamientos parte inferior", 
      exercises: [
        Exercise(
          name: "Sentadillas", 
          weight: "10", 
          reps: "10", 
          sets: "3",
        ),
      ],
    ),
  ];

  // if there are workouts already in database, then get that workout list, 
  void initalizeWorkoutList() {
    if (db.previousDataExists()) {
      workoutList = db.readFromDatabase();
    } 
    //otherwise use default workouts
    else {
      db.saveToDatabase(workoutList);
    }
  }

  // get  the list workouts
  List<Workout> getWorkoutList() {
    return workoutList;
  }

  // get length of a given workout
  int numberofExercisesInWorkout(String workoutName) {
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    return relevantWorkout.exercises.length;
  }

  // add a workout
  void addWorkout(String name){
    //add a new workout with a blank list of exercise
    workoutList.add(Workout(name: name, exercises: []));

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  // add an exercise to a workout
  void addExcercise(String workoutName, String exerciseName, String weight, 
  String reps, String sets){
  //find the relevant workout
  Workout relevantWorkout = getRelevantWorkout(workoutName);

    relevantWorkout.exercises.add(
      Exercise(
      name: exerciseName, 
      weight: weight, 
      reps: reps, 
      sets: sets,
      ),
    );

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  // check off exercise
  void checkoffExercise(String workoutName, String exerciseName){
    //find the relevant workout and relevant exercise in that workout
    Exercise relevantExercise = getRelevantExercise(workoutName, exerciseName);

    //check off boolean to show user completed the exercise
    relevantExercise.isCompleted = !relevantExercise.isCompleted;

    notifyListeners();
    // save to database
    db.saveToDatabase(workoutList);
  }

  //return relevant workout object, given a workout name
  Workout getRelevantWorkout(String workoutName) {
    Workout relevantWorkout = 
        workoutList.firstWhere((workout) => workout.name == workoutName);

    return relevantWorkout;
  }

  //return relevant exercise object, given a workout name + excercise name 
  Exercise getRelevantExercise(String workoutName, String exerciseName) {
    //find relevant workout first
    Workout relevantWorkout = getRelevantWorkout(workoutName);

    //the find the relevant excercise in that workout
    Exercise relevantExercise = relevantWorkout.exercises
        .firstWhere((exercise) => exercise.name == exerciseName);

    return relevantExercise;
  }
}
