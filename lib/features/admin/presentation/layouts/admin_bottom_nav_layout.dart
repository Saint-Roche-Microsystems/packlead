import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:packlead/features/admin/presentation/screens/admin_dispatcher_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_home_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_order_screen.dart';
import 'package:packlead/features/admin/presentation/screens/admin_tracking_screen.dart';
import 'package:packlead/features/auth/presentation/providers/auth_provider.dart';

class AdminBottomNavLayout extends ConsumerStatefulWidget {
  const AdminBottomNavLayout({super.key});

  @override
  ConsumerState<AdminBottomNavLayout> createState() => _AdminBottomNavLayoutState();
}

class _AdminBottomNavLayoutState extends ConsumerState<AdminBottomNavLayout> {
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
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
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

