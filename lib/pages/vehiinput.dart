import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class VehicleInputPage extends StatefulWidget {
  const VehicleInputPage({super.key});

  @override
  _VehicleInputPageState createState() => _VehicleInputPageState();
}

class _VehicleInputPageState extends State<VehicleInputPage> {
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _rentAmountController = TextEditingController();
  List<String?> _imageUrls = [null, null, null]; // List to store 3 image URLs
  String? _selectedCompany;
  String? _selectedType; // New variable for vehicle type selection

  Future<void> _addVehicle() async {
    if (_vehicleNameController.text.isNotEmpty &&
        _imageUrls.every((url) => url != null && url.isNotEmpty) &&
        _selectedCompany != null &&
        _selectedType != null && // Check if type is selected
        _rentAmountController.text.isNotEmpty) {
      await FirebaseFirestore.instance.collection('rental').add({
        'name': _vehicleNameController.text,
        'imageUrls': _imageUrls, // Store list of image URLs
        'available': true, // Set available to true
        'rentAmount': double.tryParse(_rentAmountController.text) ?? 0.0,
        'company': _selectedCompany, // Add company field
        'type': _selectedType, // Add type field
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle added successfully')),
      );

      // Clear input fields
      _vehicleNameController.clear();
      _rentAmountController.clear();
      _imageUrls = [null, null, null];
      _selectedType = null; // Clear selected type
      setState(() {});
    }
  }

  Future<void> _pickImage(int index) async {
    final html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          setState(() {
            _imageUrls[index] = reader.result as String?;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Vehicle'),
        backgroundColor: Colors.black54,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedCompany,
                  hint: Text('Select Company', style: TextStyle(color: Colors.white)),
                  dropdownColor: Colors.black54,
                  items: <String>[
                    'Toyota',
                    'Honda',
                    'Ford',
                    'BMW',
                    'Mercedes',
                    'Audi',
                    'Volkswagen',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCompany = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),

                // New Dropdown for Vehicle Type
                DropdownButton<String>(
                  value: _selectedType,
                  hint: Text('Select Vehicle Type', style: TextStyle(color: Colors.white)),
                  dropdownColor: Colors.black54,
                  items: <String>[
                    'Sedan',
                    'SUV',
                    'Hatchback',
                    'Truck',
                    'Convertible',
                    'Coupe',
                  ].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                ),

                SizedBox(height: 20),
                TextField(
                  controller: _vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _rentAmountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rent Amount (per day)',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellow),
                    ),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(height: 20),

                // Buttons to upload 3 images
                for (int i = 0; i < 3; i++) ...[
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(i),
                    icon: Icon(Icons.image, color: Colors.white),
                    label: Text(
                      'Add Image ${i + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                    ),
                  ),
                  SizedBox(height: 20),
                  _imageUrls[i] != null
                      ? Text('Image added successfully for Image ${i + 1}', style: TextStyle(color: Colors.green))
                      : Text('No image selected for Image ${i + 1}', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 20),
                ],

                ElevatedButton(
                  onPressed: _addVehicle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: Text('Submit Vehicle'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.black87,
    );
  }
}
