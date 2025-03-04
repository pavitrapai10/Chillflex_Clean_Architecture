import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../domain/entities/movie.dart';
import '../../data/models/movie_dto.dart';

class ApiService {
  static const String baseUrl = "https://192.168.1.45:7173/api";
  static final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Get the stored auth token
  static Future<String?> getToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  // Register User
  static Future<Map<String, dynamic>> registerUser(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/Auth/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      final responseData = jsonDecode(response.body);
      return {
        "statusCode": response.statusCode,
        "message": responseData["message"] ?? "Unexpected error occurred"
      };
    } catch (e) {
      return {"statusCode": 0, "message": "Network error. Please try again."};
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

      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);

        // Convert List<MovieDTO> to List<Movie>
        List<Movie> movies = jsonData.map((json) => Movie.fromDTO(MovieDTO.fromJson(json))).toList();

        return movies;
      } else {
        throw Exception("Failed to load movies: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching movies: $e");
    }
  }

  // ✅ Add a New Movie (POST)
  static Future<bool> addMovie(String title, String overview) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception("Unauthorized: Please login again.");

      final response = await http.post(
        Uri.parse("$baseUrl/Movies"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "title": title,
          "overview": overview,
        }),
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        throw Exception("Failed to add movie: ${response.body}");
      }
    } catch (e) {
      throw Exception("Error adding movie: $e");
    }
  }

  // ✅ Update Movie (PUT)
  static Future<void> updateMovie(Movie movie) async {
    try {
      String? token = await getToken();
      if (token == null) throw Exception("Unauthorized: Please login again.");

      final Uri url = Uri.parse("$baseUrl/Movies/${movie.id}");

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "id": movie.id,
          "title": movie.title,
          "overview": movie.overview,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print("Movie updated successfully!");
      } else if (response.statusCode == 404) {
        throw Exception("Failed to update movie: Movie not found (404). Check if ID ${movie.id} exists.");
      } else {
        throw Exception("Failed to update movie. Server responded with ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error updating movie: $e");
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
