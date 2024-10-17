import 'package:car_rental/pages/booked.dart';
import 'package:car_rental/pages/view_vehicles.dart'; // Import the booked vehicles page
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity, // Ensure the container fills the width
        height: double.infinity, // Ensure the container fills the height
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/lamborghini murcielago 2560x1440.jpg'), // Background image
            fit: BoxFit.cover, // Cover the entire container
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Title and description about Desai Rentals
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Welcome to Desai Rentals',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.tealAccent[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Your one-stop solution for renting high-quality vehicles at affordable rates.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Explore our diverse fleet and find the perfect ride for your needs.',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              // Rent a Vehicle button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleListPage(), // View vehicles page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: const Text('Rent a Vehicle'),
              ),
              const SizedBox(height: 20), // Space between buttons
              // View Booked Vehicles button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookedVehiclesPage(), // View booked vehicles page
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.tealAccent[700], // Button color
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: const Text('View Booked Vehicles'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
