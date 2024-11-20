import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'user/tata_tertib.dart';
import 'pages/homepage.dart';
import 'pages/homepageAdmin.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/register': (context) => RegisterPage(),
        '/tata_tertib': (context) => TataTertibPage(),
        '/home': (context) => HomePage(),
        '/homepageAdmin': (context) => AdminHomepage(),
      },
    );
  }
}
