import 'package:flutter/material.dart';
import 'package:packlead/core/validators/email_validators.dart';
import 'package:packlead/core/widgets/form_fields/base_text_field.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputAction? textInputAction;

  const EmailField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label = 'Correo',
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      label: label,
      hint: 'ejemplo@gmail.com',
      validator: EmailValidators.validateFormat,
      enabled: enabled,
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction,
    );
  }
}