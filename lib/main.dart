import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/movies/login_form.dart';
import 'providers/auth_provider.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides(); // Allow self-signed SSL certificates
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()), // Provide AuthProvider globally
      ],
      child: MaterialApp(
        title: "Movie App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink,
          scaffoldBackgroundColor: Colors.white,
        ),
        home: RegisterScreen(), // Change to LoginScreen() if needed
      ),
    );
  }
}
