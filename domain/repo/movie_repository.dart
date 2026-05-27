import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_entity.dart';

abstract class MovieRepository {
  // 🎬 1. ട്രെൻഡിങ് സിനിമകൾ ലിസ്റ്റ് ചെയ്യാൻ വേണ്ടി
  Future<Either<Failure, List<MovieEntity>>> getTrendingMovies();

  // 🔥 2. Popular movies
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies();

  // ⭐ 3. Top rated movies
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies();

  // 🔍 4. സെർച്ച് ബാറിൽ സിനിമകൾ തിരയാൻ വേണ്ടി
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query);

  // 🎭 5. ജോണർ അനുസരിച്ച് സിനിമകൾ എടുക്കാൻ വേണ്ടി
  Future<Either<Failure, List<MovieEntity>>> getMoviesByGenre(String genreId);
}