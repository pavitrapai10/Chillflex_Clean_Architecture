import 'package:flutter/material.dart';

class LoginForm extends StatefulWidget {
  final Function(String, String) onLogin;
  final bool isLoading;

  const LoginForm({Key? key, required this.onLogin, this.isLoading = false}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {



  
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _usernameError;
  String? _passwordError;
  final _formKey = GlobalKey<FormState>();

  void _validateUsername(String value) {
    setState(() {
      _usernameError = value.isEmpty ? "Username is required" : null;
    });
  }

  void _validatePassword(String value) {
    setState(() {
      if (value.isEmpty) {
        _passwordError = "Password is required";
      } else if (value.length < 8) {
        _passwordError = "Minimum 8 characters required";
      } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
        _passwordError = "Must contain 1 uppercase letter";
      } else if (!RegExp(r'[a-z]').hasMatch(value)) {
        _passwordError = "Must contain 1 lowercase letter";
      } else if (!RegExp(r'\d').hasMatch(value)) {
        _passwordError = "Must contain 1 digit";
      } else if (!RegExp(r'[@\$!%*?&]').hasMatch(value)) {
        _passwordError = "Must contain 1 special character";
      } else {
        _passwordError = null;
      }
    });
  }

  void _submitForm() {
    String username = _usernameController.text.trim();
    String password = _passwordController.text;

    _validateUsername(username);
    _validatePassword(password);

    if (_usernameError == null && _passwordError == null) {
      widget.onLogin(username, password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage("assets/logo.png"),
            backgroundColor: Colors.transparent,
          ),
          const SizedBox(height: 20),

          const Text(
            "Login",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),

          // Username Field
          TextFormField(
            controller: _usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              errorText: _usernameError,
            ),
            onChanged: _validateUsername,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              errorText: _passwordError,
            ),
            onChanged: _validatePassword,
          ),
          const SizedBox(height: 24),

          // Login Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : _submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 207, 196),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: widget.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Login", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }
}
