import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/features/admin/presentation/widgets/legend_item.dart';

class OrdersDonutChart extends StatelessWidget {
  final int pending;
  final int inRoute;
  final int completed;

  const OrdersDonutChart({
    super.key,
    required this.pending,
    required this.inRoute,
    required this.completed,
  });

  static const colorPending = SaintColors.warning;
  static const colorInRoute = SaintColors.primary;
  static const colorCompleted = SaintColors.success;

  @override
  Widget build(BuildContext context) {
    final total = pending + inRoute + completed;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                centerSpaceRadius: 55,
                sectionsSpace: 2,
                sections: [
                  _buildSection(
                    value: pending.toDouble(),
                    color: colorPending,
                    title: _percentage(pending, total),
                  ),
                  _buildSection(
                    value: inRoute.toDouble(),
                    color: colorInRoute,
                    title: _percentage(inRoute, total),
                  ),
                  _buildSection(
                    value: completed.toDouble(),
                    color: colorCompleted,
                    title: _percentage(completed, total),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildLegend(),
        ],
      ),
    );
  }

  PieChartSectionData _buildSection({
    required double value,
    required Color color,
    required String title,
  }) {
    return PieChartSectionData(
      value: value,
      color: color,
      radius: 40,
      title: title,
      titleStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  String _percentage(int value, int total) {
    if (total == 0) return '0%';
    return '${((value / total) * 100).round()}%';
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LegendItem(
          value: pending,
          label: 'Pendientes',
          color: SaintColors.warning,
        ),
        const SizedBox(width: 36),
        LegendItem(
          value: inRoute,
          label: 'En ruta',
          color: SaintColors.primary,
        ),
        const SizedBox(width: 36),
        LegendItem(
          value: completed,
          label: 'Completados',
          color: SaintColors.success,
        ),
      ],
    );
  }
}
