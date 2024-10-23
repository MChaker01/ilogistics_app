import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../classes/hardware_status_data.dart';

class StoreFaultyIn extends StatefulWidget {
  final List<HardwareStatusData> hardwareStatusData;
  final Function(List<HardwareStatusData>) onHardwareStatusDataChanged;

  const StoreFaultyIn({Key? key, required this.hardwareStatusData, required this.onHardwareStatusDataChanged}) : super(key: key);

  @override
  _StoreFaultyInState createState() => _StoreFaultyInState();
}

class _StoreFaultyInState extends State<StoreFaultyIn> {
  Map<int, String> _locations = {};
  Map<int, TextEditingController> _quantityControllers = {};
  Map<int, bool> _showIcons = {};

  @override
  void initState() {
    super.initState();
    _locations = {};
    _quantityControllers = {};
    _showIcons = {};

    // Initialiser _locations avec les valeurs par défaut dès le début
    for (int i = 0; i < widget.hardwareStatusData.length; i++) {
      final data = widget.hardwareStatusData[i];
      _locations[data.id] = 'X'; // Location par défaut pour les produits "Faulty"
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
            _locations[widget.hardwareStatusData.length] = 'A'; // Location par défaut
            _quantityControllers[widget.hardwareStatusData.length] = TextEditingController(text: remainingQuantity.toString());
            _showIcons[widget.hardwareStatusData.length] = false;

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
      final deletedData = widget.hardwareStatusData.removeAt(index);
      _quantityControllers.remove(deletedData.id);
      _locations.remove(deletedData.id);

      // Ajoute la quantité de la ligne supprimée à la ligne précédente
      if (index > 0) {
        widget.hardwareStatusData[index - 1].quantity += deletedData.quantity;
        widget.hardwareStatusData[index - 1].packingQty =
            widget.hardwareStatusData[index - 1].quantity; // Met à jour packingQty

        // Met à jour le contrôleur de texte de la ligne précédente
        _quantityControllers[widget.hardwareStatusData[index - 1].id]!.text =
            widget.hardwareStatusData[index - 1].quantity.toString();
      }

      // Appelle le callback pour passer les données mises à jour
      widget.onHardwareStatusDataChanged(widget.hardwareStatusData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                      Text(data.quantity.toString()), // Quantity non modifiable
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
                        // Ajoute une valeur par défaut
                        value: _locations[data.id] ?? 'X',
                        onChanged: (newValue) =>
                            _handleLocationChange(data.id, newValue!),
                        items: const [
                          DropdownMenuItem(
                            value: 'X',
                            child: Text('X'),
                          ),
                        ],
                      ),
                    ),
                    DataCell(
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Afficher les icônes de confirmation/annulation
                          if (data.isAdded)
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
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
          ),
        ),
      ),
    );
  }
}