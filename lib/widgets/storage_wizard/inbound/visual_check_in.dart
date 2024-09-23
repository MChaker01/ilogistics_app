import 'package:flutter/material.dart';
import '../../../services/problem_type_service.dart';
import '../../../classes/problem_type.dart';

class VisualCheckIn extends StatefulWidget {
  const VisualCheckIn({Key? key}) : super(key: key);

  @override
  State<VisualCheckIn> createState() => _VisualCheckInState();
}

class _VisualCheckInState extends State<VisualCheckIn> {
  String? _selectedVisualCheck;
  ProblemType? _selectedProblemType;
  final ProblemTypeService _problemTypeService = ProblemTypeService();
  List<ProblemType> _problemTypes = [];

  @override
  void initState() {
    super.initState();
    _fetchProblemTypes();
  }

  Future<void> _fetchProblemTypes() async {
    try {
      final problemTypes = await _problemTypeService.getProblemTypes();
      setState(() {
        _problemTypes = problemTypes;
      });
    } catch (e) {
      print('Erreur: $e');
      // TODO: Afficher un message d'erreur à l'utilisateur
    }
  }

  final List<String> _visualCheckOptions = ['Yes', 'No'];
  // final List<String> _problemTypeOptions = [
  //   'Delivery contain materiel having Physical Damage',
  //   'Delivery contain materiel Faulty',
  //   'Delivery contain materiel missing packaging',
  //   'Delivery contain used / dismantled materiel',
  //   'Delivery contain materiel having water Damage',
  //   'Delivery contain materiel having fire Damage',
  //   'Other',
  // ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visual Check Informations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        const SizedBox(height: 16.0),
        DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Visual Check OK (to change) ?',
                  border: OutlineInputBorder(),
                ),
                value: _selectedVisualCheck,
                onChanged: (newValue) {
                  setState(() {
                    _selectedVisualCheck = newValue;
                    // Réinitialise _selectedProblemType si "Yes" est sélectionné
                    if (newValue == 'Yes') {
                      _selectedProblemType = null;
                    }
                  });
                },
                items: _visualCheckOptions.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option),
                  );
                }).toList(),
              ),
        const SizedBox(height: 16.0),
        if (_selectedVisualCheck == 'No') // Afficher le deuxième menu déroulant si "No" est sélectionné
                DropdownButtonFormField<ProblemType>(
                  decoration: const InputDecoration(
                    labelText: 'Problem type',
                    border: OutlineInputBorder(),
                  ),
                  style: TextStyle(fontSize: 12, color: Colors.black),
                  value: _selectedProblemType,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedProblemType = newValue;
                    });
                  },
                  items: _problemTypes.map((problemType) {
                    return DropdownMenuItem(
                      value: problemType,
                      child: Text(problemType.name),
                    );
                  }).toList(),
                ),
        const SizedBox(height: 16.0),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Comment',
            hintText: 'Optional',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
      ],
    );
  }
}