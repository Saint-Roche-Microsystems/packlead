import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/core/errors/error_handler.dart';
import 'package:packlead/core/widgets/error_screen.dart';
import 'package:packlead/features/admin/presentation/providers/admin_dashboard_provider.dart';
import 'package:packlead/features/admin/presentation/widgets/kpi_card.dart';
import 'package:packlead/features/admin/presentation/widgets/order_donut_chart.dart';

class AdminHomeScreen extends ConsumerWidget {

  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.all(20),
      child: dashboardAsync.when(
        data: (dashboard) => Consumer(
          builder: (context, ref, child) {
            return RefreshIndicator(
              onRefresh: () => ref.read(adminDashboardProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        // Orders from Today Card
                        KPICard(
                          title: "Pedidos del día",
                          icon: Icons.receipt_long,
                          value: dashboard.totalOrders,
                        ),

                        // Available Dispatchers Card
                        KPICard(
                          title: "Repartidores activos",
                          icon: Icons.local_shipping,
                          value: dashboard.totalOnlineDispatchers,
                        ),
                      ],
                    ),

                    SizedBox(height: 30),

                    Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Text(
                        "Progreso del Día",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    SizedBox(height: 12,),

                    OrdersDonutChart(
                      pending: dashboard.pendingOrders,
                      inRoute: dashboard.shippedOrders,
                      completed: dashboard.deliveredOrders,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorScreen(
            title: 'Oops! Ocurrió un error al obtener los datos del dashboard',
            message: ErrorHandler.getErrorMessage(error),
            onRetry: () => ref.read(adminDashboardProvider.notifier).refresh(),
        ),
      ),
    );
  }
}