import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packlead/core/validators/phone_validators.dart';
import 'package:packlead/core/widgets/form_fields/base_text_field.dart';

/// Prefix +593 is added automatically when sent
class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputAction? textInputAction;

  const PhoneField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label = 'Teléfono',
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      label: label,
      hint: '987654321',
      validator: PhoneValidators.validateEC,
      enabled: enabled,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(9),
      ],
      maxLength: 9,
    );
  }
}
