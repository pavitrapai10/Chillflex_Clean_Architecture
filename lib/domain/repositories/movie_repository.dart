import 'package:api/domain/entities/movie.dart';

abstract class MovieRepository {
  Future<List<Movie>> getMovies();
  Future<void> addMovie(String title, String overview); // ✅ Fixed: Pass title and overview instead of `Movie` object
  Future<void> updateMovie(int id, String title, String overview); // ✅ Fixed: Use ID and fields instead of `Movie`
  Future<void> deleteMovie(int id);
}
