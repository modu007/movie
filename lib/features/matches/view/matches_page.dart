import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/db/app_database.dart';
import '../../../core/models/movie.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches'),
        centerTitle: true,
      ),
      body: ValueListenableBuilder(
        valueListenable: AppDatabase.saves.listenable(),
        builder: (context, Box box, _) {
          final Map<int, List<int>> movieToUsers = {};
          for (var save in AppDatabase.saves.values) {
            movieToUsers.putIfAbsent(save.movieId, () => []).add(save.userId);
          }

          final matches = movieToUsers.entries
              .where((e) => e.value.length >= 2)
              .map((e) {
            final movie = AppDatabase.movies.get(e.key);
            return {
              'movie': movie,
              'count': e.value.length,
              'userIds': e.value,
            };
          })
              .where((e) => e['movie'] != null)
              .toList();
          matches.sort((a, b) => (b['count'] as int).compareTo(a['count'] as int));

          if (matches.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.group_off, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No matches yet",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "When 2 or more users save the same movie,\nit will appear here automatically.",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: matches.length,
            itemBuilder: (context, index) {
              final item = matches[index];
              final movie = item['movie'] as Movie;
              final count = item['count'] as int;
              final userIds = item['userIds'] as List<int>;

              final isTopPick = count == AppDatabase.users.values.length;

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () => context.push('/movie/${movie.id}',extra: 001),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Hero(
                          tag: 'poster-${movie.id}',
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: movie.posterPath != null
                                  ? 'https://image.tmdb.org/t/p/w92${movie.posterPath}'
                                  : '',
                              width: 85,
                              height: 120,
                              fit: BoxFit.cover,
                              placeholder: (_, __) => const CircularProgressIndicator(),
                              errorWidget: (_, __, ___) => const Icon(Icons.movie, size: 50),
                            ),
                          ),
                        ),

                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      movie.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isTopPick)
                                    const Icon(Icons.star, color: Colors.amber, size: 28),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                movie.releaseDate?.split('-')[0] ?? '',
                                style: const TextStyle(color: Colors.grey),
                              ),
                              const SizedBox(height: 12),

                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      "$count users",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.deepPurple,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  SizedBox(
                                    height: 32,
                                    child: Stack(
                                      children: userIds.take(3).map((id) {
                                        final user = AppDatabase.users.get(id);
                                        return Padding(
                                          padding: EdgeInsets.only(left: userIds.indexOf(id) * 20.0),
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundImage: NetworkImage(user?.avatar ?? ''),
                                            onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 16),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}