import 'package:flutter/material.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/attachments_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_faulty_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/hardware_status_normal_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/status_category_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/store_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/summary_in.dart';
import '../widgets/storage_wizard/inbound/visual_check_in.dart';
import '../widgets/storage_wizard/inbound/counts_in.dart';
import '../widgets/storage_wizard/outbound/dn_materials_out.dart';
import '../widgets/storage_wizard/outbound/deliver_to_company_out.dart';
import 'package:ism_two/widgets/storage_wizard/outbound/attachments_out.dart';
import 'package:ism_two/widgets/storage_wizard/outbound/summary_out.dart';

class StorageWizardPage extends StatefulWidget {
  final String dnType;

  const StorageWizardPage({super.key, required this.dnType});

  @override
  _StorageWizardPageState createState() => _StorageWizardPageState();
}

class _StorageWizardPageState extends State<StorageWizardPage> {
  int _currentStep = 0;

  List<Widget> get _steps => widget.dnType == 'INBOUND'
      ? [
    const VisualCheckIn(),
    const CountsIn(),
    const HardwareStatusIn(),
    _selectedStatusCategory == 'Normal'
        ? const HardwareStatusNormalIn()
        : const HardwareStatusFaultyIn(),
    const StoreIn(),
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

  String? _selectedStatusCategory;

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
          if (_currentStep < _steps.length - 1) {
            // Sauvegarder les données de l'étape actuelle ici si nécessaire
            setState(() => _currentStep += 1);
          } else {
            // Gérer la fin du wizard
          }
        },
        onStepCancel: _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        steps: [
          for (int i = 0; i < _steps.length; i++)
            Step(
              title: Text(_stepTitles[i]),
              content: i == 2 // Index de l'étape 'Status Category'
                  ? StatusCategoryIn(
                onStatusCategorySelected: (value) {
                  setState(() {
                    _selectedStatusCategory = value;
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