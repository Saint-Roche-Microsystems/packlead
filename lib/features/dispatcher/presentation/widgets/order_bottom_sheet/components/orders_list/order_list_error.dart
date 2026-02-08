import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

class OrderListError extends StatelessWidget {
  final String errorMsg;

  const OrderListError({super.key, required this.errorMsg});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: SaintColors.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar órdenes',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              errorMsg,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
