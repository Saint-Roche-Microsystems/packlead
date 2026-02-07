import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_home_provider.dart';
import 'package:packlead/features/dispatcher/presentation/state/dispatcher_home_state.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/confirmation_dialog.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_action_button.dart';

class OrderBottomSheetActionButton extends ConsumerWidget {
  const OrderBottomSheetActionButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeStateAsync = ref.watch(dispatcherHomeProvider);

    return homeStateAsync.when(
      data: (state) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: _getActionButtonForState(context, ref, state),
        );
      },
      loading: () => Container(
        padding: const EdgeInsets.all(16),
        child: OrderActionButtonPresets.noSelection(),
      ),
      error: (_, __) => Container(
        padding: const EdgeInsets.all(16),
        child: OrderActionButtonPresets.noSelection(),
      ),
    );
  }

  /// Show a button based on the selected order's state:
  Widget _getActionButtonForState(
      BuildContext context,
      WidgetRef ref,
      DispatcherHomeState state,
      ) {

    if (!state.hasSelection) {
      return OrderActionButtonPresets.noSelection();
    }

    final selectedOrder = state.selectedOrder!;

    // OrderState = pending
    if (selectedOrder.state == OrderState.pending) {
      return OrderActionButtonPresets.startDelivery(
        onPressed: () => _handleStartDelivery(context, ref, selectedOrder),
        isLoading: state.isUpdatingOrder,
      );
    }

    // OrderState = shipped
    if (selectedOrder.state == OrderState.shipped) {
      return OrderActionButtonPresets.completeDelivery(
        onPressed: () => _handleCompleteDelivery(context, ref, selectedOrder),
        isLoading: state.isUpdatingOrder,
      );
    }

    // OrderState = delivered
    return OrderActionButtonPresets.noSelection();
  }

  /// ON PRESSED HANDLERS
  /// Begins delivery (pending --> shipped)
  void _handleStartDelivery(
      BuildContext context,
      WidgetRef ref,
      Order order,
      ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Iniciar Entrega',
        content: '¿Confirma que desea iniciar la entrega de la orden para ${order.clientName}?',
        onConfirm: () {
          Navigator.of(context).pop();
          ref.read(dispatcherHomeProvider.notifier).startDelivery(order);
        },
      ),
    );
  }

  /// Ends delivery (shipped --> delivered)
  void _handleCompleteDelivery(
      BuildContext context,
      WidgetRef ref,
      Order order,
      ) {
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Completar Entrega',
        content: '¿Confirma que la orden para ${order.clientName} ha sido entregada exitosamente?',
        onConfirm: () {
          Navigator.of(context).pop();
          ref.read(dispatcherHomeProvider.notifier).completeDelivery(order);
        },
      ),
    );
  }
}
