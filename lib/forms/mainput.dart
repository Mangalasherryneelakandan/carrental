import 'package:flutter/material.dart';

class InputBox extends StatefulWidget {
  const InputBox({super.key});

  @override
  _InputBoxState createState() => _InputBoxState();
}

class _InputBoxState extends State<InputBox> {
  String inputText = ''; // To store user input
  String selectedOption = 'two-wheeler'; // To store selected radio button
  String? seatingOption; // To store selected seating option
  double sliderValue = 4000; // To store slider value

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Align to middle-left
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0), // Optional padding for spacing
        child: Container(
          width: 300, // Box width
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: const Color(0xFFD3A6B6), // Dusty rose color
            border: Border.all(color: Colors.grey), // Add border for the box
            borderRadius: BorderRadius.circular(10), // Rounded corners
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust size based on content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Input Box with Search Icon
              TextField(
                onChanged: (text) {
                  setState(() {
                    inputText = text;
                  });
                },
                style: const TextStyle(color: Colors.white), // Change text color to white
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Enter your name',
                  hintText: 'Enter a search term',
                  hintStyle: const TextStyle(color: Colors.white70), // Optional: Change hint text color
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search, color: Colors.white), // Search icon color
                    onPressed: () {
                      // Handle search action here
                      print('Search button pressed for: $inputText');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You entered: $inputText',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),

              // Radio Buttons for Options using Icons
              const SizedBox(height: 20),
              const Text('Choose an option:', style: TextStyle(fontSize: 16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Space between radio options
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'two-wheeler';
                        seatingOption = null; // Reset seating option when changing the main option
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.motorcycle, // Use motorcycle icon
                          color: selectedOption == 'two-wheeler' ? Colors.blue : Colors.white,
                          size: 50,
                        ),
                        const Text('Two-wheeler', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedOption = 'four-wheeler';
                        seatingOption = null; // Reset seating option when changing the main option
                      });
                    },
                    child: Column(
                      children: [
                        Icon(
                          Icons.directions_car, // Use car icon
                          color: selectedOption == 'four-wheeler' ? Colors.blue : Colors.white,
                          size: 50,
                        ),
                        const Text('Four-wheeler', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              Text('Selected: $selectedOption'),

              // Conditionally Render Seating Options if Option 2 is selected
              if (selectedOption == 'four-wheeler') ...[
                const SizedBox(height: 20),
                const Text('Select seating capacity:', style: TextStyle(fontSize: 16)),
                Row(
                  children: <Widget>[
                    Radio<String>(
                      value: '5-seater',
                      groupValue: seatingOption,
                      onChanged: (String? value) {
                        setState(() {
                          seatingOption = value!;
                        });
                      },
                    ),
                    const Text('5-seater', style: TextStyle(color: Colors.white)),
                    Radio<String>(
                      value: '7-seater',
                      groupValue: seatingOption,
                      onChanged: (String? value) {
                        setState(() {
                          seatingOption = value!;
                        });
                      },
                    ),
                    const Text('7-seater', style: TextStyle(color: Colors.white)),
                  ],
                ),
                if (seatingOption != null) // Display selected seating option
                  Text('Selected seating: $seatingOption', style: const TextStyle(color: Colors.white)),
              ],

              // Slider
              const SizedBox(height: 20),
              Text(
                'Adjust value: ${sliderValue.round()}',
                style: const TextStyle(fontSize: 16, color: Colors.white),
              ),
              Slider(
                value: sliderValue,
                min: 2000,
                max: 8000,
                divisions: 60, // Total divisions for increments of 100 (6000/100)
                label: sliderValue.round().toString(),
                onChanged: (double value) {
                  setState(() {
                    sliderValue = value;
                  });
                },
              ),

              // Search Button at the bottom
              const SizedBox(height: 20), // Space before button
              Align(
                alignment: Alignment.bottomCenter, // Align button at the bottom
                child: ElevatedButton(
                  onPressed: () {
                    // Perform search action here
                    print('Search button pressed for: $inputText');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Button color
                  ),
                  child: const Text('Search', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
