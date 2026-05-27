import 'package:discover_app/features/discover/data/models/movie_model.dart';

abstract class MovieRemoteDataSource {
  // 🎬 ട്രെൻഡിങ് സിനിമകൾ API-ൽ നിന്ന് എടുക്കാൻ
  Future<List<MovieModel>> getTrendingMovies();

  // 🔍 സിനിമകൾ API വഴി സെർച്ച് ചെയ്യാൻ
  Future<List<MovieModel>> searchMovies(String query);

  // 🎭 ജോണർ അനുസരിച്ച് സിനിമകൾ API-ൽ നിന്ന് എടുക്കാൻ
  Future<List<MovieModel>> getMoviesByGenre(String genreId);

  // 🔥 API-ൽ നിന്ന് Popular ഫോക്ക്സുള്ള ലിസ്റ്റ്
  Future<List<MovieModel>> getPopularMovies();

  // ⭐ Top rated movies
  Future<List<MovieModel>> getTopRatedMovies();
}