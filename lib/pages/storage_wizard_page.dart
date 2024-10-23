import 'package:flutter/material.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/attachments_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_faulty_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_normal_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/status_category_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/store_in.dart'; // Import pour StoreIn
import 'package:ism_two/widgets/storage_wizard/inbound/store_normal_in.dart'; // Import pour StoreNormalIn
import 'package:ism_two/widgets/storage_wizard/inbound/store_faulty_in.dart'; // Import pour StoreFaultyIn
import 'package:ism_two/widgets/storage_wizard/inbound/summary_in.dart';
import '../classes/hardware_status_data.dart';
import '../widgets/storage_wizard/inbound/visual_check_in.dart';
import '../widgets/storage_wizard/inbound/counts_in.dart';
import '../widgets/storage_wizard/outbound/dn_materials_out.dart';
import '../widgets/storage_wizard/outbound/deliver_to_company_out.dart';
import 'package:ism_two/widgets/storage_wizard/outbound/attachments_out.dart';
import 'package:ism_two/widgets/storage_wizard/outbound/summary_out.dart';
import '../services/hardware_status_normal_service.dart';
import '../services/hardware_status_faulty_service.dart';

class StorageWizardPage extends StatefulWidget {
  final String dnType;

  const StorageWizardPage({super.key, required this.dnType});

  @override
  _StorageWizardPageState createState() => _StorageWizardPageState();
}

class _StorageWizardPageState extends State<StorageWizardPage> {
  int _currentStep = 0;
  List<HardwareStatusData> _hardwareStatusData = [];
  String? _selectedStatusCategory = 'Normal';

  final HardwareStatusNormalService _normalService = HardwareStatusNormalService();
  final HardwareStatusFaultyService _faultyService = HardwareStatusFaultyService();

  // Fonction pour charger les données de statut matériel
  Future<void> _fetchHardwareStatusData() async {
    try {
      // Chargez les données à partir du service approprié
      List<HardwareStatusData> data = _selectedStatusCategory == 'Normal'
          ? await _normalService.getHardwareStatusData()
          : await _faultyService.getHardwareStatusData();

      setState(() {
        _hardwareStatusData = data;
      });
    } catch (e) {
      print('Erreur lors du chargement des données de statut matériel: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchHardwareStatusData();
  }

  List<Widget> get _steps => widget.dnType == 'INBOUND'
      ? [
    const VisualCheckIn(),
    const CountsIn(),
    const HardwareStatusIn(),
    _selectedStatusCategory == 'Normal'
        ? HardwareStatusNormalIn(
      onHardwareStatusDataChanged: (data) {
        setState(() {
          _hardwareStatusData = data;
        });
      },
    )
        : HardwareStatusFaultyIn(
      onHardwareStatusDataChanged: (data) {
        setState(() {
          _hardwareStatusData = data;
        });
      },
    ),
    // Utilisez StoreNormalIn ou StoreFaultyIn en fonction de la catégorie
    _selectedStatusCategory == 'Normal'
        ? StoreNormalIn(
      hardwareStatusData: _hardwareStatusData,
      onHardwareStatusDataChanged: (data) {
        setState(() {
          _hardwareStatusData = data;
        });
      },
    )
        : StoreFaultyIn(
      hardwareStatusData: _hardwareStatusData,
      onHardwareStatusDataChanged: (data) {
        setState(() {
          _hardwareStatusData = data;
        });
      },
    ),
    const AttachmentsIn(),
    const SummaryIn(),
  ]
      : [
    const DnMaterialsOut(),
    const DeliverToCompanyOut(),
    const AttachmentsOut(),
    const SummaryOut(),
  ];

  List<String> get _stepTitles => widget.dnType == 'INBOUND'
      ? [
    'Visual Check',
    'Counts',
    'Status Category',
    'Hardware Status',
    'Store',
    'Attachments',
    'Summary',
  ]
      : [
    'DN Materials',
    'Deliver to Company',
    'Attachments',
    'Summary',
  ];


  bool _validateStatusCategory() {
    // Crée une map pour suivre les Part Number et leurs statuts
    Map<String, List<String>> partNumberStatuses = {};

    // Remplit la map avec les Part Number et leurs statuts
    for (var data in _hardwareStatusData) {
      if (!partNumberStatuses.containsKey(data.partNumber)) {
        partNumberStatuses[data.partNumber] = [];
      }
      partNumberStatuses[data.partNumber]!.add(data.status);
    }

    // Parcourt les Part Number et leurs statuts
    for (var partNumber in partNumberStatuses.keys) {
      // Vérifie si un Part Number a plus d'une ligne
      if (_hardwareStatusData.where((element) => element.partNumber == partNumber).length > 1) {
        final statusList = partNumberStatuses[partNumber]!;

        // Vérifie si tous les statuts pour ce Part Number sont identiques
        for (int i = 0; i < statusList.length - 1; i++) {
          for (int j = i + 1; j < statusList.length; j++) {
            if (statusList[i] == statusList[j]) {
              return false; // Validation échouée si deux statuts sont identiques
            }
          }
        }
      }
    }
    return true; // Validation réussie
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Storage Wizard'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepTapped: (step) => setState(() => _currentStep = step),
        onStepContinue: () {
          if (_currentStep == 3 && // Index de l'étape "Hardware Status"
              !_validateStatusCategory()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'Les lignes avec le même Part Number ne peuvent pas avoir toutes le même statut.'),
              ),
            );
          } else if (_currentStep < _steps.length - 1) {
            setState(() => _currentStep += 1);
          } else {
            // Gérer la fin du wizard
          }
        },
        onStepCancel:
        _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        steps: [
          for (int i = 0; i < _steps.length; i++)
            Step(
              title: Text(_stepTitles[i]),
              content: i == 2 // Index de l'étape 'Status Category'
                  ? StatusCategoryIn(
                onStatusCategorySelected: (value) {
                  setState(() {
                    _selectedStatusCategory = value;
                    _fetchHardwareStatusData(); // Charger les données après le changement de catégorie
                  });
                },
              )
              // Transmettez _hardwareStatusData à StoreIn lors du clic sur "Continue"
                  : i == 4 // Index de l'étape 'Store'
                  ? _selectedStatusCategory == 'Normal'
                  ? StoreNormalIn(
                hardwareStatusData: _hardwareStatusData,
                onHardwareStatusDataChanged: (data) { // Ajoutez le callback ici
                  setState(() {
                    _hardwareStatusData = data;
                  });
                },
              )
                  : StoreFaultyIn(
                hardwareStatusData: _hardwareStatusData,
                onHardwareStatusDataChanged: (data) { // Ajoutez le callback ici
                  setState(() {
                    _hardwareStatusData = data;
                  });
                },
              )
                  : _steps[i], // Afficher les autres étapes normalement
            ),
        ],
      ),
    );
  }
}