import 'package:flutter/material.dart';

class AnimatedSaveBadge extends StatelessWidget {
  final int count;

  const AnimatedSaveBadge({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Chip(
            label: Text('$count'),
            backgroundColor: Colors.deepPurple.shade100,
          ),
        );
      },
    );
  }
}