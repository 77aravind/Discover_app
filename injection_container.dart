import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:hive/hive.dart'; // 👈 Hive ബോക്സ് ടൈപ്പ് മനസ്സിലാക്കാൻ ഇത് നിർബന്ധമാണ്

// 🔗 നിങ്ങളുടെ പ്രൊജക്റ്റ് സ്ട്രക്ചറിന് അനുസരിച്ചുള്ള കൃത്യമായ ഇമ്പോർട്ടുകൾ
import 'package:discover_app/features/discover/data/data_Sources/movie_remote_data_source_impl.dart';
import 'package:discover_app/features/discover/data/data_Sources/movie_remote_data_source.dart';
import 'package:discover_app/features/discover/data/data_Sources/movie_local_data_source_impl.dart';
import 'package:discover_app/features/discover/data/data_Sources/movie_local_data_source.dart';
import 'package:discover_app/features/discover/data/repo/movie_repository_impl.dart';
import 'package:discover_app/features/discover/domain/repo/movie_repository.dart';
import 'package:discover_app/features/discover/domain/usecases/get_trending_movies.dart';
import 'package:discover_app/features/discover/presentation/bloc/movie_bloc.dart';
import 'package:discover_app/core/platform/network_info.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Discover Movies
  
  // 1. Factory (ആവശ്യം വരുമ്പോൾ പുതിയ Bloc ഇൻസ്റ്റൻസ് ഉണ്ടാക്കാൻ)
  sl.registerFactory(() => MovieBloc(getTrendingMovies: sl<GetTrendingMovies>()));

  // 2. Use cases
  sl.registerLazySingleton(() => GetTrendingMovies(sl<MovieRepository>()));

  // 3. Repository
  sl.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: sl<MovieRemoteDataSource>(),
      localDataSource: sl<MovieLocalDataSource>(),
      networkInfo: sl<NetworkInfo>(),
    ),
  );

  // 4. Data sources
  sl.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: sl<http.Client>()),
  );
  
  // 🌟 നിങ്ങളുടെ movie_local_data_source_impl-ലേക്ക് Hive Box പാസ്സ് ചെയ്യുന്നു
  sl.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(movieBox: sl<Box>()), 
  );

  // Network info (simple implementation)
  sl.registerLazySingleton<NetworkInfo>(() => AlwaysConnectedNetworkInfo());

  //! External (തേർഡ് പാർട്ടി ലൈബ്രറികൾ)
  sl.registerLazySingleton(() => http.Client());

  // 📦 Hive ഡാറ്റാബേസ് ബോക്സ് തുറന്ന് Service Locator-ൽ രജിസ്റ്റർ ചെയ്യുന്നു
  final Box movieBox = await Hive.openBox('movieBox');
  sl.registerLazySingleton<Box>(() => movieBox);
}