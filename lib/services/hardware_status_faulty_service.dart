import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/hardware_status_data.dart';

class HardwareStatusFaultyService {
  Future<List<HardwareStatusData>> getHardwareStatusData() async {
    final response = await http.get(
        Uri.parse('http://localhost/hardware_status_faulty.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item) => HardwareStatusData.fromJson(item))
          .toList();
    } else {
      throw Exception(
          'Erreur lors du chargement des données de statut matériel (Faulty)');
    }
  }
}