import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user.dart';
import '../../../data/repositories/user_repository.dart';
part 'users_viewmodel.g.dart';

@riverpod
class UsersViewModel extends _$UsersViewModel {
  @override
  Future<List<User>> build() async {
    return ref.read(userRepositoryProvider).getUsers();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
          () => ref.read(userRepositoryProvider).getUsers(),
    );
  }
}