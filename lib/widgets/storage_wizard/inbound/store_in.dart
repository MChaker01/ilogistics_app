import 'package:flutter/material.dart';
import '../../../classes/hardware_status_data.dart';


class StoreIn extends StatefulWidget {
  final List<HardwareStatusData> hardwareStatusData;

  const StoreIn({Key? key, required this.hardwareStatusData}) : super(key: key);

  @override
  _StoreInState createState() => _StoreInState();
}

class _StoreInState extends State<StoreIn> {
  // Définir la map pour les locations ici
  Map<int, String> _locations = {};

  @override
  void initState() {
    super.initState();
    // Initialiser les locations avec des valeurs par défaut
    for (var data in widget.hardwareStatusData) {
      _locations[data.id] = 'A'; // Définir la location par défaut à 'A'
    }
  }

  // Fonction pour gérer le changement de location
  void _handleLocationChange(int id, String value) {
    setState(() {
      _locations[id] = value;
    });
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
                child: SingleChildScrollView(

                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Part Number')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Packing')),
                      DataColumn(label: Text('Packing Qty')),
                      DataColumn(label: Text('Location')), // Ajoute la colonne Location
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: widget.hardwareStatusData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data.partNumber)),
                          DataCell(
                            Text(data.quantity.toString()),
                          ),
                          DataCell(
                            Text(data.status),
                          ),
                          DataCell(
                            Text(data.packing),
                          ),
                          DataCell(
                            Text(data.packingQty.toString()),
                          ),
                          // Ajoute la cellule Location à chaque ligne
                          DataCell(
                            DropdownButtonFormField<String>(
                              value: _locations[data.id],
                              onChanged: (newValue) =>
                                  _handleLocationChange(data.id, newValue!),
                              items: const [
                                DropdownMenuItem(
                                  value: 'A',
                                  child: Text('A'),
                                ),
                                DropdownMenuItem(
                                  value: 'B',
                                  child: Text('B'),
                                ),
                                DropdownMenuItem(
                                  value: 'C',
                                  child: Text('C'),
                                ),
                                DropdownMenuItem(
                                  value: 'D',
                                  child: Text('D'),
                                ),
                              ],
                            ),
                          ),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                )
            ),
          ),
        ),
      ],
    );
  }
}