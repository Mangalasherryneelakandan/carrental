import 'package:car_rental/pages/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart'; // Make sure to import your firebase_options.dart file
 // Import your MyHomePage widget

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Rental App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(), // Use MyHomePage as the home widget
    );
  }
}
