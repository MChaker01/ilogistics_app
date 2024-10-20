
class HardwareStatusData {
  final int id;
  final String partNumber;
  double quantity;
  String status; // Modifiable
  final String packing;
  double packingQty;
  bool isAdded; // Nouvelle propriété pour indiquer si la ligne a été ajoutée

  HardwareStatusData({
    required this.id,
    required this.partNumber,
    required this.quantity,
    required this.status,
    required this.packing,
    required this.packingQty,
    this.isAdded = false, // Valeur par défaut : false
  });

  factory HardwareStatusData.fromJson(Map<String, dynamic> json) {
    return HardwareStatusData(
      id: json['id'],
      partNumber: json['partNumber'],
      quantity: json['quantity'],
      status: json['status'],
      packing: json['packing'],
      packingQty: json['packingQty'],
    );
  }
}
