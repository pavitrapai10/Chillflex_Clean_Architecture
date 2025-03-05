import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/movie.dart';
import '../../data/models/movie_dto.dart';

class ApiService {
  static const String baseUrl = "https://192.168.1.7:7173/api";
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get the stored auth token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Register User
  static Future<Map<String, dynamic>> registerUser(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/Auth/register"), // Ensure this is correct
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username, "password": password}),
    );

    print("🔹 Registration API Response Status Code: ${response.statusCode}");
    print("🔹 Registration API Response Body: ${response.body}");

    // ✅ Check if registration is successful (200 or 201)
    if (response.statusCode == 200 || response.statusCode == 201) {
      return {"success": true, "message": "Registration successful"};
    }

    // Registration failed, extract error message
    final Map<String, dynamic> responseData = jsonDecode(response.body);
    return {"success": false, "message": responseData["message"] ?? "Unexpected error occurred"};
  } catch (e) {
    print("API Request Failed: $e");
    return {"success": false, "message": "Network error occurred"};
  }
}

  // Login User
  static Future<Map<String, dynamic>> loginUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/Auth/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      return responseData;
    } catch (e) {
      throw Exception("Error logging in: $e");
    }
  }

  // ✅ Fetch Movies (GET)
  static Future<List<Movie>> fetchMovies() async {
  try {
    String? token = await getToken();
    if (token == null) throw Exception("No Auth Token Found! Please login again.");

    final response = await http.get(
      Uri.parse("$baseUrl/Movies"),
      headers: {'Authorization': 'Bearer $token'},
    );

    print("API Response Status Code: ${response.statusCode}");
    print("API Response Body: ${response.body}");

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);

      // 🛠 Ensure parsing is correct
      print("Parsed Movies List: $jsonData");

      List<Movie> movies = jsonData.map((json) {
        print("Parsing Movie: $json");
        return Movie.fromDTO(MovieDTO.fromJson(json));
      }).toList();

      return movies;
    } else {
      // 🛠 Handle backend error messages dynamically
      Map<String, dynamic> errorResponse = jsonDecode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to load movies: ${response.statusCode}");
    }
  } catch (e) {
    print("Error fetching movies: $e");
    throw Exception("Error fetching movies: $e");
  }
}

 static Future<bool> addMovie(String title, String genre, String releaseDate) async {
  try {
    String? token = await getToken();
    if (token == null) throw Exception("Unauthorized: Please login again.");

    final Uri url = Uri.parse("$baseUrl/Movies");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "title": title,
        "genre": genre,
        "releaseDate": releaseDate,
      }),
    );

    if (response.statusCode == 201) {
      print("Movie added successfully!");
      return true;
    } else {
      throw Exception("Failed to add movie. Server responded with ${response.statusCode}");
    }
  } catch (e) {
    print("Error adding movie: $e");
    return false;
  }
}


  // ✅ Update Movie (PUT)
 static Future<bool> updateMovie(int id, String title, String genre, String releaseDate) async {
  try {
    String? token = await getToken();
    if (token == null) throw Exception("Unauthorized: Please login again.");

    final Uri url = Uri.parse("$baseUrl/Movies/$id");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        "id": id,
        "title": title,
        "genre": genre,
        "releaseDate": releaseDate,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Movie updated successfully!");
      return true;
    } else {
      throw Exception("Failed to update movie. Server responded with ${response.statusCode}");
    }
  } catch (e) {
    print("Error updating movie: $e");
    return false;
  }
}


  // ✅ Delete a Movie (DELETE)
  static Future<bool> deleteMovie(int id) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception("Unauthorized: Please login again.");

      final response = await http.delete(
        Uri.parse("$baseUrl/Movies/$id"),
        headers: {
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        throw Exception("Failed to delete movie: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error deleting movie: $e");
    }
  }
}
