import '../../domain/entities/movie.dart';
import '../datasources/api.dart';

class MovieRepositoryImpl {
  Future<List<Movie>> fetchMovies() async {
    return await ApiService.fetchMovies(); // ✅ Accessing static method correctly
  }

  Future<void> addMovie(String title, String genre, String releaseDate) async {
    await ApiService.addMovie(title, genre, releaseDate); // ✅ Fix
  }

  Future<void> updateMovie(int id, String title, String genre, String releaseDate) async {
    await ApiService.updateMovie(id, title, genre, releaseDate); // ✅ Fix
  }

  Future<void> deleteMovie(int id) async {
    await ApiService.deleteMovie(id); // ✅ Fix
  }
}
