import 'package:flutter/material.dart';
import 'package:packlead/core/models/order.dart';

class OrderStateDialog extends StatefulWidget {
  final Order order;
  const OrderStateDialog({super.key, required this.order});

  @override
  State<OrderStateDialog> createState() => _OrderStateDialogState();
}

class _OrderStateDialogState extends State<OrderStateDialog> {
  late String _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.order.state;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Pedido ORD-${widget.order.id}'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Selecciona el nuevo estado del pedido',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            RadioGroup<String>(
              groupValue: _selectedStatus,
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Pendiente'),
                    value: 'pending',
                  ),
                  RadioListTile<String>(
                    title: const Text('En ruta'),
                    value: 'in_route',
                  ),
                  RadioListTile<String>(
                    title: const Text('Completado'),
                    value: 'delivered',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context, _selectedStatus);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Confirmar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

