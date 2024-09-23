import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/problem_type.dart';

class ProblemTypeService {
  Future<List<ProblemType>> getProblemTypes() async {
    final response = await http.get(Uri.parse('http://localhost/problem_types.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => ProblemType.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des Problem Types');
    }
  }
}