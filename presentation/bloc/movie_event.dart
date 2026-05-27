import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object?> get props => [];
}

// 1. ട്രെൻഡിങ് സിനിമകൾ ലോഡ് ചെയ്യാനുള്ള ഇവന്റ്
class GetTrendingMoviesEvent extends MovieEvent {}

// 2. സിനിമകൾ സെർച്ച് ചെയ്യാനുള്ള ഇവന്റ്
class SearchMoviesEvent extends MovieEvent {
  final String query;
  const SearchMoviesEvent(this.query);

  @override
  List<Object?> get props => [query];
}

// 3. ജോണർ അനുസരിച്ച് സിനിമകൾ എടുക്കാനുള്ള ഇവന്റ്
class GetMoviesByGenreEvent extends MovieEvent {
  final String genreId;
  const GetMoviesByGenreEvent(this.genreId);

  @override
  List<Object?> get props => [genreId];
}