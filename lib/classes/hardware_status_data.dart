class HardwareStatusData {
  final int id;
  final String partNumber;
  final double quantity;
  String status; // Modifiable
  final String packing;
  final double packingQty;

  HardwareStatusData({
    required this.id,
    required this.partNumber,
    required this.quantity,
    required this.status,
    required this.packing,
    required this.packingQty,
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