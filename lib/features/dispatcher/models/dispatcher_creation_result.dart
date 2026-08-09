import 'package:packlead/core/models/dispatcher.dart';

/// `POST /dispatchers` does not return a usable password - it creates the
/// Firebase user and returns a `passwordResetLink` for the admin to share
class DispatcherCreationResult {
  final Dispatcher dispatcher;
  final String? passwordResetLink;

  const DispatcherCreationResult({
    required this.dispatcher,
    this.passwordResetLink,
  });
}
