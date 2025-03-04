
import '../../data/models/movie_dto.dart';
class Movie {
  final int id;
  final String title;
  final String posterUrl;
  final String overview;

  Movie({required this.id, required this.title, required this.posterUrl, required this.overview});

  // Convert MovieDTO to Movie
  factory Movie.fromDTO(MovieDTO dto) {
    return Movie(
      id: dto.id,
      title: dto.title,
      posterUrl: "https://image.tmdb.org/t/p/w500${dto.posterPath}", // Assuming TMDB images
      overview: dto.overview,
    );
  }
}
