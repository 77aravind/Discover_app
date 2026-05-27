import 'package:discover_app/features/discover/data/models/movie_model.dart';

abstract class MovieLocalDataSource {
  // 💾 അവസാനം കണ്ട സിനിമകൾ ഫോൺ മെമ്മറിയിലേക്ക് സേവ് ചെയ്യാൻ
  Future<void> cacheMovies(List<MovieModel> moviesToCache, String cacheKey);

  // 📖 ഫോൺ മെമ്മറിയിൽ സൂക്ഷിച്ച സിനിമകൾ തിരികെ എടുക്കാൻ
  Future<List<MovieModel>> getCachedMovies(String cacheKey);
}