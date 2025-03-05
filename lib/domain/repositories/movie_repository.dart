abstract class MovieRepository {
  Future<void> addMovie(String title, String genre, String releaseDate);
  Future<void> updateMovie(int id, String title, String genre, String releaseDate);
  Future<void> deleteMovie(int id);
}
