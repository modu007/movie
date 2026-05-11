import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sync_service.dart';

final connectivityProvider = StreamProvider<bool>((ref) async* {
  yield await Connectivity().checkConnectivity() != ConnectivityResult.none;
  await for (final result in Connectivity().onConnectivityChanged) {
    final isOnline = result != ConnectivityResult.none;
    yield isOnline;

    if (isOnline) {
      await SyncService.syncPendingUsers();
    } else {
      print("Internet lost");
    }
  }
});