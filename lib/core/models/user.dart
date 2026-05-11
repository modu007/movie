import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
class User extends HiveObject {
  @HiveField(0)
  late int id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? job;

  @HiveField(3)
  String? avatar;

  @HiveField(4)
  bool pendingSync;

  User({
    required this.id,
    required this.name,
    this.job,
    this.avatar,
    this.pendingSync = false,
  });
}