import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/screens/auth/register_screen.dart';
import 'presentation/screens/movies/login_form.dart';
import 'presentation/screens/movies/movie_listscreen.dart'; // Import movie screen
import 'providers/auth_provider.dart';
import 'providers/movie_provider.dart'; // Import movie provider

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
        ChangeNotifierProvider(create: (context) => AuthProvider()), // ✅ AuthProvider
        ChangeNotifierProvider(create: (context) => MovieProvider()), // ✅ MovieProvider added
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
