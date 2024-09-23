import 'package:flutter/material.dart';
import './delivery_request_details_page.dart';
import '../services/delivery_request_service.dart';
import '../classes/delivery_request.dart';
import '../widgets/profile_dropdown.dart';

class DeliveryRequestListPage extends StatefulWidget {
  final String token;
  const DeliveryRequestListPage({super.key, required this.token});

  @override
  State<DeliveryRequestListPage> createState() =>
      _DeliveryRequestListState();
}

class _DeliveryRequestListState extends State<DeliveryRequestListPage> {
  final DeliveryRequestService _deliveryRequestService =
  DeliveryRequestService();
  List<DeliveryRequest> _deliveryRequests = [];
  List<DeliveryRequest> _filteredDeliveryRequests = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDeliveryRequests();
  }

  Future<void> _fetchDeliveryRequests() async {
    try {
      final deliveryRequests =
      await _deliveryRequestService.getDeliveryRequests(widget.token);
      setState(() {
        _deliveryRequests = deliveryRequests;
        _filteredDeliveryRequests = deliveryRequests;
      });
    } catch (e) {
      print('Erreur: $e');
      // TODO: Afficher un message d'erreur à l'utilisateur
    }
  }

  void _filterDeliveryRequests(String query) {
    setState(() {
      _filteredDeliveryRequests = _deliveryRequests.where((request) {
        final numberMatch = request.reference
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
        final refMatch = request.projectName
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
        return numberMatch || refMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Request List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        actions: const [
          ProfileDropdown(), // Add the profile widget here
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterDeliveryRequests,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredDeliveryRequests.length,
              itemBuilder: (context, index) {
                final request = _filteredDeliveryRequests[index];
                return ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DeliveryRequestDetailsPage(request: request),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.grey[300],
                    child: Text(
                      request.reference.substring(0, 2),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    request.reference,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${request.warehouseName}',
                        style: const TextStyle(fontSize: 14.0),
                      ),
                      Text(
                        '${request.type}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: request.type == 'INBOUND'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  trailing: Text(
                    request.status,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}