import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/models/movie.dart';
import '../../core/models/user_movie_save.dart';
import '../../core/provider/provider.dart';

final movieRepositoryProvider = Provider<MovieRepository>((ref) => MovieRepository(ref));

class MovieRepository {
  final Ref ref;
  late final Dio dio = ref.read(dioClientProvider).dio;

  MovieRepository(this.ref);

  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        'https://api.themoviedb.org/3/trending/movie/day',
        queryParameters: {
          'page': page,
          'language': 'en-US',
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NDE4ZDlhZGFiN2Q4MGJlZDliZWJhODExMjI0N2QyYiIsIm5iZiI6MTY0MzM1MjM1Ni44MTYsInN1YiI6IjYxZjM5MTI0NWY2YzQ5MDEwY2ZhODY0ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vJOHCOsa8P-hwh2JeF5mn2XTpKZqKoxCLO0NL4xjAwU',
            'accept': 'application/json',
          },
        ),
      );

      final List results = response.data['results'] ?? [];

      for (var item in results) {
        final movie = Movie(
          id: item['id'],
          title: item['title'] ?? 'Unknown',
          overview: item['overview'],
          posterPath: item['poster_path'],
          releaseDate: item['release_date'],
        );

        await AppDatabase.movies.put(movie.id, movie);
      }

      print(" Saved ${results.length} movies to local DB");
    } catch (e) {
      print(" Network error, loading from local DB: $e");
    }

    return AppDatabase.movies.values.toList();
  }

  Future<void> toggleSave(int userId, int movieId) async {
    final existing = AppDatabase.saves.values.where(
          (s) => s.userId == userId && s.movieId == movieId,
    ).toList();

    if (existing.isNotEmpty) {
      await existing.first.delete();
    } else {
      final save = UserMovieSave(userId: userId, movieId: movieId);
      await AppDatabase.saves.add(save);
    }
  }


  List<Movie> getSavedMovies(int userId) {
    final saveRecords = AppDatabase.saves.values.where((s) => s.userId == userId);
    final movieIds = saveRecords.map((s) => s.movieId).toSet();

    return AppDatabase.movies.values
        .where((movie) => movieIds.contains(movie.id))
        .toList();
  }
}