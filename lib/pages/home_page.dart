import 'package:applogin/data/workout_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'workout_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {

    @override
    void initState() {
      super.initState();
      
      Provider.of<WorkoutData>(context, listen: false).initalizeWorkoutList();
    }

    final User = FirebaseAuth.instance.currentUser!;

    // Sing user out method
void singUserOut() {
  FirebaseAuth.instance.signOut();
}

    //Text controller
    final newWorkoutNameController = TextEditingController();

    //create a new workout
    void createNewWorkout() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Crear nueva rutina"),
          content: TextField(
            controller: newWorkoutNameController,
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

    // go to workout page
    void goToWorkoutPage(String workoutName) {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => WorkoutPage(
            workoutName: workoutName,
          ),
          ));
    }

    // save workout
    void save() {
      //get workout name from text controller
      String newWorkoutName = newWorkoutNameController.text;
      //add workout to workoutdata list
      Provider.of<WorkoutData>(context, listen: false).addWorkout(newWorkoutName);

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
      newWorkoutNameController.clear();
    }

    @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutData>(builder: (context, value, child) => Scaffold(
      appBar: AppBar(
                actions: [
          IconButton(
            onPressed: singUserOut, 
            icon: Icon(Icons.logout),
            )
            ],
        title: const Text('Seguimiento de rutinas'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewWorkout,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: value.getWorkoutList().length,
          itemBuilder: (context, index) => ListTile(
            title: Text(value.getWorkoutList()[index].name),
            trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () => 
                  goToWorkoutPage(value.getWorkoutList()[index].name),
            ),
          ),
        ),
      ),
    );
  }
}

