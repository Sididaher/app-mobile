import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Color? titleColor;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.iconColor,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isDark ? Border.all(color: Colors.white10) : null,
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF2C2C2C) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon, 
            color: iconColor ?? (isDark ? AppTheme.accentGold : AppTheme.primaryBlue),
            size: 20,
          ),
        ),
        title: Text(
          title, 
          style: TextStyle(
            fontSize: 15, 
            fontWeight: FontWeight.bold, 
            color: titleColor ?? (isDark ? Colors.white : Colors.black),
          ),
        ),
        subtitle: subtitle != null ? Text(
          subtitle!, 
          style: TextStyle(
            fontSize: 12, 
            color: isDark ? Colors.white38 : Colors.grey.shade500,
          ),
        ) : null,
        trailing: trailing ?? Icon(
          Icons.chevron_right, 
          size: 18, 
          color: isDark ? Colors.white38 : Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }
}
