import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 // Ensure this import points to your CustomerInputPage

class VehicleDetailPage extends StatelessWidget {
  final String vehicleId; // Keep the original name

  const VehicleDetailPage({Key? key, required this.vehicleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('rental').doc(vehicleId).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(child: Text('Vehicle not found.'));
          }

          // Extract vehicle details
          var vehicleDetails = snapshot.data!.data() as Map<String, dynamic>;
          String vehicleName = vehicleDetails['name'] ?? 'Unknown';
          String vehicleImage = vehicleDetails['imageUrl'] ?? ''; // Ensure this matches your Firestore field

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // Vehicle Image
                Expanded(
                  flex: 1,
                  child: vehicleImage.isNotEmpty
                      ? Image.network(vehicleImage, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey[300], // Placeholder color
                          child: const Center(child: Text('No Image Available')),
                        ),
                ),
                const SizedBox(width: 16), // Space between image and details
                // Vehicle Details
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Name: $vehicleName',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerInputPage(vehicleId: vehicleId),
                            ),
                          );
                        },
                        child: const Text('Book This Vehicle'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Example of a simple Customer Input Page
class CustomerInputPage extends StatelessWidget {
  final String vehicleId;

  const CustomerInputPage({Key? key, required this.vehicleId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Input')),
      body: Center(
        child: Text('Input details for vehicle ID: $vehicleId'),
      ),
    );
  }
}
