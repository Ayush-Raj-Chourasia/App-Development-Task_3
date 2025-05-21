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
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.movie_filter,
              color: Colors.white,
              size: isTablet ? 40 : 32,
            ),
            SizedBox(width: isTablet ? 12 : 8),
            Text(
              'Movie Explorer',
              style: Theme.of(context).appBarTheme.titleTextStyle?.copyWith(
                    fontSize: isTablet ? 28 : 24,
                  ),
            ),
          ],
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(padding),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(isTablet ? 24 : 16),
              ),
              child: TextField(
                controller: _searchController,
                style: TextStyle(fontSize: isTablet ? 18 : 16),
                decoration: InputDecoration(
                  hintText: 'Search movies...',
                  hintStyle: TextStyle(fontSize: isTablet ? 18 : 16),
                  prefixIcon: Icon(Icons.search, size: isTablet ? 28 : 24),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.clear, size: isTablet ? 28 : 24),
                    onPressed: () {
                      _searchController.clear();
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: isTablet ? 20 : 16,
                    horizontal: isTablet ? 20 : 16,
                  ),
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
                        Icon(
                          Icons.error_outline,
                          color: colorScheme.error,
                          size: isTablet ? 64 : 48,
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        Text(
                          movieProvider.error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: isTablet ? 18 : 16,
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        ElevatedButton.icon(
                          icon: Icon(Icons.refresh, size: isTablet ? 28 : 24),
                          label: Text(
                            'Retry',
                            style: TextStyle(fontSize: isTablet ? 18 : 16),
                          ),
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
                          size: isTablet ? 64 : 48,
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        Text(
                          _selectedIndex == 1
                              ? 'No favorite movies yet'
                              : 'Search for movies to get started',
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return MasonryGridView.count(
                  crossAxisCount: isTablet ? 3 : 2,
                  mainAxisSpacing: isTablet ? 12 : 8,
                  crossAxisSpacing: isTablet ? 12 : 8,
                  padding: EdgeInsets.all(isTablet ? 12 : 8),
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
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.movie, size: isTablet ? 28 : 24),
            label: 'All Movies',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite, size: isTablet ? 28 : 24),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
} 