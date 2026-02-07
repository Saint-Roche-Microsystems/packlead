import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';

class OrderActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? color;
  final Color? textColor;
  final double height;

  const OrderActionButton({
    super.key,
    required this.label,
    this.icon,
    this.onPressed,
    this.isLoading = false,
    this.color,
    this.textColor,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isEnabled = onPressed != null && !isLoading;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? theme.primaryColor,
          foregroundColor: textColor ?? Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          disabledForegroundColor: Colors.grey.shade500,
          elevation: isEnabled ? 2 : 0,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
        ),
        child: _buildContent(context),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (icon != null) {
      return _buildWithIcon();
    }

    return _buildTextOnly();
  }

  Widget _buildLoadingState() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              textColor ?? Colors.white,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Procesando...',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildWithIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: textColor ?? Colors.white,
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor ?? Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildTextOnly() {
    return Text(
      label,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor ?? Colors.white,
      ),
    );
  }
}

/// Factory methods based on transition state
extension OrderActionButtonPresets on OrderActionButton {
  /// (pending → shipped)
  static OrderActionButton startDelivery({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return OrderActionButton(
      label: 'Iniciar Entrega',
      icon: Icons.play_arrow,
      onPressed: onPressed,
      isLoading: isLoading,
      color: SaintColors.primary,
    );
  }

  /// (shipped → delivered)
  static OrderActionButton completeDelivery({
    required VoidCallback? onPressed,
    bool isLoading = false,
  }) {
    return OrderActionButton(
      label: 'Marcar como Entregada',
      icon: Icons.check_circle_outline,
      onPressed: onPressed,
      isLoading: isLoading,
      color: SaintColors.success,
    );
  }

  /// When no order is selected
  static OrderActionButton noSelection() {
    return const OrderActionButton(
      label: 'Seleccione una orden',
      icon: Icons.info_outline,
      onPressed: null,
      isLoading: false,
    );
  }

  /// Generic action button
  static OrderActionButton action({
    required String label,
    IconData? icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Color? color,
  }) {
    return OrderActionButton(
      label: label,
      icon: icon,
      onPressed: onPressed,
      isLoading: isLoading,
      color: color,
    );
  }
}