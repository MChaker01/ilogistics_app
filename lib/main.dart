import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/delivery_request_list_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ilogistics APP',
      home: LoginPage(),
      routes: {
        '/deliveryRequestList': (context) => DeliveryRequestListPage(token: ModalRoute.of(context)!.settings.arguments as String),
        // ... autres routes ...
      },
    );
  }
}
