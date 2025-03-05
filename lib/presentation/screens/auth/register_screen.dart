import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/auth_provider.dart';
import '../../screens/movies/register_form.dart';

class RegisterScreen extends StatelessWidget {
  // Declare controllers and form key
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: ChangeNotifierProvider(
        create: (_) => AuthProvider(),
        child: Center(
          child: SingleChildScrollView(
            child: RegisterForm(
              usernameController: usernameController,
              passwordController: passwordController,
              formKey: formKey,
            ),
          ),
        ),
      ),
    );
  }
}
