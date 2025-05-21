import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  static const String _baseUrl = 'https://www.omdbapi.com/';
  static const String _apiKey = '12847858'; // OMDb API key

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?s=$query&apikey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          final List<dynamic> moviesJson = data['Search'];
          List<Movie> movies = [];
          for (var json in moviesJson) {
            final movie = await getMovieDetails(json['imdbID']);
            movies.add(movie);
          }
          return movies;
        }
      }
      return [];
    } catch (e) {
      throw Exception('Failed to fetch movies: $e');
    }
  }

  Future<Movie> getMovieDetails(String imdbId) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl?i=$imdbId&apikey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['Response'] == 'True') {
          return Movie.fromJson(data);
        }
      }
      throw Exception('Movie not found');
    } catch (e) {
      throw Exception('Failed to fetch movie details: $e');
    }
  }
} 