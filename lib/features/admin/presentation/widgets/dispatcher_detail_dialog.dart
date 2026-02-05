import 'package:flutter/material.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';

class DispatcherDetailDialog extends StatelessWidget {
  final Dispatcher dispatcher;

  const DispatcherDetailDialog({super.key, required this.dispatcher});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Detalles de ${dispatcher.name}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Nombre', dispatcher.name),
            _buildDetailRow('Email', dispatcher.email),
            _buildDetailRow('Estado', dispatcher.state.label),
            _buildDetailRow('Vehículo', dispatcher.vehicle),
            _buildDetailRow('Placa', dispatcher.licensePlate),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
        TextButton(
          onPressed: () {
            // TODO
          },
          style: TextButton.styleFrom(
            foregroundColor: Colors.red,
          ),
          child: const Text('Eliminar'),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
