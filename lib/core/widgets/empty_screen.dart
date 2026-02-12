import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

class EmptyScreen extends StatelessWidget {
  final String message;
  final String? title;
  final IconData? icon;

  const EmptyScreen({
    super.key,
    required this.message,
    this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon ?? Icons.inbox_outlined,
                size: 80,
                color: SaintColors.primary.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 20),
              if (title != null) ...[
                Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: SaintColors.foreground.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}