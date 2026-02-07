import 'package:flutter/material.dart';
import 'package:packlead/core/models/order.dart';
import 'package:packlead/core/constants/order_state.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/core/utils/date_formatter.dart';


class DispatcherOrderListItem extends StatelessWidget {
  final Order order;
  final bool isSelected; // is current order selected?
  final bool isEnabled;  // is item enabled for interaction? (can not select if delivered or if there's an active shipped order)
  final VoidCallback? onTap;

  const DispatcherOrderListItem({
    super.key,
    required this.order,
    this.isSelected = false,
    this.isEnabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDelivered = order.state == OrderState.delivered;

    Widget content = Container(
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? onTap : null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Context Row: Client Name + Status Badge
                Row(
                  children: [
                    Icon(
                      order.state.icon,
                      color: order.state.color,
                      size: 20,
                    ),

                    const SizedBox(width: 8),

                    Expanded(
                      child: Text(
                        order.clientName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: isDelivered
                              ? TextDecoration.lineThrough
                              : null,
                          color: isDelivered
                              ? Colors.grey.shade600
                              : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    _buildStateBadge(context),
                  ],
                ),

                const SizedBox(height: 8),

                // Address Row: Icon + Address Text
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 16,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        order.address ?? 'Sin dirección',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                          decoration: isDelivered
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Information Row: Zone + Delivery Date
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isDelivered
                            ? Colors.grey.shade200
                            : Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        order.zone,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDelivered
                              ? Colors.grey.shade600
                              : SaintColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatDate(order.deliveryDate),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Opacity if it is delivered
    if (isDelivered) {
      content = Opacity(
        opacity: 0.5,
        child: content,
      );
    }

    return content;
  }

  // VISUAL HELPERS
  Color _getBackgroundColor() {
    if (order.state == OrderState.delivered) {
      return Colors.grey.shade100;
    }

    if (isSelected) {
      return Colors.blue.shade50;
    }

    return Colors.white;
  }

  Widget _buildStateBadge(BuildContext context) {
    String label = order.state.label;
    Color color = order.state.color;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}