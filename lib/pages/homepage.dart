import 'package:car_rental/pages/vehiinput.dart';
import 'package:car_rental/pages/view_vehicles.dart';
import 'package:flutter/material.dart';


class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Add the input form
            Expanded(
              child: VehicleInputPage(), // Your vehicle input form
            ),

            // Add a button to go to the view page
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VehicleListPage(), // View page route
                  ),
                );
              },
              child: Text('View Vehicles'),
            ),
          ],
        ),
      ),
    );
  }
}
