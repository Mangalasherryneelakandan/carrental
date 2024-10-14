import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental/pages/cust.dart';

class VehicleDetailPage extends StatelessWidget {
  final String vehicleId;

  const VehicleDetailPage({super.key, required this.vehicleId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
        backgroundColor: Colors.black54,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('rental').doc(vehicleId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: Text('Vehicle not found.', style: TextStyle(color: Colors.white)));
          }

          // Extract vehicle details
          var vehicleDetails = snapshot.data!.data() as Map<String, dynamic>;
          String vehicleName = vehicleDetails['name'] ?? 'Unknown';
          List<dynamic> imageUrls = vehicleDetails['imageUrls'] ?? [];
          double rentAmount = vehicleDetails['rentAmount'] ?? 0.0;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Vehicle Image Carousel
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return imageUrls.isNotEmpty
                          ? Image.network(
                              imageUrls[index],
                              fit: BoxFit.cover,
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Center(child: Text('No Image Available')),
                            );
                    },
                  ),
                ),
                const SizedBox(height: 16), // Space between image and details
                // Vehicle Details
                Text(
                  'Vehicle Name: $vehicleName',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rent: ₹$rentAmount per day', // Display rent with rupee symbol
                  style: const TextStyle(fontSize: 20, color: Colors.greenAccent),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerInputPage(vehicleId: vehicleId),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                  child: const Text('Book This Vehicle'),
                ),
              ],
            ),
          );
        },
      ),
      backgroundColor: Colors.black87,
    );
  }
}
