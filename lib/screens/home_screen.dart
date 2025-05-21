import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';
import 'movie_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // 0: All Movies, 1: Favorites

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.movie_filter, color: Colors.white, size: 32),
            const SizedBox(width: 8),
            Text(
              'Movie Explorer',
              style: Theme.of(context).appBarTheme.titleTextStyle,
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                ),
                onSubmitted: (query) {
                  if (query.isNotEmpty) {
                    context.read<MovieProvider>().searchMovies(query);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: Consumer<MovieProvider>(
              builder: (context, movieProvider, child) {
                if (movieProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (movieProvider.error.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, color: colorScheme.error, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          movieProvider.error,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          label: const Text('Retry'),
                          onPressed: () {
                            if (_searchController.text.isNotEmpty) {
                              movieProvider.searchMovies(_searchController.text);
                            }
                          },
                        ),
                      ],
                    ),
                  );
                }

                final movies = _selectedIndex == 1
                    ? movieProvider.favorites
                    : movieProvider.movies;

                if (movies.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _selectedIndex == 1 ? Icons.favorite_border : Icons.movie,
                          color: colorScheme.primary,
                          size: 48,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _selectedIndex == 1
                              ? 'No favorite movies yet'
                              : 'Search for movies to get started',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return MovieCard(
                      movie: movie,
                      onFavoriteToggle: () {
                        movieProvider.toggleFavorite(movie);
                      },
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MovieDetailsScreen(movie: movie),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.movie),
            label: 'All Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
} 