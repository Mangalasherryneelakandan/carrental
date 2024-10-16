import 'package:car_rental/pages/payment.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class CustomerInputPage extends StatefulWidget {
  final String vehicleId;

  const CustomerInputPage({super.key, required this.vehicleId});

  @override
  _CustomerInputPageState createState() => _CustomerInputPageState();
}

class _CustomerInputPageState extends State<CustomerInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;
  int numberOfDays = 0;
  double totalAmount = 0.0;
  double? amountPerDay;

  @override
  void initState() {
    super.initState();
    fetchVehicleData();
  }

  // Fetch the amount from the 'rental' database for the selected vehicle
  Future<void> fetchVehicleData() async {
    try {
      DocumentSnapshot vehicleDoc = await FirebaseFirestore.instance
          .collection('rental')
          .doc(widget.vehicleId)
          .get();

      if (vehicleDoc.exists) {
        setState(() {
          amountPerDay = double.tryParse(vehicleDoc['rentAmount'].toString());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vehicle not found in the rental database.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vehicle details: $e')),
      );
    }
  }

  void calculateTotalAmount() {
    if (startDate != null && endDate != null && amountPerDay != null) {
      setState(() {
        numberOfDays = endDate!.difference(startDate!).inDays;
        if (numberOfDays > 0) {
          totalAmount = numberOfDays * amountPerDay!;
        } else {
          totalAmount = 0.0;
        }
      });
    }
  }

  Future<void> submitData() async {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        startDate == null ||
        endDate == null ||
        amountPerDay == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    try {
      // Create a new customer record in the "rented" collection
      DocumentReference rentedRef = await FirebaseFirestore.instance.collection('rented').add({
        'vehicleId': widget.vehicleId,
        'customerName': nameController.text,
        'phone': phoneController.text,
        'startDate': startDate,
        'endDate': endDate,
        'amountPerDay': amountPerDay,
        'numberOfDays': numberOfDays,
        'totalAmount': totalAmount,
        'paymentStatus': 'Pending', // Initial payment status
      });

      // Navigate to the Payment Confirmation Page after successful submission
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentConfirmationPage(
            customerId: rentedRef.id, // Pass the newly created customerId
            vehicleId: widget.vehicleId,
            totalAmount: totalAmount,
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Input'),
        backgroundColor: Colors.teal[800], // Darker AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 8,
            color: Colors.grey[850], // Dark card background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Customer Name',
                      labelStyle: const TextStyle(color: Colors.teal),
                      filled: true,
                      fillColor: Colors.teal.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white), // Input text color
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      labelStyle: const TextStyle(color: Colors.teal),
                      filled: true,
                      fillColor: Colors.teal.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white), // Input text color
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Not Selected'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white), // Text color
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          startDate = picked;
                        });
                        calculateTotalAmount(); // Recalculate total when start date changes
                      }
                    },
                    child: const Text('Select Start Date', style: TextStyle(color: Colors.teal)),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Not Selected'}',
                    style: const TextStyle(fontSize: 16, color: Colors.white), // Text color
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null) {
                        setState(() {
                          endDate = picked;
                        });
                        calculateTotalAmount(); // Recalculate total when end date changes
                      }
                    },
                    child: const Text('Select End Date', style: TextStyle(color: Colors.teal)),
                  ),
                  const SizedBox(height: 20),
                  if (amountPerDay != null)
                    Text('Amount per Day: ₹${amountPerDay!.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.white)), // Text color
                  Text('Number of Days: $numberOfDays', style: const TextStyle(fontSize: 16, color: Colors.white)), // Text color
                  Text('Total Amount: ₹${totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontSize: 16, color: Colors.white)), // Text color
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: submitData,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Colors.teal, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Confirm Payment', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
