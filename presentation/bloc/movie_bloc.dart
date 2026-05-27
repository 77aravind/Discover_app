import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:discover_app/features/discover/domain/usecases/get_trending_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTrendingMovies getTrendingMovies; // നമ്മൾ ഉണ്ടാക്കിയ Use Case

  MovieBloc({required this.getTrendingMovies}) : super(MovieInitial()) {
    
    // ട്രെൻഡിങ് സിനിമകളുടെ ഇവന്റ് വരുമ്പോൾ നടക്കേണ്ട ലോജിക്
    on<GetTrendingMoviesEvent>((event, emit) async {
      emit(MovieLoading()); // ആദ്യം ലോഡിങ് സ്റ്റേറ്റ് കാണിക്കുന്നു
      
      // യുസ്കേസ് വിളിക്കുന്നു (call() ഫങ്ഷൻ ഉള്ളതുകൊണ്ട് നേരിട്ട് വിളിക്കാം)
      final result = await getTrendingMovies();
      
      // dartz പാക്കേജിന്റെ fold ഉപയോഗിച്ച് Left (Error) ആണോ Right (Success) ആണോ എന്ന് നോക്കുന്നു
      result.fold(
        (failure) => emit(MovieError(failure.message)), // എറർ സ്റ്റേറ്റ്
        (movies) => emit(MovieLoaded(movies)),          // സക്സസ് സ്റ്റേറ്റ്
      );
    });
  }
}