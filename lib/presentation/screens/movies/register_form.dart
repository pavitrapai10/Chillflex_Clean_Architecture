import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';

class RegisterForm extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const RegisterForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Username Field
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              errorText: authProvider.usernameError,
            ),
            onChanged: authProvider.validateUsername,
          ),
          const SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: passwordController,
            obscureText: !authProvider.isPasswordVisible,
            decoration: InputDecoration(
              labelText: "Password",
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(authProvider.isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                onPressed: authProvider.togglePasswordVisibility,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              errorText: authProvider.passwordError,
            ),
            onChanged: authProvider.validatePassword,
          ),
          const SizedBox(height: 24),

          // Register Button
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: authProvider.isLoading ? null : () => authProvider.register(context, usernameController.text, passwordController.text),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 207, 207, 196),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: authProvider.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Register", style: TextStyle(fontSize: 18)),
            ),
          ),

          // Error Message
          if (authProvider.errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                authProvider.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
        ],
      ),
    );
  }
}
