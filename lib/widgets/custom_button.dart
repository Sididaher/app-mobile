import 'package:flutter/material.dart';
import 'skeleton_widget.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: SkeletonWidget.circular(size: 20),
              )
            : Icon(icon ?? Icons.check),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
