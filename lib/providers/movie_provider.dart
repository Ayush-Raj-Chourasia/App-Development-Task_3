import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';

class MovieProvider with ChangeNotifier {
  final MovieService _movieService = MovieService();
  List<Movie> _movies = [];
  final List<Movie> _favorites = [];
  bool _isLoading = false;
  String _error = '';

  List<Movie> get movies => _movies;
  List<Movie> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;

  MovieProvider() {
    _loadFavorites();
  }

  Future<void> searchMovies(String query) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _movies = await _movieService.searchMovies(query);
      _updateFavoritesStatus();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(Movie movie) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    
    if (movie.isFavorite) {
      favoritesJson.remove(movie.imdbID);
      _favorites.removeWhere((m) => m.imdbID == movie.imdbID);
    } else {
      favoritesJson.add(movie.imdbID);
      _favorites.add(movie);
    }
    
    await prefs.setStringList('favorites', favoritesJson);
    _updateFavoritesStatus();
    notifyListeners();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList('favorites') ?? [];
    
    for (final imdbId in favoritesJson) {
      try {
        final movie = await _movieService.getMovieDetails(imdbId);
        movie.isFavorite = true;
        _favorites.add(movie);
      } catch (e) {
        print('Error loading favorite movie: $e');
      }
    }
    
    _updateFavoritesStatus();
    notifyListeners();
  }

  void _updateFavoritesStatus() {
    for (final movie in _movies) {
      movie.isFavorite = _favorites.any((f) => f.imdbID == movie.imdbID);
    }
  }
} 