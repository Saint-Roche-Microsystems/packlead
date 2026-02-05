import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class OrderAddFormScreen extends ConsumerStatefulWidget {
  const OrderAddFormScreen({super.key});

  @override
  ConsumerState<OrderAddFormScreen> createState() => _OrderAddFormScreenState();
}

class _OrderAddFormScreenState extends ConsumerState<OrderAddFormScreen> {
  final _clientCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _dispatcherCtrl = TextEditingController();
  final _dispatcherIdCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  bool _isSaving = false;

  @override
  void dispose() {
    _clientCtrl.dispose();
    _phoneCtrl.dispose();
    _zoneCtrl.dispose();
    _dispatcherCtrl.dispose();
    _dispatcherIdCtrl.dispose();
    _addressCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final client = _clientCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    final zone = _zoneCtrl.text.trim();
    final address = _addressCtrl.text.trim();
    final dispatcherName = _dispatcherCtrl.text.trim();
    final dispatcherId = _dispatcherIdCtrl.text.trim();

    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());

    if (client.isEmpty || phone.isEmpty || zone.isEmpty || lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa cliente, teléfono, zona, latitud y longitud.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final newOrder = Order(
        id: '',
        clientName: client,
        clientPhoneNumber: phone,
        zone: zone,
        location: Location(lat: lat, lng: lng),
        dispatcherId: dispatcherId,
        address: address.isEmpty ? null : address,
        state: OrderState.pending,
        createdAt: DateTime.now(),
      );

      await ref.read(orderMutationProvider.notifier).createOrder(newOrder);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pedido creado')), // brief success info
        );
        Navigator.pop(context);
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo crear el pedido: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Cliente', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _clientCtrl,
              decoration: _inputDecoration('Nombre del cliente'),
            ),
            const SizedBox(height: 20),

            Text('Teléfono', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration('+51 999 999 999'),
            ),
            const SizedBox(height: 20),

            Text('Zona', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _zoneCtrl,
              decoration: _inputDecoration('Ej: Miraflores'),
            ),
            const SizedBox(height: 20),

            Text('Despachador (opcional)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _dispatcherCtrl,
              decoration: _inputDecoration('Nombre del despachador'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dispatcherIdCtrl,
              decoration: _inputDecoration('ID del despachador'),
            ),
            const SizedBox(height: 20),

            Text('Dirección (opcional)', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _addressCtrl,
              decoration: _inputDecoration('Av. Example 123'),
            ),
            const SizedBox(height: 20),

            Text('Ubicación', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            Text('Latitud', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _latCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('-12.0464'),
            ),
            const SizedBox(height: 20),

            Text('Longitud', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _lngCtrl,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: _inputDecoration('-77.0428'),
            ),
            const SizedBox(height: 32),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving ? null : () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Guardar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }
}
