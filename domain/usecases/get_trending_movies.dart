import 'package:dartz/dartz.dart';
import 'package:discover_app/core/errors/failures.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';
import 'package:discover_app/features/discover/domain/repo/movie_repository.dart';

class GetTrendingMovies {
  final MovieRepository repository;

  GetTrendingMovies(this.repository);

  // call() ഫങ്ഷൻ ഉപയോഗിക്കുന്നത് വഴി ഈ ക്ലാസ്സിനെ ഒരു ഫങ്ഷൻ പോലെ നേരിട്ട് വിളിക്കാം
  Future<Either<Failure, List<MovieEntity>>> call() async {
    return await repository.getTrendingMovies();
  }
}