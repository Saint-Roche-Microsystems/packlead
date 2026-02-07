import 'package:flutter/material.dart';
import 'package:packlead/core/utils/date_formatter.dart';

class DateField extends StatefulWidget {
  final DateTime? selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final bool enabled;
  final String label;

  const DateField({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
    this.enabled = true,
    this.label = 'Fecha de entrega',
  });

  @override
  State<DateField> createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: widget.enabled ? _selectDate : null,
          child: InputDecorator(
            decoration: _inputDecoration(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.selectedDate != null
                      ? DateFormatter.formatDate(widget.selectedDate!)
                      : 'Seleccionar fecha',
                  style: TextStyle(
                    color: widget.selectedDate != null
                        ? Theme.of(context).textTheme.bodyLarge?.color
                        : Theme.of(context).hintColor,
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: widget.enabled
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).disabledColor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate ?? today,
      firstDate: today,                   // Don't allow selecting past dates
      lastDate: DateTime(today.year + 1), // Select up to one year in the future
      helpText: 'Seleccionar fecha de entrega',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
    );

    if (pickedDate != null) {
      // Get midnight UTC
      final dateAtMidnight = DateTime.utc(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
      );

      widget.onDateSelected(dateAtMidnight);
    }
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      hintText: 'Seleccionar fecha',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      enabled: widget.enabled,
    );
  }
}