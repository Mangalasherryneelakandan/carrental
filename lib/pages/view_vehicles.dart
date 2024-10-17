import 'package:car_rental/pages/vehidetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Vehicles'),
        backgroundColor: Colors.blueAccent, // Light mode app bar
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('rental')
            .where('available', isEqualTo: 1) // Only display vehicles where available == 1
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No vehicles available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vehicleData = snapshot.data!.docs[index];
              final documentId = vehicleData.id;
              final vehicleName = vehicleData['name'] ?? 'Unknown';
              final imageUrls = vehicleData['imageUrls'] ?? [];
              final rentAmount = vehicleData['rentAmount'] ?? 0.0;
              final description = vehicleData['description'] ?? 'No description available';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailPage(vehicleId: documentId),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                  child: Card(
                    color: Colors.white, // Light mode card background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Vehicle Image on the left
                          Container(
                            width: 100, // Fixed width for the image
                            height: 100, // Fixed height for the image
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: imageUrls.isNotEmpty
                                    ? NetworkImage(imageUrls[0])
                                    : const AssetImage('assets/images/no_image.png') as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15), // Space between image and details

                          // Vehicle Details on the right
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  vehicleName,
                                  style: const TextStyle(
                                    color: Colors.black87, // Light mode text color
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Rent: ₹$rentAmount/day',
                                  style: const TextStyle(
                                    color: Colors.blueAccent, // Accent color for rent price
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    color: Colors.black54, // Description text color
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      backgroundColor: Colors.grey[100], // Light mode background color
    );
  }
}
