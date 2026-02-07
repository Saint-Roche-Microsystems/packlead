import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packlead/core/validators/dispatcher_form_validators.dart';
import 'package:packlead/core/widgets/form_fields/base_text_field.dart';

class PlateField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final String label;
  final TextInputAction? textInputAction;

  const PlateField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.label = 'Placa',
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      label: label,
      hint: 'ABC-1234',
      validator: DispatcherFormValidators.validateLicensePlate,
      enabled: enabled,
      keyboardType: TextInputType.visiblePassword,
      textCapitalization: TextCapitalization.characters,
      textInputAction: textInputAction,
      inputFormatters: [
        LicensePlateInputFormatter(),
      ],
    );
  }
}

// Automatically format input to follow the pattern ABC-1234
class LicensePlateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    String text = newValue.text.toUpperCase();

    text = text.replaceAll(RegExp(r'[^A-Z0-9]'), '');

    // Insert dash after 3 characters
    if (text.length > 3) {
      text = '${text.substring(0, 3)}-${text.substring(3)}';
    }

    // Limit to 8 characters
    if (text.length > 8) {
      text = text.substring(0, 8);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}
