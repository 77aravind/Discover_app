import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:discover_app/core/errors/failures.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';

class MovieHorizontalList extends StatelessWidget {
  final Future<Either<Failure, List<MovieEntity>>> moviesFuture;

  const MovieHorizontalList({super.key, required this.moviesFuture});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: FutureBuilder<Either<Failure, List<MovieEntity>>>(
        future: moviesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colors.red));
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Movie suggestions are unavailable right now',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }

          final result = snapshot.data;
          if (result == null) {
            return const Center(
              child: Text(
                'Movie suggestions are unavailable right now',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }

          final movies = result.fold<List<MovieEntity>>((failure) => const <MovieEntity>[], (movies) => movies);

          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'More movie suggestions will appear here soon',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
                final imageUrl = movie.posterPath.isNotEmpty
                  ? (movie.posterPath.startsWith('http')
                    ? movie.posterPath
                    : 'https://image.tmdb.org/t/p/w500${movie.posterPath}')
                  : null;

              return Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: Colors.grey[900]),
                      if (imageUrl != null)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(child: CircularProgressIndicator(color: Colors.red, strokeWidth: 2));
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 36));
                          },
                        )
                      else
                        const Center(child: Icon(Icons.movie, color: Colors.white54, size: 36)),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.transparent, Color.fromRGBO(0, 0, 0, 0.7)],
                            ),
                          ),
                          child: Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
