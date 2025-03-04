class MovieDTO {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  MovieDTO({required this.id, required this.title, required this.posterPath, required this.overview});

  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    return MovieDTO(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '',
      overview: json['overview'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_path': posterPath,
      'overview': overview,
    };
  }
}
