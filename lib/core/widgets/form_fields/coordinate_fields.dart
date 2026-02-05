import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:packlead/core/validators/coordinate_validators.dart';
import 'package:packlead/core/widgets/form_fields/base_text_field.dart';

class LatitudeField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction? textInputAction;

  const LatitudeField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      label: 'Latitud',
      hint: '-0.1807',
      validator: CoordinateValidators.validateLatitude,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      ],
      prefixIcon: const Icon(Icons.my_location),
    );
  }
}

class LongitudeField extends StatelessWidget {
  final TextEditingController controller;
  final bool enabled;
  final TextInputAction? textInputAction;

  const LongitudeField({
    super.key,
    required this.controller,
    this.enabled = true,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    return BaseTextField(
      controller: controller,
      label: 'Longitud',
      hint: '-78.4678',
      validator: CoordinateValidators.validateLongitude,
      enabled: enabled,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      textInputAction: textInputAction,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^-?\d*\.?\d*')),
      ],
      prefixIcon: const Icon(Icons.location_on),
    );
  }
}

class CoordinateFields extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final String label;
  final bool enabled;

  const CoordinateFields({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
    this.enabled = true,
    this.label = 'Ubicacion',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)
        ),

        const SizedBox(height: 8),

        Row(
          children: [
            Expanded(
              child: LatitudeField(
                controller: latitudeController,
                enabled: enabled,
                textInputAction: TextInputAction.next,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: LongitudeField(
                controller: longitudeController,
                enabled: enabled,
                textInputAction: TextInputAction.done,
              ),
            ),
          ],
        ),
      ],
    );
  }
}