import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/db/app_database.dart';
import '../../../data/repositories/movie_repository.dart';

class MovieDetailPage extends ConsumerWidget {
  final int movieId;
  final int userId;

  const MovieDetailPage({
    super.key,
    required this.movieId,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = AppDatabase.movies.get(movieId);
    if (movie == null) {
      return const Scaffold(body: Center(child: Text('Movie not found')));
    }
    final bool isGuest =userId == 001; // Guest user

    return ValueListenableBuilder(
      valueListenable: AppDatabase.saves.listenable(),
      builder: (context, Box box, child) {
        final isSavedByCurrentUser = box.values.any(
              (s) => s.userId == userId && s.movieId == movie.id,
        );

        final saveCount = box.values.where((s) => s.movieId == movie.id).length;

        return SafeArea(child: Scaffold(
          appBar: AppBar(title: Text(movie.title)),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero Animation
                Hero(
                  tag: 'poster-${movie.id}',
                  child: CachedNetworkImage(
                    imageUrl: movie.posterPath != null && movie.posterPath!.isNotEmpty
                        ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                        : '',
                    height: 450,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    fadeInDuration: const Duration(milliseconds: 400),
                    placeholder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(height: 450, color: Colors.white),
                    ),
                    errorWidget: (_, __, ___) => Container(
                      height: 450,
                      color: Colors.grey[900],
                      child: const Icon(Icons.movie, size: 120, color: Colors.white54),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text("Release: ${movie.releaseDate ?? 'Unknown'}"),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          const Icon(Icons.people, color: Colors.deepPurple),
                          const SizedBox(width: 8),
                          Text(
                            saveCount > 0
                                ? "$saveCount users want to watch this"
                                : "Be the first to save this.",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // Save Button
                      isGuest ? SizedBox():Padding(padding: EdgeInsetsGeometry.only(bottom: 15),child: SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ref.read(movieRepositoryProvider).toggleSave(userId, movie.id);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isSavedByCurrentUser
                                      ? 'Removed from your list'
                                      : isGuest
                                      ? 'Added to your list (Guest Mode)'
                                      : 'Added to Saved Movies',
                                ),
                                backgroundColor: isSavedByCurrentUser ? Colors.red : Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: Icon(
                            isSavedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                            color: isSavedByCurrentUser ? Colors.red : null,
                          ),
                          label: Text(
                            isSavedByCurrentUser
                                ? 'Remove from Saved'
                                : 'Save to Watchlist',
                            style: const TextStyle(fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSavedByCurrentUser ? Colors.red : Colors.deepPurple,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),),
                      const Text(
                        "Overview",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        movie.overview ?? "No description available.",
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),

                      if (isGuest)
                        Padding(
                          padding: const EdgeInsets.only(top: 24),
                          child: Text(
                            "Note: You are using Guest Mode (User ID: $userId)",
                            style: const TextStyle(color: Colors.orange, fontStyle: FontStyle.italic),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}