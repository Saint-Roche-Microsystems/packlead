import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/services/firebase/dispatcher_location_service.dart';
import 'package:packlead/services/firebase/firebase_providers.dart';

/// Provider to manage the registration of the dispatcher in RTDB
class DispatcherLocationNotifier extends StateNotifier<AsyncValue<void>> {
  final DispatcherLocationService _locationService;
  String? _currentDispatcherId;

  DispatcherLocationNotifier(this._locationService)
      : super(const AsyncValue.data(null));

  /// Register dispatcher when login
  Future<void> register({
    required String dispatcherId,
    required String name,
    required Location initialLocation,
  }) async {
    state = const AsyncValue.loading();

    try {
      await _locationService.registerDispatcher(
        dispatcherId: dispatcherId,
        name: name,
        initialLocation: initialLocation,
      );

      _currentDispatcherId = dispatcherId;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update the location in RTDB
  Future<void> updateLocation(Location location) async {
    if (_currentDispatcherId == null) return;

    try {
      await _locationService.updateLocation(
        dispatcherId: _currentDispatcherId!,
        location: location,
      );
    } catch (error) {
      debugPrint('Error al actualizar ubicación en RTDB: $error');
    }
  }

  /// Unregister dispatcher when leaving the screen
  Future<void> unregister() async {
    if (_currentDispatcherId == null) return;

    try {
      await _locationService.unregisterDispatcher(_currentDispatcherId!);
      _currentDispatcherId = null;
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Verify if it is registered
  bool get isRegistered => _currentDispatcherId != null;
}

final dispatcherLocationProvider = StateNotifierProvider.autoDispose<DispatcherLocationNotifier, AsyncValue<void>>((ref) {
  final locationService = ref.watch(dispatcherLocationServiceProvider);
  final notifier = DispatcherLocationNotifier(locationService);

  ref.onDispose(() {
    notifier.unregister();
  });

  ref.keepAlive();

  return notifier;
});