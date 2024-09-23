import 'package:flutter/material.dart';

class StatusCategoryIn extends StatefulWidget {
  final Function(String?) onStatusCategorySelected;

  const StatusCategoryIn({super.key, required this.onStatusCategorySelected});


  @override
  _StatusCategoryInState createState() => _StatusCategoryInState();
}

class _StatusCategoryInState extends State<StatusCategoryIn> {
  String? _selectedStatusCategory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select status category',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Status Category',
            border: OutlineInputBorder(),
          ),
          value: _selectedStatusCategory,
          onChanged: (newValue) {
            setState(() {
              _selectedStatusCategory = newValue;
              widget.onStatusCategorySelected(newValue);
            });
          },
          items: const [
            DropdownMenuItem(
              value: 'Normal',
              child: Text('Normal'),
            ),
            DropdownMenuItem(
              value: 'Faulty',
              child: Text('Faulty'),
            ),
          ],
        ),
      ],
    );
  }
}