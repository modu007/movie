import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerUsersList extends StatelessWidget {
  const ShimmerUsersList({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => ListTile(
          leading: const CircleAvatar(backgroundColor: Colors.white),
          title: Container(height: 20, width: 150, color: Colors.white),
          subtitle: Container(height: 15, width: 100, color: Colors.white),
        ),
      ),
    );
  }
}