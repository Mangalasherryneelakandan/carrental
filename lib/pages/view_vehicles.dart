import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:car_rental/pages/vehidetail.dart'; // Vehicle detail page import

class VehicleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image that fills the entire screen
          Positioned.fill(
            child: Image.asset(
              'assets/images/black-wallpaper-10.jpg', // Replace with your image
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay to enhance text visibility
          Container(
            color: Colors.black54, // Semi-transparent black overlay
          ),
          // Vehicle list content
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('rental')
                .where('available', isEqualTo: true) // Filter for available vehicles
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No vehicles available.', style: TextStyle(color: Colors.white)));
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        color: Colors.grey[900], // Dark card background
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Vehicle Image on the left
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: imageUrls.isNotEmpty
                                          ? NetworkImage(imageUrls[0])
                                          : const AssetImage('assets/images/no_image.png') as ImageProvider,
                                      fit: BoxFit.cover,
                                    ),
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
                                        color: Colors.white, // Change text color to white for dark theme
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Rent: ₹$rentAmount/day',
                                      style: TextStyle(
                                        color: Colors.tealAccent[400], // Rent price accent color
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white70, // Light grey for description
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
        ],
      ),
      backgroundColor: Colors.black, // Set the background color to black
    );
  }
}
