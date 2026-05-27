import 'package:dartz/dartz.dart';
import 'package:discover_app/core/errors/failures.dart';
import 'package:discover_app/core/errors/exceptions.dart';
import 'package:discover_app/features/discover/data/models/movie_model.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';
import 'package:discover_app/features/discover/domain/repo/movie_repository.dart';
import 'package:discover_app/features/discover/data/data_Sources/movie_remote_data_source.dart';
import 'package:discover_app/features/discover/data/data_Sources/movie_local_data_source.dart';

class MovieRepositoryImpl implements MovieRepository {
  final MovieRemoteDataSource remoteDataSource;
  final MovieLocalDataSource localDataSource;
  final dynamic networkInfo; // ഇന്റർനെറ്റ് ഉണ്ടോ എന്ന് ചെക്ക് ചെയ്യാനുള്ള വേരിയബിൾ

  MovieRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  String _cacheKey(String suffix) => 'CACHED_MOVIES_$suffix';

  Future<Either<Failure, List<MovieEntity>>> _fetchRemoteMovies(
    Future<List<MovieModel>> Function() fetchRemote, {
    bool cacheResult = false,
    required String cacheKey,
  }) async {
    final isConnected = await networkInfo.isConnected;

    if (isConnected) {
      try {
        final remoteMovies = await fetchRemote();

        if (cacheResult && remoteMovies.isNotEmpty) {
          await localDataSource.cacheMovies(remoteMovies, cacheKey);
        }

        return Right(remoteMovies);
      } on ServerException {
        try {
          final localMovies = await localDataSource.getCachedMovies(cacheKey);
          return Right(localMovies);
        } on CacheException {
          return const Right([]);
        }
      }
    }

    try {
      final localMovies = await localDataSource.getCachedMovies(cacheKey);
      return Right(localMovies);
    } on CacheException {
      return const Right([]);
    }
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getTrendingMovies() async {
    return _fetchRemoteMovies(
      () => remoteDataSource.getTrendingMovies(),
      cacheResult: true,
      cacheKey: _cacheKey('trending'),
    );
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getPopularMovies() async {
    return _fetchRemoteMovies(
      () => remoteDataSource.getPopularMovies(),
      cacheKey: _cacheKey('popular'),
    );
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getTopRatedMovies() async {
    return _fetchRemoteMovies(
      () => remoteDataSource.getTopRatedMovies(),
      cacheKey: _cacheKey('top_rated'),
    );
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> searchMovies(String query) async {
    return _fetchRemoteMovies(
      () => remoteDataSource.searchMovies(query),
      cacheKey: _cacheKey('search_${query.trim().toLowerCase()}'),
    );
  }

  @override
  Future<Either<Failure, List<MovieEntity>>> getMoviesByGenre(String genreId) async {
    return _fetchRemoteMovies(
      () => remoteDataSource.getMoviesByGenre(genreId),
      cacheKey: _cacheKey('genre_$genreId'),
    );
  }
}