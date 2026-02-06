import 'package:flutter/material.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/utils/map_utils.dart';
import 'package:packlead/core/widgets/maps/static_location_map.dart';
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
            _buildMapPreview(orderVM.location),
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

  Widget _buildMapPreview(Location location) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ubicación',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          StaticLocationMap(
            location: location,
            zoom: 16,
            height: 250,
            onTap: () => MapUtils.openInGoogleMaps(location),
          )
        ],
      ),
    );
  }
}
