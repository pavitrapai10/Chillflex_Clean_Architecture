import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/movie_provider.dart';
import '../../../providers/auth_provider.dart';
import '../auth/login.dart';  // Ensure this is the correct path for your login screen
import 'addmovie.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChillFlex', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        actions: [
          IconButton( // ✅ Logout Button
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logoutUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to Login
                (route) => false, // Remove all previous routes
              );
            },
          ),
        ],
      ),
      body: Consumer<MovieProvider>(
        builder: (context, movieProvider, child) {
          if (movieProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (movieProvider.errorMessage != null) {
            return Center(child: Text(movieProvider.errorMessage!, style: const TextStyle(color: Colors.red)));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: movieProvider.movies.length,
              itemBuilder: (context, index) {
                final movie = movieProvider.movies[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 3,
                  child: ListTile(
                    leading: const Icon(Icons.movie, color: Colors.red),
                    title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                    "Genre: ${movie.genre}\nRelease: ${movie.releaseDate}",
                     style: const TextStyle(color: Colors.black54),
                     ),

                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton( // Edit button
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _showEditDialog(context, movieProvider, movie),
                        ),
                        IconButton( // Delete button
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _showDeleteDialog(context, movieProvider, movie.id),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
     floatingActionButton: FloatingActionButton(
  backgroundColor: Colors.red,
  child: Icon(Icons.add),
  onPressed: () async {
    bool? movieAdded = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddMovieScreen()),
    );

    if (movieAdded == true) {
      Provider.of<MovieProvider>(context, listen: false).fetchMovies(); // ✅ Refresh list after adding movie
    }
  },
),

    );
  }

  // Show Confirmation Dialog for Deleting a Movie
  void _showDeleteDialog(BuildContext context, MovieProvider movieProvider, int movieId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this movie?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await movieProvider.deleteMovie(movieId);
                _showSuccessDialog(context, "Movie deleted successfully!");
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Show Edit Dialog with Calendar Picker for Release Date
  void _showEditDialog(BuildContext context, MovieProvider movieProvider, movie) {
    TextEditingController titleController = TextEditingController(text: movie.title);
    TextEditingController genreController = TextEditingController(text: movie.genre);
    TextEditingController dateController = TextEditingController(text: movie.releaseDate);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Movie"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: "Genre"),
              ),
              TextField(
                controller: dateController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Release Date",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    dateController.text = pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await movieProvider.updateMovie(
                  movie.id,
                  titleController.text,
                  genreController.text,
                  dateController.text,
                );
                _showSuccessDialog(context, "Movie updated successfully!");
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  // Show Success Dialog
  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Success"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
