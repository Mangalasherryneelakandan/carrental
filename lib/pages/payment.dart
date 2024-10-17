import 'package:car_rental/pages/rentde.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentConfirmationPage extends StatefulWidget {
  final String customerId;
  final String vehicleId;
  final double totalAmount;

  const PaymentConfirmationPage({
    Key? key,
    required this.customerId,
    required this.vehicleId,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _PaymentConfirmationPageState createState() => _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  final TextEditingController amountController = TextEditingController();
  String errorMessage = '';

  Future<void> confirmPayment(BuildContext context) async {
    double? enteredAmount = double.tryParse(amountController.text);

    // Validate the entered amount
    if (enteredAmount == null || enteredAmount != widget.totalAmount) {
      setState(() {
        errorMessage = 'Please enter the correct total amount to confirm payment.';
      });
      return;
    }

    try {
      // Add payment details to the 'payment' collection
      DocumentReference paymentRef = await FirebaseFirestore.instance.collection('payment').add({
        'customerId': widget.customerId,
        'vehicleId': widget.vehicleId,
        'totalAmount': widget.totalAmount,
        'paymentStatus': 'Confirmed',
        'paymentDate': DateTime.now(),
      });

      // Update vehicle availability in the 'rental' collection
      await FirebaseFirestore.instance
          .collection('rental')
          .doc(widget.vehicleId)
          .update({'available': false});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment confirmed successfully!')),
      );

      // Navigate to RentalDetailsPage with payment details
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => RentalDetailsPage(
            rentalId: paymentRef.id,
            vehicleId: widget.vehicleId,
            customerId: widget.customerId,
            totalAmount: widget.totalAmount,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming payment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
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
                  'Payment Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
                ),
                const SizedBox(height: 20),
                Text('Customer ID: ${widget.customerId}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Vehicle ID: ${widget.vehicleId}', style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                Text('Total Amount: ₹${widget.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    labelText: 'Enter Total Amount',
                    errorText: errorMessage.isNotEmpty ? errorMessage : null,
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: () => confirmPayment(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
