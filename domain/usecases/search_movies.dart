import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/movie_entity.dart';
import '../repo/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  // ഇവിടെ ബ്രാക്കറ്റിനുള്ളിൽ ആവശ്യമായ പാരാമീറ്റർ (String query) നൽകണം
  Future<Either<Failure, List<MovieEntity>>> call(String query) async {
    return await repository.searchMovies(query);
  }
}