import '../../data/models/movie_dto.dart';

class Movie {
  final int id;
  final String title;
  final String genre;
  final String releaseDate;

  Movie({required this.id, required this.title, required this.genre, required this.releaseDate});

  // Convert MovieDTO to Movie
  factory Movie.fromDTO(MovieDTO dto) {
    return Movie(
      id: dto.id,
      title: dto.title,
      genre: dto.genre,
      releaseDate: dto.releaseDate,
    );
  }
}
