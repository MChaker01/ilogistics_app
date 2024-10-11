import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';

class ProfileDropdown extends StatelessWidget {
  const ProfileDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const CircleAvatar(
        backgroundImage: NetworkImage(
            'https://www.gravatar.com/avatar/?d=mp'),
      ),
      onSelected: (String item) async {
        if (item == 'Logout') {
          // Supprimer le token de SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('authToken');

          // Rediriger vers la page de connexion
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false, // Supprimer toutes les pages précédentes
          );
        } else if (item == 'Change Password') {

        } else if (item == 'To Handle') {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('authToken');

          // Vérifier si on est déjà sur DeliveryRequestListPage
          if (ModalRoute.of(context)?.settings.name == '/deliveryRequestList') {
            // Si oui, ne rien faire (on reste sur la même page)
            return;
          } else {
            // Sinon, naviguer vers DeliveryRequestListPage et la mettre en bas de la pile
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/deliveryRequestList',
                  (route) => false,
              arguments: token, // Passer le token en argument
            );
          }
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'To Handle',
          child: SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(Icons.task, color: Colors.blue),
                SizedBox(width: 8),
                Text('To Handle'),
              ],
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Change Password',
          child: SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(Icons.lock, color: Colors.green),
                SizedBox(width: 8),
                Text('Change Password'),
              ],
            ),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Logout',
          child: SizedBox(
            height: 35,
            child: Row(
              children: [
                Icon(Icons.logout, color: Colors.red),
                SizedBox(width: 8),
                Text('Logout'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}