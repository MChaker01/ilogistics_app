import 'package:intl/intl.dart'; // Pour formater la date

class DeliveryRequest {
  final int id;
  final String reference;
  final String type;
  final DateTime neededDeliveryDate;
  final String inboundType;
  final String status;
  final bool? isForReturn;
  final bool? isForTransfer;
  final String requesterFullName;
  final int projectId;
  final String projectName;
  final int? destinationProjectId; // Peut être null
  final String? destinationProjectName; // Peut être null
  final int warehouseId;
  final String warehouseName;
  final int? destinationId; // Peut être null
  final String? destinationName; // Peut être null
  final int? originId; // Peut être null
  final String? originName; // Peut être null

  DeliveryRequest({
    required this.id,
    required this.reference,
    required this.type,
    required this.neededDeliveryDate,
    required this.inboundType,
    required this.status,
    required this.isForReturn,
    required this.isForTransfer,
    required this.requesterFullName,
    required this.projectId,
    required this.projectName,
    this.destinationProjectId,
    this.destinationProjectName,
    required this.warehouseId,
    required this.warehouseName,
    this.destinationId,
    this.destinationName,
    this.originId,
    this.originName,
  });

  factory DeliveryRequest.fromJson(Map<String, dynamic> json) {
    // Formater la date
    final DateFormat formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS");
    final DateTime neededDeliveryDate = formatter.parse(json['neededDeliveryDate']);

    return DeliveryRequest(
      id: json['id'],
      reference: json['reference'],
      type: json['type'],
      neededDeliveryDate: neededDeliveryDate,
      inboundType: json['inboundType'],
      status: json['status'],
      isForReturn: json['isForReturn'] ?? false,
      isForTransfer: json['isForTransfer'] ?? false,
      requesterFullName: json['requesterFullName'],
      projectId: json['projectId'],
      projectName: json['projectName'],
      destinationProjectId: json['destinationProjectId'] ?? 0,
      destinationProjectName: json['destinationProjectName'] ?? '',
      warehouseId: json['warehouseId'],
      warehouseName: json['warehouseName'],
      destinationId: json['destinationId'] ?? 0,
      destinationName: json['destinationName'] ?? '',
      originId: json['originId'] ?? 0,
      originName: json['originName'] ?? '',
    );
  }

  // Ajout de la méthode toJson()
  Map<String, dynamic> toJson() => {
    'id': id,
    'reference': reference,
    'type': type,
    'neededDeliveryDate': neededDeliveryDate,
    'inboundType': inboundType,
    'status': status,
    'isForReturn': isForReturn,
    'isForTransfer': isForTransfer,
    'requesterFullName': requesterFullName,
    'projectId': projectId,
    'projectName': projectName,
    'destinationProjectId': destinationProjectId,
    'destinationProjectName': destinationProjectName,
    'warehouseId': warehouseId,
    'warehouseName': warehouseName,
    'destinationId': destinationId,
    'destinationName': destinationName,
    'originId': originId,
    'originName': originName,
  };
}
