import 'package:go_router/go_router.dart';
import '../../features/add_user/view/add_user_page.dart';
import '../../features/matches/view/matches_page.dart';
import '../../features/movie_detail/view/movie_detail_page.dart';
import '../../features/movies/view/movies_page.dart';
import '../../features/saved_movies/view/saved_movies_page.dart';
import '../../features/users/view/users_page.dart';

final router = GoRouter(
  initialLocation: '/users',
  routes: [
    GoRoute(path: '/users', builder: (_, __) => const UsersPage()),
    GoRoute(path: '/add-user', builder: (_, __) => const AddUserPage()),
    GoRoute(
      path: '/movies/:userId',
      builder: (_, state) => MoviesPage(userId: int.parse(state.pathParameters['userId']!)),
    ),
    GoRoute(
      path: '/movie/:movieId',
      builder: (_, state) {
        final movieId = int.parse(state.pathParameters['movieId']!);
        final userId = state.extra as int;
        return MovieDetailPage(movieId: movieId, userId: userId);
      },
    ),
    GoRoute(
      path: '/saved/:userId',
      builder: (_, state) => SavedMoviesPage(userId: int.parse(state.pathParameters['userId']!)),
    ),
    GoRoute(path: '/matches', builder: (_, __) => const MatchesPage()),
  ],
);