import 'package:flutter/material.dart';
import 'package:packlead/core/validators/common_validators.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputAction? textInputAction;
  final bool obscurePassword;
  final VoidCallback? onIconPressed;

  const PasswordField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label = 'Contraseña',
    this.textInputAction,
    this.obscurePassword = true,
    this.onIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)
        ),

        const SizedBox(height: 8),

        TextFormField(
          controller: controller,
          obscureText: obscurePassword,
          decoration: InputDecoration(
            hintText: '••••••••',
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              ),
              onPressed: onIconPressed,
            ),
          ),
          textInputAction: textInputAction,
          validator: validatePassword,
        ),
      ],
    );
  }
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'La contraseña es requerida';
    }

    return null;
  }
}

