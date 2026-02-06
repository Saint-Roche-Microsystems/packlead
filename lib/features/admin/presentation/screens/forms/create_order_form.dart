import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/validators/order_form_validators.dart';
import 'package:packlead/core/validators/phone_validators.dart';
import 'package:packlead/core/widgets/dispatcher_dropdown_field.dart';
import 'package:packlead/core/widgets/form_action_buttons.dart';
import 'package:packlead/core/widgets/form_fields/location_button_selector.dart';
import 'package:packlead/core/widgets/form_fields/phone_field.dart';
import 'package:packlead/core/widgets/form_fields/text_field.dart';
import 'package:packlead/core/widgets/snackbars.dart';
import 'package:packlead/features/orders/presentation/providers/orders_provider.dart';

class CreateOrderForm extends ConsumerStatefulWidget {
  const CreateOrderForm({super.key});

  @override
  ConsumerState<CreateOrderForm> createState() => _CreateOrderFormState();
}

class _CreateOrderFormState extends ConsumerState<CreateOrderForm> {
  final _formKey = GlobalKey<FormState>();
  final _clientNameCtrl = TextEditingController();
  final _clientPhoneCtrl = TextEditingController();
  final _zoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  String? _selectedDispatcherId;
  String? _locationError;

  @override
  void dispose() {
    _clientNameCtrl.dispose();
    _clientPhoneCtrl.dispose();
    _zoneCtrl.dispose();
    _addressCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  bool _validateLocation() {
    final lat = double.tryParse(_latCtrl.text);
    final lng = double.tryParse(_lngCtrl.text);
    return lat != null && lng != null;
  }

  Future<void> _submit() async {
    final isValidForm = _formKey.currentState!.validate();
    final isLocationValid = _validateLocation();

    if(!isValidForm || !isLocationValid) {
      if(!isLocationValid) {
        setState(() {
          _locationError = 'Debe seleccionar una ubicación en el mapa';
        });
      } else {
        setState(() {
          _locationError = null;
        });
      }
      return;
    }

    setState(() {
      _locationError = null;
    });

    final lat = double.tryParse(_latCtrl.text.trim());
    final lng = double.tryParse(_lngCtrl.text.trim());
    final formatedPhone = PhoneValidators.formatEC(_clientPhoneCtrl.text.trim());

    final newOrder = Order(
      id: '',
      clientName: _clientNameCtrl.text.trim(),
      dispatcherId: _selectedDispatcherId,
      clientPhoneNumber: formatedPhone,
      location: Location(lat: lat!, lng: lng!),
      state: OrderState.pending,
      zone: _zoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      createdAt: DateTime.now()
    );

    await ref.read(orderMutationProvider.notifier).createOrder(newOrder);
  }

  @override
  Widget build(BuildContext context) {

    // Secondary event listeners
    ref.listen<AsyncValue<void>>(orderMutationProvider, (previous, next) {

      if(previous?.isLoading == true && next.hasValue) {
        ScaffoldMessenger.of(context).showSnackBar(
          SuccessSnackBar(message: 'Pedido creado exitosamente'),
        );

        Navigator.pop(context);
      }

      if(next.hasError && previous?.hasError != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackBar(message: 'Ha ocurrido un error al crear el pedido'),
        );
      }
    });

    // Current UI state observer
    bool isLoading = ref.watch(orderMutationProvider).isLoading;

    // UI render
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Pedido'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SaintTextField(
                controller: _clientNameCtrl,
                label: 'Cliente',
                hint: 'Nombre del cliente',
                validator: OrderFormValidators.validateClientName,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              PhoneField(
                controller: _clientPhoneCtrl,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              SaintTextField(
                controller: _zoneCtrl,
                label: 'Zona',
                hint: 'Ej: Miraflores',
                validator: OrderFormValidators.validateZone,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              DispatcherDropdownField(
                selectedId: _selectedDispatcherId,
                onChanged: (id) => setState(() => _selectedDispatcherId = id),
                enabled: !isLoading,
              ),

              SizedBox(height: 20),

              SaintTextField(
                controller: _addressCtrl,
                label: 'Dirección (opcional)',
                hint: 'Calle princiapal #123 calle secundaria',
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
                maxLines: 2,
              ),

              SizedBox(height: 20),

              LocationButtonSelector(
                latitudeController: _latCtrl,
                longitudeController: _lngCtrl,
                enabled: !isLoading,
                errorText: _locationError,
                onLocationChanged: () {
                  if (_locationError != null) {
                    setState(() {
                      _locationError = null;
                    });
                  }
                },
              ),

              SizedBox(height: 32),

              FormActionButtons(
                onCancel: () => Navigator.pop(context),
                onConfirm: _submit,
                isLoading: isLoading,
                confirmText: 'Guardar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}