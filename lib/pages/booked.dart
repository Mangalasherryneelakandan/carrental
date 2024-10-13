import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedVehiclesPage extends StatefulWidget {
  @override
  _BookedVehiclesPageState createState() => _BookedVehiclesPageState();
}

class _BookedVehiclesPageState extends State<BookedVehiclesPage> {
  final TextEditingController _phoneController = TextEditingController();
  List<DocumentSnapshot> _bookedVehicles = [];
  bool _isLoading = false;

  Future<void> _fetchBookedVehicles() async {
    setState(() {
      _isLoading = true;
      _bookedVehicles.clear();
    });

    String phone = _phoneController.text;

    try {
      // Fetch booked vehicles from Firestore where the customer's phone number matches
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('customers') // Assuming you have a collection for bookings
          .where('phone', isEqualTo: phone) // Match the phone number
          .get();

      if (querySnapshot.docs.isEmpty) {
        // Show a message if no vehicles are found
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No bookings found for this phone number.')),
        );
      }

      setState(() {
        _bookedVehicles = querySnapshot.docs; // Store the results
      });
    } catch (e) {
      print('Error fetching booked vehicles: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching booked vehicles: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Stop loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booked Vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Enter Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _fetchBookedVehicles,
              child: const Text('Search'),
            ),
            const SizedBox(height: 20),
            if (_isLoading) CircularProgressIndicator(),
            Expanded(
              child: ListView.builder(
                itemCount: _bookedVehicles.length,
                itemBuilder: (context, index) {
                  var bookingData = _bookedVehicles[index].data() as Map<String, dynamic>;
                  String vehicleId = bookingData['vehicleId'] ?? 'Unknown';
                  String vehicleName = bookingData['vehicleName'] ?? 'Unknown';
                  String customerName = bookingData['customerName'] ?? 'Unknown';
                  String customerPhone = bookingData['phone'] ?? 'Unknown';

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text('Vehicle Name: $vehicleName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vehicle ID: $vehicleId'),
                          Text('Customer Name: $customerName'),
                          Text('Customer Phone: $customerPhone'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
