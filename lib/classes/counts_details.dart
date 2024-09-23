class CountsDetail {
  final int id;
  final String partNumber;
  final int quantity;
  int receivedQuantity; // Modifiable si la quantité reçue est différente de la quantité commandée

  CountsDetail({
    required this.id,
    required this.partNumber,
    required this.quantity,
    required this.receivedQuantity,
  });

  factory CountsDetail.fromJson(Map<String, dynamic> json) {
    return CountsDetail(
      id: json['id'],
      partNumber: json['partNumber'],
      quantity: json['quantity'],
      receivedQuantity: json['receivedQuantity'],
    );
  }
}