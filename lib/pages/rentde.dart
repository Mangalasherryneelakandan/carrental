import 'package:flutter/material.dart'; // Remove Firestore import

class RentalDetailsPage extends StatelessWidget {
  final String rentalId;
  final String vehicleId;
  final String customerId;
  final double totalAmount;

  const RentalDetailsPage({
    Key? key,
    required this.rentalId,
    required this.vehicleId,
    required this.customerId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rental Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 20),
                Text('Rental ID: $rentalId', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Customer ID: $customerId', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Vehicle ID: $vehicleId', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Total Amount: ₹${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
