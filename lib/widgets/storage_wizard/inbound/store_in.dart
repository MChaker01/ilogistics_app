import 'package:flutter/material.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/store_normal_in.dart';
import 'package:ism_two/widgets/storage_wizard/inbound/store_faulty_in.dart';
import '../../../classes/hardware_status_data.dart';

class StoreIn extends StatefulWidget {
  final List<HardwareStatusData> hardwareStatusData;
  final Function(List<HardwareStatusData>) onHardwareStatusDataChanged;

  const StoreIn({Key? key, required this.hardwareStatusData, required this.onHardwareStatusDataChanged}) : super(key: key);

  @override
  _StoreInState createState() => _StoreInState();
}

class _StoreInState extends State<StoreIn> {
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
        widget.hardwareStatusData[0].status == 'Faulty' // Vérifier le statut du premier élément
            ? StoreFaultyIn(
          hardwareStatusData: widget.hardwareStatusData,
          onHardwareStatusDataChanged: widget.onHardwareStatusDataChanged,
        )
            : StoreNormalIn(
          hardwareStatusData: widget.hardwareStatusData,
          onHardwareStatusDataChanged: widget.onHardwareStatusDataChanged,
        ),
      ],
    );
  }
}