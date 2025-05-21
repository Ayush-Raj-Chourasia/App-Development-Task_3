class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String type;
  final String poster;
  final String plot;
  final String cast;
  final String ratings;
  bool isFavorite;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.type,
    required this.poster,
    this.plot = '',
    this.cast = '',
    this.ratings = '',
    this.isFavorite = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      type: json['Type'] ?? '',
      poster: json['Poster'] ?? '',
      plot: json['Plot'] ?? '',
      cast: json['Actors'] ?? '',
      ratings: json['Ratings'] != null ? json['Ratings'].toString() : '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Title': title,
      'Year': year,
      'imdbID': imdbID,
      'Type': type,
      'Poster': poster,
      'Plot': plot,
      'Actors': cast,
      'Ratings': ratings,
    };
  }
} 