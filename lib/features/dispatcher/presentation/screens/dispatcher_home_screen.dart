import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/map_widget.dart';
import 'package:packlead/features/dispatcher/presentation/widgets/order_bottom_sheet.dart';

import 'package:packlead/navigation/routers/auth_router.dart';
import 'package:packlead/services/mock_services/mock_auth_service.dart';

class DispatcherHomeScreen extends StatefulWidget {
  const DispatcherHomeScreen({super.key});

  @override
  State<DispatcherHomeScreen> createState() => _DispatcherHomeScreenState();
}

class _DispatcherHomeScreenState extends State<DispatcherHomeScreen> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLng(_currentPosition!),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
      body: Stack(
        children: [

          MapWidget(
            currentPosition: _currentPosition,
            isLoading: _isLoading,
            onMapCreated: (controller) {
              _mapController = controller;
            },
          ),

          const OrderBottomSheet(),
        ],
      ),
    );
  }
}