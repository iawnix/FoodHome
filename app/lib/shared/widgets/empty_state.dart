import 'package:flutter/material.dart';
import 'package:foodhome_app/core/theme/tokens.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({
    required this.icon,
    required this.title,
    super.key,
  });

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: AppColors.muted),
            const SizedBox(height: AppSpacing.sm),
            Text(title, style: const TextStyle(color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}
