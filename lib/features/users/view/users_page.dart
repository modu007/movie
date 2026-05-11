import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/reconnecting_bar.dart';
import '../view_model/users_viewmodel.dart';
import '../../../common/widgets/shimmer_loading.dart';
import '../../../data/repositories/user_repository.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(usersViewModelProvider);
    final repo = ref.read(userRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
            icon: const Icon(Icons.group),
            onPressed: () => context.push('/matches'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add-user'),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          const ReconnectingBar(),
          Expanded(child:  usersAsync.when(
            data: (users) => NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                // if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                //   ref.read(usersViewModelProvider.notifier).loadNextPage();
                // }
                return true;
              },
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  final savedCount = repo.getSavedMoviesCount(user.id);

                  return ListTile(
                    leading: Builder(
                      builder: (context) {
                        final user = users[index];
                        if (user.avatar != null && user.avatar!.startsWith('/')) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: FileImage(File(user.avatar!)),
                            onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                          );
                        }
                        else if (user.avatar != null && user.avatar!.startsWith('http')) {
                          return CircleAvatar(
                            radius: 25,
                            backgroundImage: CachedNetworkImageProvider(user.avatar!,),
                            onBackgroundImageError: (_, __) => const Icon(Icons.person, size: 40),
                          );
                        }
                        else {
                          return const CircleAvatar(
                            radius: 25,
                            child: Icon(Icons.person),
                          );
                        }
                      },
                    ),
                    title: Text(user.name),
                    subtitle: Text(user.job ?? 'No taste noted'),
                    trailing: Chip(
                      label: Text('$savedCount'),
                      backgroundColor: Colors.deepPurple.shade100,
                    ),
                    onTap: () => context.push('/movies/${user.id}'),
                  );
                },
              ),
            ),
            loading: () => const ShimmerUsersList(),
            error: (error, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $error'),
                  TextButton(
                    onPressed: () => ref.refresh(usersViewModelProvider),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),)
        ],
      )
    );
  }
}