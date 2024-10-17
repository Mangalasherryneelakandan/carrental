import 'package:car_rental/pages/homepage.dart';
import 'package:flutter/material.dart';
// Replace with the actual path to your homepage file

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
        backgroundColor: Colors.teal[800], // Darker shade for AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.grey[850], // Dark background for the card
          elevation: 8,
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
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.tealAccent, // Bright color for visibility
                  ),
                ),
                const SizedBox(height: 20),
                _buildDetailRow('Rental ID:', rentalId),
                _buildDetailRow('Customer ID:', customerId),
                _buildDetailRow('Vehicle ID:', vehicleId),
                _buildDetailRow('Total Amount:', '₹${totalAmount.toStringAsFixed(2)}', isBold: true),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the homepage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()), // Replace with your actual homepage widget
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Colors.teal, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Home', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: Colors.tealAccent, // Bright color for labels
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: Colors.white, // White text for values
              ),
            ),
          ),
        ],
      ),
    );
  }
}
