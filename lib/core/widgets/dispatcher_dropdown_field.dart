import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';

class DispatcherDropdownField extends ConsumerWidget {
  final String? selectedId;
  final ValueChanged<String?> onChanged;
  final bool enabled;
  final String label;

  const DispatcherDropdownField({
    super.key,
    required this.selectedId,
    required this.onChanged,
    this.label = 'Repartidor',
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatchersAsync = ref.watch(
        dispatchersByStateProvider(DispatcherState.available)
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500,),
        ),

        const SizedBox(height: 8),

        dispatchersAsync.when(
          data: (dispatchers) => _buildDropdown(context, dispatchers,),
          loading: () => _buildLoadingDropdown(context),
          error: (error, _) => _buildErrorWidget(error),
        ),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context, List<Dispatcher> dispatchers) {
    return DropdownButtonFormField<String>(
      initialValue: selectedId,
      decoration: _inputDecoration('Seleccione un repartidor'),
      items: dispatchers.map((dispatcher) {
        return DropdownMenuItem(
          value: dispatcher.id,
          child: Text(dispatcher.name),
        );
      }).toList(),
      onChanged: enabled ? onChanged : null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Debe seleccionar un repartidor';
        }
        return null;
      },
    );
  }

  Widget _buildLoadingDropdown(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: _inputDecoration('Cargando...').copyWith(
        suffixIcon: const SizedBox(
          width: 20,
          height: 20,
          child: Padding(
            padding: EdgeInsets.all(12.0),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      items: const [],
      onChanged: null,
    );
  }

  Widget _buildErrorWidget(Object error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: SaintColors.error),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Error al cargar repartidores: $error',
              style: TextStyle(color: SaintColors.error),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
    );
  }
}