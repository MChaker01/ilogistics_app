import 'package:flutter/material.dart';
import 'package:ism_two/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'delivery_request_list_page.dart';
import 'reset_password_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisibility = false;
  final _authService = AuthService();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _clearFields() {
    _passwordController.clear();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;

      try {

        final token = await _authService.login(username, password);
        // Enregistrer le token dans SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', token!.key);
        print('Connexion réussie! Token: ${token.key}');

        // Rediriger vers DeliveryRequestListPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DeliveryRequestListPage(token: token.key),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())), // Afficher un message d'erreur personnalisé
        );
      }

      _clearFields();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      top: true,
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          // Allow scrolling if content overflows
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                'assets/images/ilogistics_logo.png',
                width: double.infinity, // Makes the image span the width of the screen
                fit: BoxFit.contain, // Adjust image fitting
              ),
              const SizedBox(height: 100),
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D3D63),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Enter your username and password',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextFormField(
                  controller: _usernameController,
                  autofocus: false,
                  obscureText: false,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre identifiant';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                child: TextFormField(
                  controller: _passwordController,
                  autofocus: false,
                  obscureText: !_passwordVisibility,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          _passwordVisibility = !_passwordVisibility;
                        });
                      },
                      child: Icon(
                        _passwordVisibility
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: const Color(0xFF57636C),
                        size: 22,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez saisir votre mot de passe';
                    }
                    return null;
                  },
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                child: ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF5090C1), // Blue button
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  // Action for "Forgot Password"
                  print('Forgot password pressed!');
                  // Navigate to Reset Password page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ResetPasswordPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'I forgot my password',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        ),
      ),
    );
  }
}
