import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:movie/common/widgets/animated_list_item.dart';
import 'dart:io';

import '../../../core/db/app_database.dart';
import '../../../data/repositories/movie_repository.dart';

class SavedMoviesPage extends ConsumerWidget {
  final int userId;

  const SavedMoviesPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = AppDatabase.users.get(userId) ??
        AppDatabase.users.values.where((u) => u.id == userId).firstOrNull;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Saved Movies')),
        body: const Center(child: Text('User not found')),
      );
    }

    final savedMovies = ref.watch(movieRepositoryProvider).getSavedMovies(userId);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Movies')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.deepPurple.shade50,
            child: Row(
              children: [
                Builder(
                  builder: (context) {
                    if (user.avatar != null && user.avatar!.startsWith('/')) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: FileImage(File(user.avatar!)),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                      );
                    } else if (user.avatar != null && user.avatar!.startsWith('http')) {
                      return CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(user.avatar!),
                        onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                      );
                    } else {
                      return const CircleAvatar(
                        radius: 40,
                        child: Icon(Icons.person, size: 40),
                      );
                    }
                  },
                ),

                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      if (user.job != null)
                        Text(
                          user.job!,
                          style: const TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      if (user.pendingSync)
                        const Text(" (Syncing...)", style: TextStyle(color: Colors.orange)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Saved Movies List
          Expanded(
            child: savedMovies.isEmpty
                ? _buildEmptyState(context)
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: savedMovies.length,
              itemBuilder: (context, index) {
                final movie = savedMovies[index];
                return AnimatedListItem(child: Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Hero(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: movie.posterPath != null
                              ? 'https://image.tmdb.org/t/p/w92${movie.posterPath}'
                              : '',
                          width: 70,
                          height: 100,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => const Icon(Icons.movie, size: 50),
                        ),
                      ),
                      tag: 'poster-${movie.id}',
                    ),
                    title: Text(
                      movie.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: Text(
                      movie.releaseDate != null
                          ? "Released: ${movie.releaseDate}"
                          : "Release date unknown",
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.favorite, color: Colors.red),
                      onPressed: () {
                        ref.read(movieRepositoryProvider).toggleSave(userId, movie.id);
                      },
                    ),
                    onTap: () {
                      context.push(
                        '/movie/${movie.id}',
                        extra: userId,
                      );
                    },
                  ),
                ),index: index,);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.bookmark_border, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "No saved movies yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Browse trending movies and save some!",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.movie),
            label: const Text('Browse Movies'),
          ),
        ],
      ),
    );
  }
}