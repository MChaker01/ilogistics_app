import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../classes/hardware_status_data.dart';

class StoreIn extends StatefulWidget {
  final List<HardwareStatusData> hardwareStatusData;
  final Function(List<HardwareStatusData>) onHardwareStatusDataChanged;

  const StoreIn({Key? key, required this.hardwareStatusData, required this.onHardwareStatusDataChanged}) : super(key: key);

  @override
  _StoreInState createState() => _StoreInState();
}

class _StoreInState extends State<StoreIn> {
  Map<int, String> _locations = {};
  Map<int, TextEditingController> _quantityControllers = {};
  Map<int, bool> _showIcons = {};

  @override
  void initState() {
    super.initState();
    _locations = {}; // Initialisez le map _locations
    _quantityControllers = {}; // Initialisez le map _quantityControllers
    _showIcons = {}; // Initialisez le map _showIcons

    for (var data in widget.hardwareStatusData) {
      _locations[data.id] = 'A'; // Initialisez la location par défaut à 'A' pour chaque ligne
      _quantityControllers[data.id] = TextEditingController(text: data.quantity.toString());
      _showIcons[data.id] = false;
    }
  }

  void _handleLocationChange(int id, String value) {
    setState(() {
      _locations[id] = value;
    });
  }

  void _handleQuantityChange(int id, String newValue) {
    setState(() {
      final data = widget.hardwareStatusData.firstWhere((element) => element.id == id);
      data.quantity = double.tryParse(newValue) ?? 0;
      _showIcons[id] = true;
    });
  }

  void _resetQuantity(int id) {
    setState(() {
      final data = widget.hardwareStatusData.firstWhere((element) => element.id == id);
      _quantityControllers[id]!.text = data.packingQty.toString();
      _showIcons[id] = false;
    });
  }

  bool _validateLocation(int id, String newLocation) {
    final data = widget.hardwareStatusData.firstWhere((element) => element.id == id);

    // Vérifier si d'autres lignes avec le même Part Number ont la même location
    for (var otherData in widget.hardwareStatusData) {
      if (otherData.id != id &&
          otherData.partNumber == otherData.partNumber &&
          _locations[otherData.id] != null &&
          _locations[otherData.id] == newLocation) {
        return false;
      }
    }
    return true;
  }

  void _confirmQuantity(int id) {
    setState(() {
      final data = widget.hardwareStatusData.firstWhere((element) => element.id == id);
      final remainingQuantity = data.packingQty - data.quantity;

      if (data.quantity > 0 && data.quantity <= data.packingQty) {
        // Quantité valide
        // Valider la location avant de la confirmer
        if (_validateLocation(id, _locations[id] ?? '')) {
          data.packingQty = data.quantity;
          _quantityControllers[id]!.text = data.packingQty.toString();
          _showIcons[id] = false;

          if (remainingQuantity > 0) {
            // Ajouter une nouvelle ligne avec la quantité restante
            widget.hardwareStatusData.insert(
              widget.hardwareStatusData.indexOf(data) + 1,
              HardwareStatusData(
                id: widget.hardwareStatusData.length + 1,
                partNumber: data.partNumber,
                quantity: remainingQuantity,
                status: data.status,
                packing: data.packing,
                packingQty: remainingQuantity,
                isAdded: true,
              ),
            );

            // Initialiser la location et le contrôleur de quantité pour la nouvelle ligne
            _locations[widget.hardwareStatusData.length] = 'A';
            _quantityControllers[widget.hardwareStatusData.length] = TextEditingController(text: remainingQuantity.toString());
            _showIcons[widget.hardwareStatusData.length] = false;

            // Mettre à jour la location si nécessaire
            // ...

            // Appeler le callback pour notifier StorageWizardPage des modifications
            widget.onHardwareStatusDataChanged(widget.hardwareStatusData);
          }
        } else {
          // Afficher un message d'erreur
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Les lignes avec le même Part Number ne peuvent pas avoir toutes la même location.'),
            ),
          );
        }
      } else {
        // Quantité invalide
        data.quantity = data.packingQty;
        _quantityControllers[id]!.text = data.packingQty.toString();
        _showIcons[id] = false;

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
      widget.hardwareStatusData.removeAt(index);
      // Mettez à jour les IDs si nécessaire
      // ...
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Store Details',
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
                      DataColumn(label: Text('Location')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: widget.hardwareStatusData.map((data) {
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
                              onChanged: (newValue) => _handleQuantityChange(data.id, newValue),
                            ),
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
                                // Afficher les icônes de confirmation/annulation
                                if (_showIcons[data.id]!)
                                  IconButton(
                                    icon: const Icon(Icons.check, color: Colors.green),
                                    onPressed: () => _confirmQuantity(data.id),
                                  ),
                                if (_showIcons[data.id]!)
                                  IconButton(
                                    icon: const Icon(Icons.close, color: Colors.red),
                                    onPressed: () => _resetQuantity(data.id),
                                  ),
                                // Ajout de l'icône pour supprimer la ligne
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    final index = widget.hardwareStatusData.indexOf(data);
                                    if (index != -1) {
                                      _deleteRow(index);
                                    }
                                  },
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