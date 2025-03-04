import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../providers/auth_provider.dart';
import '../movies/movie_listscreen.dart';
import 'register_screen.dart';
import '../movies/login_form.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isLoading = false;

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _loginUser(String username, String password) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    setState(() => _isLoading = true);

    try {
      bool success = await authProvider.loginUser(username, password);
      
      if (success) {
        _showSnackBar("Login Successful!", Colors.green);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MovieListScreen()),
        );
      }
    } catch (e) {
      String errorMessage = e.toString().replaceAll("Exception: ", "").split(": ").last;
      _showSnackBar(errorMessage, Colors.red);
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 2, 2, 2),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LoginForm(
                      onLogin: _loginUser,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: 16),

                    // Register Navigation
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => RegisterScreen()),
                        );
                      },
                      child: const Text("Go back to Register"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
