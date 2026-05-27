import 'package:equatable/equatable.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';

abstract class MovieState extends Equatable {
  const MovieState();
  
  @override
  List<Object?> get props => [];
}

// ⏳ 1. ഡാറ്റ ലോഡ് ചെയ്യാൻ തുടങ്ങുന്നതിന് മുൻപുള്ള അവസ്ഥ
class MovieInitial extends MovieState {}

// 🔄 2. ഇന്റർനെറ്റിൽ നിന്ന് ഡാറ്റ എടുത്തുകൊണ്ടിരിക്കുമ്പോൾ (Shimmer/Spinner കാണിക്കാൻ)
class MovieLoading extends MovieState {}

// ✅ 3. ഡാറ്റ വിജയകരമായി കിട്ടിക്കഴിഞ്ഞാൽ (സിനിമകളുടെ ലിസ്റ്റ് UI-ലേക്ക് കൊടുക്കുന്നു)
class MovieLoaded extends MovieState {
  final List<MovieEntity> movies;
  const MovieLoaded(this.movies);

  @override
  List<Object?> get props => [movies];
}

// ❌ 4. എന്തെങ്കിലും എറർ ഉണ്ടായാൽ (Server Error / No Internet)
class MovieError extends MovieState {
  final String message;
  const MovieError(this.message);

  @override
  List<Object?> get props => [message];
}