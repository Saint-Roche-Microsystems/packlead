import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/constants/dispatcher_state.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/core/widgets/state_bagde.dart';
import 'package:packlead/features/dispatcher/presentation/providers/dispatcher_provider.dart';

class DispatcherStateControl extends ConsumerWidget {
  final String dispatcherId;

  const DispatcherStateControl({super.key, required this.dispatcherId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatcher = ref.watch(dispatcherByIdProvider(dispatcherId));

    final mutationState = ref.watch(dispatcherMutationProvider);
    final currentState = dispatcher.value?.state;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Estado',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              StateBadge(
                label: DispatcherState.available.label,
                isActive: currentState == DispatcherState.available,
                color: SaintColors.primary,
                isLoading: mutationState.isLoading,
                onTap: () {
                  ref
                      .read(dispatcherMutationProvider.notifier)
                      .updateDispatcherState(
                        dispatcherId,
                        DispatcherState.available,
                      );
                },
              ),

              const SizedBox(width: 8),

              StateBadge(
                label: DispatcherState.inactive.label,
                isActive: currentState == DispatcherState.inactive,
                color: SaintColors.primary,
                isLoading: mutationState.isLoading,
                onTap: () {
                  ref
                      .read(dispatcherMutationProvider.notifier)
                      .updateDispatcherState(
                        dispatcherId,
                        DispatcherState.inactive,
                      );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
