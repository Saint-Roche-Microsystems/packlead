import 'package:flutter/material.dart';
import 'package:packlead/core/constants/order_state.dart';
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
    _selectedStatus = widget.order.state.label;
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('Pedido ${widget.order.id}'),
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

            Column(
              children: OrderStateOptions.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option['label'] as String),
                  value: option['value'] as String,
                  groupValue: _selectedStatus,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedStatus = value;
                      });
                    }
                  },
                );
              }).toList(),
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

