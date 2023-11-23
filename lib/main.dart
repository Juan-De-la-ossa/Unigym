import 'package:applogin/data/workout_data.dart';
import 'package:applogin/pages/auth_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';


void main() async {
  // initalize hive
  await Hive.initFlutter();

  // open a hive box
  await Hive.openBox("Workout_database1");

  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => WorkoutData(),
      child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
      ),
      );
  }
}