import 'package:flutter/material.dart';
import '../../../services/counts_details_service.dart';
import '../../../classes/counts_details.dart';

class CountsIn extends StatefulWidget {
  const CountsIn({super.key});

  @override
  State<CountsIn> createState() => _CountsInState();
}

class _CountsInState extends State<CountsIn> {
  String? _selectedCountsCheck;
  final TextEditingController _commentController = TextEditingController();
  final CountsDetailsService _detailService =
  CountsDetailsService();
  List<CountsDetail> _details = [];

  @override
  void initState() {
    super.initState();
    _fetchCountsDetails();
  }

  Future<void> _fetchCountsDetails() async {
    try {
      final details = await _detailService.getCountsDetails();
      setState(() {
        _details = details;
      });
    } catch (e) {
      print('Erreur: $e');
      // TODO: Afficher un message d'erreur à l'utilisateur
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Counts Check OK?',
                border: OutlineInputBorder(),
              ),
              value: _selectedCountsCheck,
              onChanged: (newValue) {
                setState(() {
                  _selectedCountsCheck = newValue;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Yes',
                  child: Text('Yes'),
                ),
                DropdownMenuItem(
                  value: 'No',
                  child: Text('No'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Comment',
                hintText: 'Optional',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 8.0),
            const SizedBox(height: 8.0),
            SizedBox(
              height: 300,
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Part Number')),
                        DataColumn(label: Text('Quantity')),
                        DataColumn(label: Text('Received Quantity')),
                      ],
                      rows: _details.map((detail) {
                        return DataRow(
                          cells: [
                            DataCell(Text(detail.partNumber)),
                            DataCell(Text('${detail.quantity}')),
                            DataCell(
                              _selectedCountsCheck == 'No'
                                  ? TextFormField( // Champ modifiable si "No" est sélectionné
                                initialValue: '${detail.receivedQuantity}',
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  setState(() {
                                    detail.receivedQuantity = int.tryParse(value) ?? detail.receivedQuantity;
                                  });
                                },
                              )
                                  : Text('${detail.receivedQuantity}'), // Non modifiable si "Yes" est sélectionné
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }
}