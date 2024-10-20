import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../classes/hardware_status_data.dart';
import '../../../services/hardware_status_faulty_service.dart';

class HardwareStatusFaultyIn extends StatefulWidget {
  final Function(List<HardwareStatusData>) onHardwareStatusDataChanged; // Ajoute le callback

  const HardwareStatusFaultyIn({Key? key, required this.onHardwareStatusDataChanged}) : super(key: key); // Ajoute le paramètre au constructeur

  @override
  State<HardwareStatusFaultyIn> createState() =>
      _HardwareStatusFaultyInState();
}

class _HardwareStatusFaultyInState extends State<HardwareStatusFaultyIn> {
  final HardwareStatusFaultyService _hardwareStatusService =
  HardwareStatusFaultyService();
  List<HardwareStatusData> _hardwareStatusData = [];
  Map<int, TextEditingController> _quantityControllers = {};
  Map<int, bool> _showIcons = {};

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
        for (var item in _hardwareStatusData) {
          _quantityControllers[item.id] =
              TextEditingController(text: item.quantity.toString());
          _showIcons[item.id] = false;
        }
      });
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _handleQuantityChange(
      HardwareStatusData data, String newValue, BuildContext context) {
    setState(() {
      data.quantity = double.tryParse(newValue) ?? 0; // Met à jour data.quantity, même si newValue est null
      _showIcons[data.id] = true;
    });
  }

  void _resetQuantity(HardwareStatusData data) {
    setState(() {
      _quantityControllers[data.id]!.text = data.packingQty.toString();
      _showIcons[data.id] = false;
    });
  }

  void _confirmQuantity(HardwareStatusData data) {
    final remainingQuantity = data.packingQty - data.quantity;

    setState(() {
      if (data.quantity > 0 && data.quantity <= data.packingQty) {
        // Quantité valide
        data.packingQty = data.quantity;
        _quantityControllers[data.id]!.text = data.packingQty.toString();
        _showIcons[data.id] = false;

        if (remainingQuantity > 0) {
          _hardwareStatusData.insert(
            _hardwareStatusData.indexOf(data) + 1,
            HardwareStatusData(
              id: _hardwareStatusData.length + 1,
              partNumber: data.partNumber,
              quantity: remainingQuantity,
              status: data.status,
              packing: data.packing,
              packingQty: remainingQuantity,
              isAdded: true, // Indique que la ligne a été ajoutée dynamiquement
            ),
          );

          _quantityControllers[_hardwareStatusData.length] =
              TextEditingController(text: remainingQuantity.toString());
          _showIcons[_hardwareStatusData.length] = false;

          // Appelle le callback pour passer les données mises à jour
          widget.onHardwareStatusDataChanged(_hardwareStatusData);
        }
      } else {
        // Quantité invalide (0, null ou supérieure à la quantité initiale)
        data.quantity = data.packingQty;
        _quantityControllers[data.id]!.text = data.packingQty.toString();
        _showIcons[data.id] = false;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Veuillez saisir une quantité valide (supérieure à 0 et inférieure ou égale à la quantité initiale).'),
          ),
        );
      }
    });
  }

  void _deleteRow(int index) {
    setState(() {
      final deletedData = _hardwareStatusData.removeAt(index);
      _quantityControllers.remove(deletedData.id);

      // Ajoute la quantité de la ligne supprimée à la ligne précédente
      _hardwareStatusData[index - 1].quantity += deletedData.quantity;
      _hardwareStatusData[index - 1].packingQty =
          _hardwareStatusData[index - 1].quantity; // Met à jour packingQty

      // Met à jour le contrôleur de texte de la ligne précédente
      _quantityControllers[_hardwareStatusData[index - 1].id]!.text =
          _hardwareStatusData[index - 1].quantity.toString();

      // Appelle le callback pour passer les données mises à jour
      widget.onHardwareStatusDataChanged(_hardwareStatusData);
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
                      // On supprime la colonne "Location" ici
                      // DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: _hardwareStatusData.map((data) {
                      return DataRow(
                        cells: [
                          DataCell(Text(data.partNumber)),
                          DataCell(
                            TextFormField(
                              controller: _quantityControllers[data.id],
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                              ],
                              onChanged: (newValue) => _handleQuantityChange(data, newValue, context),
                            ),
                          ),
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
                                  value: 'Hardware Fault',
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
                          // On supprime la cellule de la colonne "Location"
                          // DataCell(Text(_locations[data.id] ?? '')),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Affiche les icônes si la quantité a été modifiée
                                if (_showIcons[data.id]!)
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => _confirmQuantity(data),
                                  ),
                                if (_showIcons[data.id]!)
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _resetQuantity(data),
                                  ),
                                // Affiche l'icône "close" pour les nouvelles lignes
                                if (data.isAdded && !_showIcons[data.id]!) // Vérifie si la ligne a été ajoutée
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () =>
                                        _deleteRow(_hardwareStatusData.indexOf(data)),
                                  ),
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