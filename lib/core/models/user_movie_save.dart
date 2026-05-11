import 'package:hive/hive.dart';

part 'user_movie_save.g.dart';

@HiveType(typeId: 2)
class UserMovieSave extends HiveObject {
  @HiveField(0) int userId;
  @HiveField(1) int movieId;

  UserMovieSave({required this.userId, required this.movieId});
}