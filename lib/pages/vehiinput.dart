import 'package:car_rental/pages/booked.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:html' as html;

class VehicleInputPage extends StatefulWidget {
  @override
  _VehicleInputPageState createState() => _VehicleInputPageState();
}

class _VehicleInputPageState extends State<VehicleInputPage> {
  final TextEditingController _vehicleIdController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  String? _imageUrl;

  Future<void> _addVehicle() async {
    if (_vehicleIdController.text.isNotEmpty &&
        _vehicleNameController.text.isNotEmpty) {
      FirebaseFirestore.instance.collection('rental').add({
        'id': int.parse(_vehicleIdController.text),
        'name': _vehicleNameController.text,
        'imageUrl': _imageUrl ?? ''
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Vehicle added successfully')),
      );
    }
  }

  Future<void> _pickImage() async {
    final html.FileUploadInputElement uploadInput =
        html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) async {
      final file = uploadInput.files?.first;
      if (file != null) {
        final reader = html.FileReader();
        reader.readAsDataUrl(file);

        reader.onLoadEnd.listen((e) async {
          setState(() {
            _imageUrl = reader.result as String?;
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
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                TextField(
                  controller: _vehicleIdController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Vehicle ID',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _vehicleNameController,
                  decoration: InputDecoration(
                    labelText: 'Vehicle Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: Icon(Icons.image, color: Colors.white),
                  label: Text(
                    'Add Image',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow[700], // Button color
                  ),
                ),
                SizedBox(height: 20),
                _imageUrl != null
                    ? Image.network(_imageUrl!)
                    : Text('No image selected'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addVehicle,
                  child: Text('Submit Vehicle'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 20), // Add spacing before the next button
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookedVehiclesPage()), // Navigate to booked vehicles page
                      );
                    },
                    child: Text('View Booked Vehicles'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.green, // Customize button color as desired
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
