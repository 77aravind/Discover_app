import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';

class MovieModel extends MovieEntity {
  // 1. കൺസ്ട്രക്ടർ വഴി ഡാറ്റ വാങ്ങി സൂപ്പർ ക്ലാസ്സിലേക്ക് (Entity) പാസ്സ് ചെയ്യുന്നു
  const MovieModel({
    required super.id,
    required super.title,
    required super.overview,
    required super.posterPath,
    required super.voteAverage,
    super.releaseDate,
  });

  // 🔄 2. API-ൽ നിന്ന് വരുന്ന JSON ഡാറ്റയെ Model ഒബ്‌ജെക്റ്റ് ആക്കി മാറ്റാൻ (FROM JSON)
  factory MovieModel.fromJson(Map<String, dynamic> json) {
    String extractPoster(Map<String, dynamic> src) {
      // 1. Common TMDB field
      final p1 = src['poster_path'];
      if (p1 != null && p1.toString().isNotEmpty) return p1.toString();

      // 2. Some APIs provide primaryImage.url nested
      final primary = src['primaryImage'];
      if (primary is Map && primary['url'] != null && primary['url'].toString().isNotEmpty) {
        return primary['url'].toString();
      }

      // 3. Generic fallbacks
      final p2 = src['poster'] ?? src['posterUrl'] ?? src['image'] ?? src['thumbnail'];
      if (p2 != null && p2.toString().isNotEmpty) return p2.toString();

      return '';
    }

    return MovieModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? (json['name'] ?? ''),
      overview: json['overview'] ?? json['plot'] ?? '',
      posterPath: extractPoster(json),
      voteAverage: json['vote_average'] != null
          ? (json['vote_average'] as num).toDouble()
          : 0.0,
      releaseDate: json['release_date'] as String?,
    );
  }

  // 🔄 3. ഈ മോഡലിനെ തിരിച്ച് JSON ആക്കി മാറ്റാൻ (TO JSON - Local Caching / Hive-ൽ സൂക്ഷിക്കാൻ)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
    };
  }
}