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
    print('Vehicle ID passed to CustomerInputPage: ${widget.vehicleId}');
    fetchVehicleData();
  }

  // Fetch the amount from the 'rental' database for the selected vehicle
  Future<void> fetchVehicleData() async {
    if (widget.vehicleId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid vehicle ID.')),
      );
      return;
    }

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
      print('Error fetching vehicle data: $e');
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
          .showSnackBar(SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    // Create a new customer record in the "rented" collection
    try {
      await FirebaseFirestore.instance.collection('rented').add({
        'vehicleId': widget.vehicleId,
        'customerName': nameController.text,
        'phone': phoneController.text,
        'startDate': startDate,
        'endDate': endDate,
        'amountPerDay': amountPerDay,
        'numberOfDays': numberOfDays,
        'totalAmount': totalAmount,
      });

      // Navigate back after submission
      Navigator.pop(context);
    } catch (e) {
      print('Error submitting data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Input')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            Text('Start Date: ${startDate != null ? DateFormat('yyyy-MM-dd').format(startDate!) : 'Not Selected'}'),
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
              child: const Text('Select Start Date'),
            ),
            SizedBox(height: 16),
            Text('End Date: ${endDate != null ? DateFormat('yyyy-MM-dd').format(endDate!) : 'Not Selected'}'),
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
              child: const Text('Select End Date'),
            ),
            SizedBox(height: 20),
            if (amountPerDay != null)
              Text('Amount per Day: ₹${amountPerDay!.toStringAsFixed(2)}'),
            Text('Number of Days: $numberOfDays'),
            Text('Total Amount: ₹${totalAmount.toStringAsFixed(2)}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              child: const Text('Confirm Payment'),
            ),
          ],
        ),
      ),
    );
  }
}
