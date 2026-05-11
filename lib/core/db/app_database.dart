import 'package:hive_flutter/hive_flutter.dart';
import '../models/movie.dart';
import '../models/user.dart';
import '../models/user_movie_save.dart';

class AppDatabase {
  static const String usersBox = 'users';
  static const String moviesBox = 'movies';
  static const String savesBox = 'user_saves';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(MovieAdapter());
    Hive.registerAdapter(UserMovieSaveAdapter());

    await Hive.openBox<User>(usersBox);
    await Hive.openBox<Movie>(moviesBox);
    await Hive.openBox<UserMovieSave>(savesBox);
  }

  static Box<User> get users => Hive.box<User>(usersBox);
  static Box<Movie> get movies => Hive.box<Movie>(moviesBox);
  static Box<UserMovieSave> get saves => Hive.box<UserMovieSave>(savesBox);
}