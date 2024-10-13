import 'package:car_rental/pages/vehidetail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VehicleListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rental').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No vehicles available.'));
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Number of columns
              childAspectRatio: 1, // Adjust to change the block size
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final vehicleData = snapshot.data!.docs[index];
              final documentId = vehicleData.id; // Use Firestore document ID
              final vehicleName = vehicleData['name']; // Assuming 'name' is of type String
              final imageUrl = vehicleData['imageUrl']; // Assuming 'imageUrl' is a String

              return GestureDetector(
                onTap: () {
                  // Navigate to detail page when a block is clicked
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VehicleDetailPage(
                        vehicleId: documentId, // Pass the document ID
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Vehicle Name: $vehicleName',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        imageUrl != null && imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl, // Display the image using the URL
                                fit: BoxFit.cover, // Fit the image to cover the area
                              )
                            : Text('No image available'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
