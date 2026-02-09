import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

class QuickLoginButtons extends StatelessWidget {
  final VoidCallback onAdminLogin;
  final VoidCallback onDispatcherLogin;

  const QuickLoginButtons({
    super.key,
    required this.onAdminLogin,
    required this.onDispatcherLogin
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),

        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onAdminLogin,
                icon: const Icon(Icons.admin_panel_settings, size: 18),
                label: const Text('Admin'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SaintColors.primary,
                  side: BorderSide(color: SaintColors.primary),
                ),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: OutlinedButton.icon(
                onPressed: onDispatcherLogin,
                icon: const Icon(Icons.local_shipping, size: 18),
                label: const Text('Repartidor'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: SaintColors.primary,
                  side: BorderSide(color: SaintColors.primary),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
