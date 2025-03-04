import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/movie_card.dart';
import '../../../providers/movie_provider.dart';
import 'addmovie.dart';

class MovieListScreen extends StatelessWidget {
  const MovieListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MovieProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChillFlex', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: movieProvider.fetchMovies,
          ),
        ],
      ),
      body: movieProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : movieProvider.errorMessage != null
              ? Center(child: Text(movieProvider.errorMessage!))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: movieProvider.movies.length,
                  itemBuilder: (context, index) {
                    return MovieCard(movie: movieProvider.movies[index]);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddMovieScreen()),
        ).then((_) => movieProvider.fetchMovies()),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
