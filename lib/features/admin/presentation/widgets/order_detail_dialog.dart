import 'package:flutter/material.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';

class OrderDetailDialog extends StatelessWidget {
  final Order order;

  const OrderDetailDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pedido ${order.id}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Cliente', order.clientName),
            _buildDetailRow('Teléfono', order.clientPhoneNumber),
            _buildDetailRow('Estado', order.state.label),
            _buildDetailRow('Zona', order.zone),
            _buildDetailRow('Despachador', order.dispatcherName ?? 'No asignado'),
            _buildDetailRow(
              'Ubicación',
              'Lat: ${order.location.lat.toStringAsFixed(4)}, Lng: ${order.location.lng.toStringAsFixed(4)}',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
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
