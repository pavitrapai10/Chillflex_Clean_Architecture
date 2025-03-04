import 'package:api/data/datasources/api.dart';
import 'package:api/domain/entities/movie.dart';
import 'package:api/domain/repositories/movie_repository.dart';

class MovieRepositoryImpl implements MovieRepository {
  final ApiService apiService;

  MovieRepositoryImpl({required this.apiService});

  @override
  Future<List<Movie>> getMovies() async {
    return await ApiService.fetchMovies();
  }

  @override
  Future<void> addMovie(Movie movie) async {
    await ApiService.addMovie(movie.title, movie.overview); 
  }

  @override
  Future<void> updateMovie(Movie movie) async {
    await ApiService.updateMovie(movie);
  }

  @override
  Future<void> deleteMovie(int id) async {
    await ApiService.deleteMovie(id);
  }
}
