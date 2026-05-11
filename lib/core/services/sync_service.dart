import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import '../db/app_database.dart';

class SyncService {
  static Future<void> syncPendingUsers() async {
    final isOnline = await Connectivity().checkConnectivity() != ConnectivityResult.none;
    if (!isOnline) return;
    final box = AppDatabase.users;
    final pendingUsers = box.values.where((u) => u.pendingSync).toList();

    for (var user in pendingUsers) {
      try {
        final dio = Dio();
        final response = await dio.post(
          'https://reqres.in/api/users',
          options: Options(
            headers: {
              'x-api-key': 'reqres_7e8674e348854226a8b41811f09958ab',
              'Content-Type': 'application/json',
            },
          ),
          data: {
            "name": user.name,
            "job": user.job ?? "",
          },
        );

        final serverId = response.data['id'];
        if (serverId != null) {
          user.id = int.tryParse(serverId.toString()) ?? user.id;
        }

        user.pendingSync = false;
        await user.save();

      } catch (e) {
        print("Sync failed for ${user.name}: $e");
      }
    }
  }
}