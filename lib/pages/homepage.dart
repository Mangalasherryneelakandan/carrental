import 'package:car_rental/forms/mainput.dart'; // Your input widget
import 'package:car_rental/needed/slideshow.dart'; // Your slideshow widget
import 'package:flutter/material.dart';
import 'package:car_rental/needed/navbar.dart'; // Your navigation bar

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column( // Use Column to include navigation bar at the top
          children: <Widget>[
            navigationBar(), // Navigation bar at the top
            
            Expanded(
              child: Row( // Use Row to align input box and slideshow horizontally
                children: <Widget>[
                  // Left side: Input Box
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InputBox(), // Your input box widget
                      ),
                    ),
                  ),

                  // Right side: Slideshow
                  SizedBox(
                    width: 300, // Set the width for the slideshow
                    child: SlideshowWidget(), // Your slideshow widget
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
