import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../models/movie.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final padding = isTablet ? 24.0 : 16.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          movie.title,
          style: TextStyle(fontSize: isTablet ? 24 : 20),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: movie.imdbID,
              child: CachedNetworkImage(
                imageUrl: movie.poster != 'N/A' ? movie.poster : 'https://via.placeholder.com/300x450',
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: double.infinity,
                    height: isTablet ? 400 : 300,
                    color: Colors.white,
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                   width: double.infinity,
                   height: isTablet ? 400 : 300,
                   color: Colors.grey[200],
                   child: const Icon(Icons.error, size: 50, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet ? 16 : 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: isTablet ? 24 : 20),
                      const SizedBox(width: 8),
                      Text(
                        'Year: ${movie.year}',
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                      ),
                      SizedBox(width: isTablet ? 24 : 16),
                      Icon(Icons.category, size: isTablet ? 24 : 20),
                      const SizedBox(width: 8),
                      Text(
                        'Type: ${movie.type}',
                        style: TextStyle(fontSize: isTablet ? 18 : 16),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Plot',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    movie.plot,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Cast',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    movie.cast,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                  ),
                  SizedBox(height: isTablet ? 24 : 16),
                  Text(
                    'Ratings',
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Text(
                    movie.ratings,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 