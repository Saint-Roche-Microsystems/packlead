import 'package:flutter/material.dart';

class StateBadge extends StatelessWidget {
  final String label;
  final bool isActive;
  final Color color;
  final bool isLoading;
  final VoidCallback onTap;

  const StateBadge({
    super.key,
    required this.label,
    required this.isActive,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isActive
        ? color
        : Colors.grey.withValues(alpha: 0.4);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: isLoading || isActive ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: effectiveColor),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: effectiveColor,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
