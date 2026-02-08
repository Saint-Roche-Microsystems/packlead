import 'package:flutter/material.dart';
import 'package:packlead/features/admin/presentation/screens/admin_dispatcher_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_order_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_tracking_screen.dart';
import 'package:packlead/navigation/routers/auth_router.dart';
import 'package:packlead/services/mock_services/mock_auth_service.dart';

class AdminBottomNavLayout extends StatefulWidget {
  const AdminBottomNavLayout({super.key});

  @override
  State<AdminBottomNavLayout> createState() => _AdminBottomNavLayoutState();
}

class _AdminBottomNavLayoutState extends State<AdminBottomNavLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    AdminHomeScreen(),
    AdminOrderScreen(),
    AdminDispatcherScreen(),
    AdminTrackingScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout(BuildContext context) {
    MockAuthService.logout();
    Navigator.pushReplacementNamed(context, AuthRouter.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Packlead'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            tooltip: 'Salir',
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Repartidores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapa',
          ),
        ],
      ),
    );
  }
}

