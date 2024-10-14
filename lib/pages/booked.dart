import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookedVehiclesPage extends StatefulWidget {
  const BookedVehiclesPage({super.key});

  @override
  _BookedVehiclesPageState createState() => _BookedVehiclesPageState();
}

class _BookedVehiclesPageState extends State<BookedVehiclesPage> {
  final TextEditingController _phoneController = TextEditingController();
  final List<Map<String, dynamic>> _bookedVehicleDetails = [];
  bool _isLoading = false;

  Future<void> _fetchBookedVehicles() async {
    setState(() {
      _isLoading = true;
      _bookedVehicleDetails.clear();
    });

    String phone = _phoneController.text;

    try {
      // Fetch rented info based on phone number
      QuerySnapshot rentedSnapshot = await FirebaseFirestore.instance
          .collection('rented') // Fetch from 'rented' collection
          .where('phone', isEqualTo: phone) // Match the phone number
          .get();

      if (rentedSnapshot.docs.isNotEmpty) {
        for (var rentedDoc in rentedSnapshot.docs) {
          var rentedData = rentedDoc.data() as Map<String, dynamic>;
          String vehicleId = rentedData['vehicleId'] ?? '';

          // Fetch vehicle details using vehicleId
          if (vehicleId.isNotEmpty) {
            DocumentSnapshot vehicleSnapshot = await FirebaseFirestore.instance
                .collection('rental') // Ensure this is the correct collection for vehicles
                .doc(vehicleId) // Fetch the vehicle using the document ID (vehicleId)
                .get();

            if (vehicleSnapshot.exists) {
              var vehicleData = vehicleSnapshot.data() as Map<String, dynamic>;

              // Combine rented data and vehicle data, including imageUrl
              _bookedVehicleDetails.add({
                'vehicleId': vehicleId,
                'vehicleName': vehicleData['name'] ?? 'Unknown',
                'vehicleImageUrl': vehicleData['imageUrl'] ?? '', // Fetching image URL
                'customerName': rentedData['customerName'] ?? 'Unknown',
                'customerPhone': rentedData['phone'] ?? 'Unknown',
                'startDate': rentedData['startDate']?.toDate(),
                'endDate': rentedData['endDate']?.toDate(),
                'numberOfDays': rentedData['numberOfDays'],
                'totalAmount': rentedData['totalAmount'],
              });
            } else {
              print('Vehicle not found for vehicleId: $vehicleId');
            }
          }
        }
      } else {
        print('No bookings found for this phone number.');
      }
    } catch (e) {
      print('Error fetching booked vehicles: $e');
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
                itemCount: _bookedVehicleDetails.length,
                itemBuilder: (context, index) {
                  var bookingData = _bookedVehicleDetails[index];

                  String vehicleId = bookingData['vehicleId'];
                  String vehicleName = bookingData['vehicleName'];
                  String customerName = bookingData['customerName'];
                  String customerPhone = bookingData['customerPhone'];
                  DateTime? startDate = bookingData['startDate'];
                  DateTime? endDate = bookingData['endDate'];
                  int numberOfDays = bookingData['numberOfDays'];
                  double totalAmount = bookingData['totalAmount'];
                  String vehicleImageUrl = bookingData['vehicleImageUrl'];

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      leading: vehicleImageUrl.isNotEmpty
                          ? Image.network(
                              vehicleImageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Icon(Icons.directions_car), // Placeholder if no image
                      title: Text('Vehicle Name: $vehicleName'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Vehicle ID: $vehicleId'),
                          Text('Customer Name: $customerName'),
                          Text('Customer Phone: $customerPhone'),
                          if (startDate != null)
                            Text('Start Date: ${startDate.toLocal().toString().split(' ')[0]}'),
                          if (endDate != null)
                            Text('End Date: ${endDate.toLocal().toString().split(' ')[0]}'),
                          Text('Number of Days: $numberOfDays'),
                          Text('Total Amount: ₹${totalAmount.toStringAsFixed(2)}'),
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
