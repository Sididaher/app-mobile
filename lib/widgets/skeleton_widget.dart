import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../core/theme/app_theme.dart';

class SkeletonWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const SkeletonWidget({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
  });

  const SkeletonWidget.rectangular({
    super.key,
    this.width = double.infinity,
    this.height = 150,
    this.borderRadius,
  });

  const SkeletonWidget.circular({
    super.key,
    required double size,
    this.borderRadius = const BorderRadius.all(Radius.circular(50)),
  })  : width = size,
        height = size;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[800]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius ?? BorderRadius.circular(AppTheme.borderRadius),
        ),
      ),
    );
  }
}
