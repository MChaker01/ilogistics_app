import 'package:flutter/material.dart';
import '../classes/delivery_request.dart';
import '../widgets/profile_dropdown.dart';
import 'storage_wizard_page.dart';

class DeliveryRequestDetailsPage extends StatelessWidget {
  final DeliveryRequest request;
  static const Color _blueBorder = Color(0xFFDCEBF7); //D1E9F6
  static const Color _blueBackground = Color(0xFFEDF3F4);
  static const Color _darkBlueText = Color(0xFF3373BC);

  const DeliveryRequestDetailsPage({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    // Determine button style based on request type
    Color? buttonColor =
    request.type == 'INBOUND' ? Colors.green[400] : Colors.red[400];
    IconData buttonIcon = request.type == 'INBOUND'
        ? Icons.move_to_inbox_rounded
        : Icons.outbox_rounded;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Request Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: const [
          ProfileDropdown(), // Add the profile widget here
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Align(
              // Use Align to position the button
              alignment: Alignment.center,
              child: ElevatedButton.icon(

                // Handle Button
                onPressed: () {
                  // Naviguer vers StorageWizardPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => StorageWizardPage(dnType: request.type),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor, // Use determined color
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 15),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: Icon(
                    buttonIcon,
                    color: Colors.white), // Use determined icon
                label:
                const Text('Handle', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              // Allow table to take remaining space
              child: SingleChildScrollView(
                child: Table(
                  border: TableBorder.all(color: _blueBorder),
                  // Add columnWidths to control column behavior
                  columnWidths: const {
                    0: FlexColumnWidth(1), // First column takes 1/2 space
                    1: FlexColumnWidth(1), // Second column takes 1/2 space
                  },
                  children: [
                    _buildTableRow('Reference', request.reference),
                    _buildTableRow('Type', request.type,
                        color: request.type == 'INBOUND'
                            ? Colors.green
                            : Colors.red),
                    _buildTableRow('Project', request.projectName),
                    _buildTableRow('Warehouse', request.warehouseName),
                    _buildTableRow('Requester', request.requesterFullName),
                    _buildTableRow('inbound Type', request.inboundType),
                    _buildTableRow('Status', request.status),
                    _buildTableRow('REF', request.originName ?? ''), // Provide empty string if null
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value, {Color? color}) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Container(
            // Added Container here
            color: _blueBackground, // Blue background for left column
            padding: const EdgeInsets.all(8.0), // Moved padding to Container
            child: Text(
              label,
              style: const TextStyle(color: _darkBlueText),
            ),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: TextStyle(color: color),
            ),
          ),
        ),
      ],
    );
  }
}
