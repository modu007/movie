import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/db/app_database.dart';
import '../../core/models/user.dart';
import '../../core/provider/provider.dart';
import '../../core/services/sync_service.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) => UserRepository(ref));

class UserRepository {
  final Ref ref;
  late final Dio dio = ref.read(dioClientProvider).dio;

  UserRepository(this.ref);

  Future<List<User>> getUsers({int page = 1}) async {
    try {
      final response = await dio.get(
        'https://reqres.in/api/users?page=$page',
        options: Options(
          headers: {'x-api-key': 'reqres_7e8674e348854226a8b41811f09958ab'},
        ),
      );

      final List data = response.data['data'] ?? [];

      for (var item in data) {
        final user = User(
          id: item['id'],
          name: '${item['first_name']} ${item['last_name']}',
          avatar: item['avatar'],
          pendingSync: false,
        );
        if (!AppDatabase.users.containsKey(user.id)) {
          await AppDatabase.users.put(user.id, user);
        }
      }
    } catch (e) {
      print("Offline - loading cached users");
    }

    return AppDatabase.users.values.toList()
      ..sort((a, b) => a.id.compareTo(b.id));
  }

  Future<User> createUser(String name, String job, String? avatar) async {
    final box = AppDatabase.users;
    final key = box.isEmpty ? 100 : box.keys.cast<int>().reduce((a, b) => a > b ? a : b) + 1;

    final user = User(
      id: key,
      name: name,
      job: job,
      pendingSync: true,
      avatar: avatar
    );

    await box.put(key, user);
    print("💾 Saved locally: ${user.name}");

    await SyncService.syncPendingUsers();

    return user;
  }

  int getSavedMoviesCount(int userId) {
    return AppDatabase.saves.values.where((s) => s.userId == userId).length;
  }
}