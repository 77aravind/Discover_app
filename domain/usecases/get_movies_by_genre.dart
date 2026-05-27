import 'package:dartz/dartz.dart';
import 'package:discover_app/core/errors/failures.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';
import 'package:discover_app/features/discover/domain/repo/movie_repository.dart';

class MoviesByGenre {
  final MovieRepository repository;

  MoviesByGenre(this.repository);

  Future<Either<Failure, List<MovieEntity>>> call(String genreId) async {
    return await repository.getMoviesByGenre(genreId);
  }
}