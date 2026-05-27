import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:discover_app/core/errors/exceptions.dart';
import 'package:discover_app/features/discover/data/models/movie_model.dart';
import 'movie_local_data_source.dart';

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final Box movieBox; // Hive ഡാറ്റാബേസ് ബോക്സ്

  MovieLocalDataSourceImpl({required this.movieBox});

  @override
  Future<void> cacheMovies(List<MovieModel> moviesToCache, String cacheKey) async {
    // 💾 മോഡലുകളെ JSON സ്ട്രിങ് ആക്കി മാറ്റി Hive-ലേക്ക് സേവ് ചെയ്യുന്നു
    final List<String> jsonStringList = moviesToCache
        .map((movie) => json.encode(movie.toJson()))
        .toList();
        
    await movieBox.put(cacheKey, jsonStringList);
  }

  @override
  Future<List<MovieModel>> getCachedMovies(String cacheKey) async {
    // 📖 Hive-ൽ നിന്ന് ഡാറ്റ തിരികെ എടുക്കുന്നു
    final List<dynamic>? cachedData = movieBox.get(cacheKey);
    
    if (cachedData != null) {
      return cachedData
          .map((jsonString) => MovieModel.fromJson(json.decode(jsonString)))
          .toList();
    } else {
      // ലോക്കൽ മെമ്മറിയിൽ ഡാറ്റ ഒന്നും ഇല്ലെങ്കിൽ CacheException എറിയുന്നു
      throw CacheException();
    }
  }
}