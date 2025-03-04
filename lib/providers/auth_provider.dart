import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../data/datasources/api.dart'; // Ensure this API file exists

class AuthProvider with ChangeNotifier {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  bool _isAuthenticated = false;
  String? _authToken;

  bool get isAuthenticated => _isAuthenticated;
  String? get authToken => _authToken;

  // 🔹 State Variables
  bool _isLoading = false;
  String? _usernameError;
  String? _passwordError;
  String _errorMessage = "";
  bool _isPasswordVisible = false;

  // 🔹 Getters for UI
  bool get isLoading => _isLoading;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;
  String get errorMessage => _errorMessage;
  bool get isPasswordVisible => _isPasswordVisible;

  // 1️ **Validate Username**
  void validateUsername(String username) {
    if (username.isEmpty) {
      _usernameError = "Username cannot be empty";
    } else {
      _usernameError = null;
    }
    notifyListeners();
  }

  // 2️ **Validate Password**
  void validatePassword(String password) {
    if (password.length < 8) {
      _passwordError = "Password must be at least 8 characters";
    } else {
      _passwordError = null;
    }
    notifyListeners();
  }

  // 3️ **Toggle Password Visibility**
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  // 4️⃣ **User Registration**
  Future<void> register(BuildContext context, String username, String password) async {
    _isLoading = true;
    _errorMessage = "";
    notifyListeners();

    try {
      bool success = await registerUser(username, password);
      if (success) {
        Navigator.pop(context); // Go back to login screen after successful registration
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll("Exception: ", "");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 5️ **User Registration API Call**
  Future<bool> registerUser(String username, String password) async {
    try {
      final response = await ApiService.registerUser(username, password);

      if (response.containsKey("message") && response["message"] == "Registration successful") {
        return true; // Registration succeeded
      } else {
        throw Exception(response["message"] ?? "Registration failed");
      }
    } catch (e) {
      throw Exception("Registration error: ${e.toString()}");
    }
  }

  // 6️ **User Login**
  Future<bool> loginUser(String username, String password) async {
    try {
      final response = await ApiService.loginUser(username, password);

      if (response.containsKey("token")) {
        _authToken = response["token"];
        _isAuthenticated = true;

        // Save token securely
        await _secureStorage.write(key: "auth_token", value: _authToken);
        await _secureStorage.write(key: "username", value: username);

        notifyListeners();
        return true;
      } else {
        throw Exception(response["message"] ?? "Login failed");
      }
    } catch (e) {
      throw Exception("Login error: ${e.toString()}");
    }
  }

  // 7️ **User Logout**
  Future<void> logoutUser() async {
    _authToken = null;
    _isAuthenticated = false;

    await _secureStorage.delete(key: "auth_token");
    await _secureStorage.delete(key: "username");

    notifyListeners();
  }

  // 8️ **Check Auth Status (Persists Login)**
  Future<void> checkAuthStatus() async {
    _authToken = await _secureStorage.read(key: "auth_token");
    _isAuthenticated = _authToken != null;

    notifyListeners();
  }
}
