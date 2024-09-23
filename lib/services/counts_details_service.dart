import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/counts_details.dart';

class CountsDetailsService {
  Future<List<CountsDetail>> getCountsDetails() async {
    final response = await http
        .get(Uri.parse('http://localhost/details.json'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((item) => CountsDetail.fromJson(item))
          .toList();
    } else {
      throw Exception('Erreur lors du chargement des détails de la requête');
    }
  }
}