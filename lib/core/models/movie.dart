import 'package:hive/hive.dart';

part 'movie.g.dart';

@HiveType(typeId: 1)
class Movie extends HiveObject {
  @HiveField(0) int id;
  @HiveField(1) String title;
  @HiveField(2) String? overview;
  @HiveField(3) String? posterPath;
  @HiveField(4) String? releaseDate;

  Movie({required this.id, required this.title, this.overview, this.posterPath, this.releaseDate});
}