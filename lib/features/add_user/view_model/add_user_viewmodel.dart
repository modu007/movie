import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/models/user.dart';
import '../../../data/repositories/user_repository.dart';

part 'add_user_viewmodel.g.dart';

@riverpod
class AddUserViewModel extends _$AddUserViewModel {
  @override
  FutureOr<void> build() {}

  Future<User> addUser(String name, String job, {String? localAvatarPath}) async {
    return ref.read(userRepositoryProvider).createUser(
      name,
      job,
      localAvatarPath
    );
  }
}