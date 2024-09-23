import 'package:flutter/material.dart';
import '../../../services/hardware_status_normal_service.dart';
import '../../../classes/hardware_status_data.dart';

class HardwareStatusNormalIn extends StatefulWidget {
  const HardwareStatusNormalIn({super.key});

  @override
  State<HardwareStatusNormalIn> createState() =>
      _HardwareStatusNormalInState();
}

class _HardwareStatusNormalInState extends State<HardwareStatusNormalIn> {
  final HardwareStatusNormalService _hardwareStatusService =
  HardwareStatusNormalService();
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
                              value: 'Brand New',
                              child: Text('Brand New'),
                            ),
                            DropdownMenuItem(
                              value: 'Used',
                              child: Text('Used'),
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