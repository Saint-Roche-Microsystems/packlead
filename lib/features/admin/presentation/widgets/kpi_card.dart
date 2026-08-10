import 'package:flutter/material.dart';

class KPICard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int value;
  final Color cardColor;
  final String? subtitle;
  final double cardSize;

  const KPICard({
    super.key,
    required this.title,
    required this.icon,
    required this.value,
    this.cardColor = Colors.white,
    this.subtitle,
    this.cardSize = 160,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardSize,
      height: cardSize,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Title
            Container(
              constraints: BoxConstraints(minHeight: 40),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Metric Value
                      Text(
                        value.toString(),
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                          height: 1.0,
                        ),
                      ),

                      // Icon
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          icon,
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.5),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            if (subtitle != null)
              Text(
                subtitle!,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
          ],
        ),
      ),
    );
  }
}
