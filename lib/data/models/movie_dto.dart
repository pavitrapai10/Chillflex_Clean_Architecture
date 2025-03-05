import 'package:intl/intl.dart';

class MovieDTO {
  final int id;
  final String title;
  final String genre;
  final String releaseDate;

  MovieDTO({required this.id, required this.title, required this.genre, required this.releaseDate});

  factory MovieDTO.fromJson(Map<String, dynamic> json) {
    // Handle null or invalid date
    String rawDate = json['release_date'] ?? '0000-00-00';
    
    String formattedDate;
    try {
      DateTime parsedDate = DateTime.parse(rawDate);
      formattedDate = DateFormat('d MMM yyyy').format(parsedDate); // ✅ "3 Feb 2025"
    } catch (e) {
      formattedDate = "N/A"; // Fallback for invalid dates
    }

    return MovieDTO(
      id: json['id'],
      title: json['title'],
      genre: json['genre'],
      releaseDate: formattedDate, // ✅ Store formatted date
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'genre': genre,
      'release_date': releaseDate, // Ensure correct format
    };
  }
}
