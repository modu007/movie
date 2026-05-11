import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/movie.dart';
import '../../../data/repositories/movie_repository.dart';
part 'movies_viewmodel.g.dart';

@riverpod
class MoviesViewModel extends _$MoviesViewModel {
  @override
  FutureOr<List<Movie>> build(int userId) async {
    return ref.read(movieRepositoryProvider).getTrendingMovies();
  }

  Future<void> toggleSave(int userId, int movieId) async {
    await ref.read(movieRepositoryProvider).toggleSave(userId, movieId);
    ref.invalidateSelf();
  }
}