// Ajoute la classe User dans le même fichier ou importe-la si elle se trouve ailleurs
class User {
  final String username;
  final String login;
  final String? password; // Note le point d'interrogation car password peut être null
  final String firstName;
  final String lastName;
  final String fullName;

  User({
    required this.username,
    required this.login,
    this.password,
    required this.firstName,
    required this.lastName,
    required this.fullName,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'login': login,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'fullName': fullName,
  };

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      login: json['login'],
      password: json['password'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
    );
  }
}