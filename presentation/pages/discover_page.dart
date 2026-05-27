import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart' as dartz;
import 'package:discover_app/core/injection_container.dart';
import 'package:discover_app/core/errors/failures.dart';
import 'package:discover_app/features/discover/domain/entities/movie_entity.dart';
import 'package:discover_app/features/discover/domain/repo/movie_repository.dart';
import 'package:discover_app/features/discover/presentation/widgets/movie_horizontal_list.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _MovieSectionConfig {
  final String title;
  final Future<dartz.Either<Failure, List<MovieEntity>>> moviesFuture;

  const _MovieSectionConfig({required this.title, required this.moviesFuture});
}

class _DiscoverPageState extends State<DiscoverPage> {
  late final List<_MovieSectionConfig> _sections;

  @override
  void initState() {
    super.initState();
    final movieRepository = sl<MovieRepository>();

    _sections = [
      _MovieSectionConfig(title: 'Trending Movies This Week', moviesFuture: movieRepository.getTrendingMovies()),
      _MovieSectionConfig(title: 'Popular on Netflix', moviesFuture: movieRepository.getPopularMovies()),
      _MovieSectionConfig(title: 'Top Rated Masterpieces', moviesFuture: movieRepository.getTopRatedMovies()),
      _MovieSectionConfig(title: 'Action & Adventure Packed', moviesFuture: movieRepository.getMoviesByGenre('28')),
      _MovieSectionConfig(title: 'Chilling Horror Movies', moviesFuture: movieRepository.getMoviesByGenre('27')),
      _MovieSectionConfig(title: 'Sci-Fi & Fantasy Worlds', moviesFuture: movieRepository.getMoviesByGenre('878')),
      _MovieSectionConfig(title: 'Laugh Out Loud Comedies', moviesFuture: movieRepository.getMoviesByGenre('35')),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 0.8),
              floating: true,
              elevation: 0,
              leading: const Center(
                child: Text('N', style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              actions: [
                IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
                const SizedBox(width: 10),
                Container(width: 28, height: 28, color: Colors.blue),
                const SizedBox(width: 15),
              ],
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('TV Shows', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: const Text('Movies', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    TextButton(onPressed: () {}, child: const Text('Categories', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final section = _sections[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            section.title,
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        MovieHorizontalList(moviesFuture: section.moviesFuture),
                      ],
                    ),
                  );
                },
                childCount: _sections.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
