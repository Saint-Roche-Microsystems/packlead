import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/models/dispatcher.dart';
import 'package:packlead/core/validators/dispatcher_form_validators.dart';
import 'package:packlead/core/widgets/form_action_buttons.dart';
import 'package:packlead/core/widgets/form_fields/email_field.dart';
import 'package:packlead/core/widgets/form_fields/plate_field.dart';
import 'package:packlead/core/widgets/form_fields/text_field.dart';
import 'package:packlead/core/widgets/snackbars.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';

class CreateDispatcherForm extends ConsumerStatefulWidget {
  const CreateDispatcherForm({super.key});

  @override
  ConsumerState<CreateDispatcherForm> createState() => _CreateDispatcherForm();
}

class _CreateDispatcherForm extends ConsumerState<CreateDispatcherForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _vehicleCtrl = TextEditingController();
  final _plateCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _vehicleCtrl.dispose();
    _plateCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final newDispatcher = Dispatcher(
      id: '',
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      vehicle: _vehicleCtrl.text.trim(),
      licensePlate: _plateCtrl.text.trim(),
      state: DispatcherState.available,
    );

    await ref
        .read(dispatcherMutationProvider.notifier)
        .createDispatcher(newDispatcher);
  }

  /// POST /dispatchers only generates an invite link.
  Future<void> _showInviteLinkDialog(String passwordResetLink) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Repartidor invitado'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Se generó un enlace de invitación. Compártelo con el repartidor '
              'para que establezca su contraseña e inicie sesión.',
            ),
            const SizedBox(height: 16),
            SelectableText(
              passwordResetLink,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        actions: [
          TextButton.icon(
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: passwordResetLink));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SuccessSnackBar(message: 'Enlace copiado al portapapeles'),
                );
              }
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copiar enlace'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Secondary event listeners
    ref.listen<AsyncValue<void>>(dispatcherMutationProvider, (previous, next) {
      if (previous?.isLoading == true && next.hasValue) {
        final passwordResetLink = ref
            .read(dispatcherMutationProvider.notifier)
            .lastCreationResult
            ?.passwordResetLink;

        if (passwordResetLink != null) {
          _showInviteLinkDialog(passwordResetLink);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SuccessSnackBar(message: 'Se ha agregado un nuevo repartidor'),
          );

          Navigator.pop(context);
        }
      }

      if (next.hasError && previous?.hasError != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          ErrorSnackBar(
            message: 'Ha ocurrido un error al agregar un nuevo repartidor',
          ),
        );
      }
    });

    // Current UI state observer
    bool isLoading = ref.watch(dispatcherMutationProvider).isLoading;

    // UI render
    return Scaffold(
      appBar: AppBar(title: const Text('Agregar Repartidor')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SaintTextField(
                controller: _nameCtrl,
                label: 'Nombre',
                hint: 'Nombre del repartidor',
                validator: DispatcherFormValidators.validateName,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              EmailField(
                controller: _emailCtrl,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              SaintTextField(
                controller: _vehicleCtrl,
                label: 'Vehículo',
                hint: 'Marca y modelo del vehículo',
                validator: DispatcherFormValidators.validateVehicle,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 20),

              PlateField(
                controller: _plateCtrl,
                enabled: !isLoading,
                textInputAction: TextInputAction.next,
              ),

              SizedBox(height: 32),

              FormActionButtons(
                onCancel: () => Navigator.pop(context),
                onConfirm: _submit,
                isLoading: isLoading,
                confirmText: 'Registrar',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
