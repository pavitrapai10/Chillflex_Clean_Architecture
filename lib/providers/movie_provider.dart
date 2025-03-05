import 'package:flutter/material.dart';
import '../domain/entities/movie.dart';
import '../data/repositories/movie_repository_impl.dart';

class MovieProvider extends ChangeNotifier {
  final MovieRepositoryImpl _movieRepository = MovieRepositoryImpl();

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
    _errorMessage = null; // ✅ Clear error message if successful
  } catch (e) {
    _errorMessage = e.toString(); // ✅ Display actual API error message
    print("Error fetching movies: $_errorMessage");
  }

  _isLoading = false;
  notifyListeners();
}


  Future<void> addMovie(String title, String genre, String releaseDate) async {
    try {
      await _movieRepository.addMovie(title, genre, releaseDate);
      _movies.add(Movie(id: _movies.length + 1, title: title, genre: genre, releaseDate: releaseDate));
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to add movie";
    }
  }

  Future<void> updateMovie(int id, String title, String genre, String releaseDate) async {
    try {
      await _movieRepository.updateMovie(id, title, genre, releaseDate);
      int index = _movies.indexWhere((m) => m.id == id);
      if (index != -1) {
        _movies[index] = Movie(id: id, title: title, genre: genre, releaseDate: releaseDate);
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
