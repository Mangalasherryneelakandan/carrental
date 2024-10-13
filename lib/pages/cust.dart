import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerInputPage extends StatefulWidget {
  final String vehicleId;

  const CustomerInputPage({Key? key, required this.vehicleId}) : super(key: key);

  @override
  _CustomerInputPageState createState() => _CustomerInputPageState();
}

class _CustomerInputPageState extends State<CustomerInputPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  Future<void> submitData() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || startDate == null || endDate == null) {
      // Display error if fields are empty
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all fields.')));
      return;
    }

    // Create a new customer record in Firestore
    await FirebaseFirestore.instance.collection('customers').add({
      'vehicleId': widget.vehicleId,
      'name': nameController.text,
      'phone': phoneController.text,
      'startDate': startDate,
      'endDate': endDate,
    });

    // Navigate back after submission
    Navigator.pop(context);
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
            Text('Start Date: ${startDate != null ? startDate!.toLocal().toString().split(' ')[0] : 'Not Selected'}'),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != startDate) {
                  setState(() {
                    startDate = picked;
                  });
                }
              },
              child: const Text('Select Start Date'),
            ),
            SizedBox(height: 16),
            Text('End Date: ${endDate != null ? endDate!.toLocal().toString().split(' ')[0] : 'Not Selected'}'),
            TextButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != endDate) {
                  setState(() {
                    endDate = picked;
                  });
                }
              },
              child: const Text('Select End Date'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitData,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
