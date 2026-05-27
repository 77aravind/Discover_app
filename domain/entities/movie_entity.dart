import 'package:equatable/equatable.dart';

// ആപ്പിൽ സിനിമകൾക്ക് വേണ്ടി മാത്രം ഉപയോഗിക്കുന്ന ശുദ്ധമായ ഡാറ്റാ സ്ട്രക്ചർ
class MovieEntity extends Equatable {
  final String id;
  final String title;
  final String overview; // സിനിമയുടെ വിവരണം
  final String posterPath; // പോസ്റ്റർ ചിത്രത്തിന്റെ ലിങ്ക്
  final String? releaseDate;
  final double voteAverage; // റേറ്റിങ് (ഉദാഹരണത്തിന്: 8.5)

  const MovieEntity({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    this.releaseDate,
  });

  @override
  List<Object?> get props => [id, title, overview, posterPath, releaseDate, voteAverage];
}