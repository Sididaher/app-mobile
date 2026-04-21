import 'package:flutter/material.dart';
import 'skeleton_widget.dart';

class LoadingWidget extends StatelessWidget {
  final String message;

  const LoadingWidget({
    super.key,
    this.message = 'Chargement...',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SkeletonWidget.circular(size: 40),
          const SizedBox(height: 16),
          Text(message),
        ],
      ),
    );
  }
}
