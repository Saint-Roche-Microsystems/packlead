import 'package:flutter/material.dart';
import 'package:packlead/features/admin/presentation/widgets/kpi_card.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  final int pedidosDelDia = 45;
  final int repartidoresActivos = 8;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[50],
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              // Orders from Today Card
              KPICard(
                title: "Pedidos del día",
                icon: Icons.shopping_bag_rounded,
                value: pedidosDelDia,
              ),

              // Available Dispatchers Card
              KPICard(
                title: "Repartidores activos",
                icon: Icons.fire_truck,
                value: repartidoresActivos,
              ),
            ],
          ),

          SizedBox(height: 30),


        ],
      ),
    );
  }
}