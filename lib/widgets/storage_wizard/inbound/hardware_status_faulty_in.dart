import 'package:flutter/material.dart';
import '../../../services/hardware_status_faulty_service.dart';
import '../../../classes/hardware_status_data.dart';

class HardwareStatusFaultyIn extends StatefulWidget {
  const HardwareStatusFaultyIn({super.key});

  @override
  State<HardwareStatusFaultyIn> createState() =>
      _HardwareStatusFaultyInState();
}

class _HardwareStatusFaultyInState extends State<HardwareStatusFaultyIn> {
  final HardwareStatusFaultyService _hardwareStatusService =
  HardwareStatusFaultyService();
  List<HardwareStatusData> _hardwareStatusData = [];

  @override
  void initState() {
    super.initState();
    _fetchHardwareStatusData();
  }

  Future<void> _fetchHardwareStatusData() async {
    try {
      final data = await _hardwareStatusService.getHardwareStatusData();
      setState(() {
        _hardwareStatusData = data;
      });
    } catch (e) {
      print('Erreur: $e');
      // TODO: Afficher un message d'erreur à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Status Details',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 16.0),
        SizedBox(
          height: 300,
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Part Number')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Status')),
                  DataColumn(label: Text('Packing')),
                  DataColumn(label: Text('Packing Qty')),
                ],
                rows: _hardwareStatusData.map((data) {
                  return DataRow(
                    cells: [
                      DataCell(Text(data.partNumber)),
                      DataCell(Text('${data.quantity}')),
                      DataCell(
                        DropdownButtonFormField<String>(
                          value: data.status,
                          onChanged: (newValue) {
                            setState(() {
                              data.status = newValue!;
                            });
                          },
                          items: const [
                            DropdownMenuItem(
                              value: 'Hardware Fault', // Valeur unique
                              child: Text('Hardware Fault'),
                            ),
                            DropdownMenuItem(
                              value: 'Water damage',
                              child: Text('Water damage'),
                            ),
                            DropdownMenuItem(
                              value: 'Physical damage',
                              child: Text('Physical damage'),
                            ),
                            DropdownMenuItem(
                              value: 'Fire damage',
                              child: Text('Fire damage'),
                            ),
                            DropdownMenuItem(
                              value: 'Other',
                              child: Text('Other'),
                            ),
                          ],
                        ),
                      ),
                      DataCell(Text(data.packing)),
                      DataCell(Text('${data.packingQty}')),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}