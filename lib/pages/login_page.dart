import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:e_libs/util/config/config.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Simpan data role
    await prefs.setString('role', userData['role']);

    // Simpan data user
    if (userData['role'] == 'admin') {
      await prefs.setString('email', userData['email']);
    } else if (userData['role'] == 'user') {
      await prefs.setString('nrp', userData['nrp']);
      await prefs.setString('nama', userData['nama']);
      await prefs.setString('prodi', userData['prodi']);

      // Simpan notifikasi sebagai string JSON
      if (userData['notifikasi'] != null) {
        await prefs.setString(
            'notifikasi', json.encode(userData['notifikasi']));
      } else {
        await prefs.remove('notifikasi'); // Hapus jika tidak ada notifikasi
      }
    }
  }

  Future<void> _login() async {
    try {
      var uri = Uri.http(AppConfig.API_HOST, '/perpustakaan/login.php');
      final response = await http.post(
        uri,
        body: {
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);

        if (data['success']) {
          await _saveUserData(data['data']);
          String role = data['data']['role'];

          if (role == 'admin') {
            Navigator.pushReplacementNamed(context, '/homepageAdmin');
          } else if (role == 'user') {
            Navigator.pushReplacementNamed(context, '/tata_tertib');
          }
        } else {
          _showErrorDialog(data['message']);
        }
      } else {
        throw Exception('Failed to load, status: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorDialog('Login error: $e');
    }
  }

  /// Tampilkan dialog error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error', style: TextStyle(color: Colors.red)),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('OK', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: ArcClipper(),
              child: Container(
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: InvertedArcClipper(),
              child: Container(
                height: 100,
                color: Colors.blue,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'LOGIN',
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontWeight: FontWeight.bold,
                        fontSize: 64,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: const Offset(4.0, 4.0),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Email',
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[300],
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/register');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

class InvertedArcClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 30);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 30);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
