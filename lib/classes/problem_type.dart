class ProblemType {
  final int id;
  final String name;

  ProblemType({
    required this.id,
    required this.name,
  });

  factory ProblemType.fromJson(Map<String, dynamic> json) {
    return ProblemType(
      id: json['id'],
      name: json['name'],
    );
  }
}