import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../../common/widgets/shimmer_loading.dart';
import '../view_model/movies_viewmodel.dart';
import '../../../common/widgets/animated_list_item.dart';
import '../../../common/widgets/reconnecting_bar.dart';
import '../../../core/db/app_database.dart';

class MoviesPage extends ConsumerWidget {
  final int userId;

  const MoviesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(moviesViewModelProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => context.push('/saved/$userId'),
          ),
        ],
      ),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(
            child: moviesAsync.when(
              data: (movies) => ListView.builder(
                itemCount: movies.length,
                itemBuilder: (context, index) {
                  final movie = movies[index];
                  final saveCount = _getSaveCount(movie.id);
                  final isSavedByCurrentUser = _isSavedByUser(userId, movie.id);

                  return AnimatedListItem(
                    index: index,
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(8),
                        leading: Hero(
                          tag: 'poster-${movie.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath != null
                                  ? 'https://image.tmdb.org/t/p/w92${movie.posterPath}'
                                  : '',
                              width: 60,
                              height: 90,
                              fit: BoxFit.cover,
                              fadeInDuration: const Duration(milliseconds: 300),
                              placeholder: (_, __) => Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                child: Container(
                                  width: 60,
                                  height: 90,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (_, __, ___) => const Icon(Icons.movie, size: 50),
                            ),
                          ),
                        ),
                        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(movie.releaseDate?.split('-')[0] ?? 'Unknown'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TweenAnimationBuilder<double>(
                              tween: Tween(begin: 0.8, end: 1.0),
                              duration: const Duration(milliseconds: 300),
                              builder: (context, scale, child) {
                                return Transform.scale(
                                  scale: scale,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: saveCount > 0 ? Colors.deepPurple : Colors.grey[300],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$saveCount',
                                      style: TextStyle(
                                        color: saveCount > 0 ? Colors.white : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: Icon(
                                isSavedByCurrentUser ? Icons.favorite : Icons.favorite_border,
                                color: isSavedByCurrentUser ? Colors.red : null,
                              ),
                              onPressed: () {
                                ref.read(moviesViewModelProvider(userId).notifier)
                                    .toggleSave(userId, movie.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          context.push(
                            '/movie/${movie.id}',
                            extra: userId,
                          );
                        },                      ),
                    ),
                  );
                },
              ),
              loading: () => const ShimmerUsersList(),
              error: (_, __) => const Center(child: Text('Failed to load movies')),
            ),
          ),
        ],
      ),
    );
  }

  int _getSaveCount(int movieId) {
    return AppDatabase.saves.values.where((s) => s.movieId == movieId).length;
  }

  bool _isSavedByUser(int userId, int movieId) {
    return AppDatabase.saves.values.any((s) => s.userId == userId && s.movieId == movieId);
  }
}