import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

class SuccessSnackBar extends SnackBar {
  SuccessSnackBar({
    super.key,
    required String message,
    super.duration = const Duration(seconds: 3),
  }) : super(
         content: Row(
           children: [
             const Icon(Icons.check_circle, color: Colors.white),
             const SizedBox(width: 12),
             Expanded(
               child: Text(
                 message,
                 style: const TextStyle(color: Colors.white),
               ),
             ),
           ],
         ),
         backgroundColor: SaintColors.success,
         behavior: SnackBarBehavior.floating,
       );
}

class ErrorSnackBar extends SnackBar {
  ErrorSnackBar({
    super.key,
    required String message,
    super.duration = const Duration(seconds: 3),
  }) : super(
         content: Row(
           children: [
             Icon(Icons.error_outline, color: Colors.white),
             SizedBox(width: 12),
             Expanded(
               child: Text(message, style: TextStyle(color: Colors.white)),
             ),
           ],
         ),
         backgroundColor: SaintColors.error,
         behavior: SnackBarBehavior.floating,
       );
}
