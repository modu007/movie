import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OfflineImage extends StatelessWidget {
  final String? posterPath;
  final double? width;
  final double? height;
  final BoxFit fit;

  const OfflineImage({
    super.key,
    required this.posterPath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = posterPath != null && posterPath!.isNotEmpty
        ? 'https://image.tmdb.org/t/p/w500$posterPath'
        : null;

    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      width: width,
      height: height,
      fit: fit,
      cacheKey: posterPath, // Important for caching
      placeholder: (context, url) => Container(
        color: Colors.grey[300],
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey[800],
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.movie_outlined, size: 50, color: Colors.white70),
            SizedBox(height: 8),
            Text(
              'No Image',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}