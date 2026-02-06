import 'package:flutter/material.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/features/admin/viewmodels/admin_orders_view_model.dart';

class OrderDetailDialog extends StatelessWidget {
  final AdminOrdersViewModel orderVM;

  const OrderDetailDialog({super.key, required this.orderVM});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pedido ${orderVM.id}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailRow('Cliente', orderVM.clientName),
            _buildDetailRow('Teléfono', orderVM.clientPhoneNumber),
            _buildDetailRow('Estado', orderVM.state.label),
            _buildDetailRow('Zona', orderVM.zone),
            _buildDetailRow('Repartidor', orderVM.dispatcherName ?? 'No asignado'),
            _buildDetailRow(
              'Ubicación',
              'Lat: ${orderVM.location.lat.toStringAsFixed(4)}, Lng: ${orderVM.location.lng.toStringAsFixed(4)}',
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
