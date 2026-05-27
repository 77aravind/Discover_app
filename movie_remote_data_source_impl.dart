import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:discover_app/core/errors/exceptions.dart';
import 'package:discover_app/features/discover/data/models/movie_model.dart';
import 'movie_remote_data_source.dart';

class MovieRemoteDataSourceImpl implements MovieRemoteDataSource {
  final http.Client client;

  // 🔑 നിന്റെ കറക്റ്റ് TMDB API key
  static const String _tmdbApiKey = "cd5ff62e16112e852e199e36dd87000c";
  static const bool _useProxyOnWeb = true;

  MovieRemoteDataSourceImpl({required this.client});

  Uri _buildTmdbUri(String path, [Map<String, String>? extraParams]) {
    final queryParameters = <String, String>{
      'api_key': _tmdbApiKey,
      'language': 'en-US',
      'page': '1',
    };

    if (extraParams != null) queryParameters.addAll(extraParams);

    return Uri.https('api.themoviedb.org', '/3/$path', queryParameters);
  }

  Uri _wrapWithProxy(Uri url) {
    // Try a couple of public CORS-friendly proxies; TMDB itself is often blocked in browsers.
    // The last one is a raw passthrough format used by some proxy services.
    final encoded = Uri.encodeComponent(url.toString());
    return Uri.parse('https://api.allorigins.win/raw?url=$encoded');
  }

  // 📡 TMDB കോമൺ ഫങ്ഷൻ - ഡാറ്റാ വേർതിരിവും സുരക്ഷിതമായ ഇമേജ് പാത്തും ഇവിടെ ഉറപ്പാക്കുന്നു
  Future<List<MovieModel>> _fetchFromTmdb(String path, [Map<String, String>? extraParams]) async {
    if (_tmdbApiKey.isEmpty) throw ServerException();

    final queryUrl = _buildTmdbUri(path, extraParams);
    final List<Uri> candidateUrls = [
      if (_useProxyOnWeb) _wrapWithProxy(queryUrl) else queryUrl,
      queryUrl,
    ];

    http.Response? response;
    for (final candidate in candidateUrls) {
      try {
        final res = await client.get(candidate);
        if (res.statusCode == 200) {
          response = res;
          break;
        }
      } catch (_) {
        continue;
      }
    }

    if (response == null) throw ServerException();

    final dynamic decodedJson = json.decode(response.body);
    final Map<String, dynamic> decoded = decodedJson is Map<String, dynamic>
        ? decodedJson
        : decodedJson is Map
            ? Map<String, dynamic>.from(decodedJson)
            : <String, dynamic>{};

    final List<dynamic> results = decoded['results'] is List ? List<dynamic>.from(decoded['results']) : [];

    final List<MovieModel> movies = [];
    for (var item in results) {
      try {
        final Map<String, dynamic> movieMap = Map<String, dynamic>.from(item);
        
        // 🖼️ Keep TMDB's poster_path value and let the UI resolve the final image URL.
        String poster = movieMap['poster_path'] ?? '';
        if (poster.isNotEmpty) {
          movieMap['poster_path'] = poster;
        } else {
          movieMap['poster_path'] = '';
        }

        if (movieMap['vote_average'] == null) {
          movieMap['vote_average'] = 7.5;
        }

        movies.add(MovieModel.fromJson(movieMap));
      } catch (e) {
        continue;
      }
    }
    return movies;
  }

  // 1️⃣ Trending Movies - തീയേറ്ററുകളിൽ ഇപ്പോൾ ഓടുന്ന ട്രെൻഡിംഗ് സിനിമകൾ
  @override
  Future<List<MovieModel>> getTrendingMovies() async {
    return await _fetchFromTmdb('trending/movie/week');
  }

  // 2️⃣ Popular Movies - ഇതിലേക്ക് തികച്ചും വ്യത്യസ്തമായ 'Popular' സിനിമകൾ മാറ്റുന്നു (ഇവിടെ തനിയെ ലിസ്റ്റ് മാറും)
  @override
  Future<List<MovieModel>> getPopularMovies() async {
    return await _fetchFromTmdb('movie/popular');
  }

  // 3️⃣ Top Rated Movies - എക്കാലത്തെയും മികച്ച സിനിമകൾ
  @override
  Future<List<MovieModel>> getTopRatedMovies() async {
    return await _fetchFromTmdb('movie/top_rated');
  }

  // 4️⃣ Get Movies By Genre
  @override
  Future<List<MovieModel>> getMoviesByGenre(String genreId) async {
    return await _fetchFromTmdb('discover/movie', {'with_genres': genreId});
  }

  // 5️⃣ Search Movies
  @override
  Future<List<MovieModel>> searchMovies(String query) async {
    if (query.trim().isEmpty) return const [];
    return await _fetchFromTmdb('search/movie', {
      'query': query, 
      'include_adult': 'false'
    });
  }
}