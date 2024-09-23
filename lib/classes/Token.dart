import 'User.dart';

class Token {
  final String username;
  final String key;
  final String expirationTime;
  final User user;
  final List<String> roleList;
  final List<dynamic> warehouseList;
  final bool active;


  Token({
    required this.username,
    required this.key,
    required this.expirationTime,
    required this.user,
    required this.roleList,
    required this.warehouseList,
    required this.active,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      username: json['username'],
      key: json['key'],
      expirationTime: json['expirationTime'],
      user: User.fromJson(json['user']), // Utilise la factory fromJson de la classe User
      roleList: List<String>.from(json['roleList']),
      warehouseList: List<dynamic>.from(json['warehouseList']),
      active: json['active'],
    );
  }
}

