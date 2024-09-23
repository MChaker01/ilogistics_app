import 'dart:convert';
import 'package:http/http.dart' as http;
import '../classes/delivery_request.dart';

class DeliveryRequestService {
  Future<List<DeliveryRequest>> getDeliveryRequests(String token) async {
    final response = await http.get(Uri.parse('http://localhost:8085/mobile/dn/$token'),
        headers: {'Authorization': 'Bearer $token'}, // Envoyer le token dans l'en-tête
    );

    //print('Code de statut de la réponse: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((item) => DeliveryRequest.fromJson(item)).toList();
    } else {
      throw Exception('Erreur lors du chargement des Delivery Requests');
    }
  }
}