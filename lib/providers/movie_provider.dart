import 'package:flutter/material.dart';
import '../domain/entities/movie.dart';
import '../data/repositories/movie_repository_impl.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepository _movieRepository = MovieRepository();

  List<Movie> _movies = [];
  List<Movie> get movies => _movies;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  MovieProvider() {
    fetchMovies();
  }

  Future<void> fetchMovies() async {
    _isLoading = true;
    notifyListeners();
    try {
      _movies = await _movieRepository.fetchMovies();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = "Failed to load movies";
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addMovie(Movie movie) async {
    try {
      await _movieRepository.addMovie(movie);
      _movies.add(movie);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to add movie";
    }
  }

  Future<void> updateMovie(Movie updatedMovie) async {
    try {
      await _movieRepository.updateMovie(updatedMovie);
      int index = _movies.indexWhere((m) => m.id == updatedMovie.id);
      if (index != -1) {
        _movies[index] = updatedMovie;
      }
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to update movie";
    }
  }

  Future<void> deleteMovie(int id) async {
    try {
      await _movieRepository.deleteMovie(id);
      _movies.removeWhere((m) => m.id == id);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to delete movie";
    }
  }
}
