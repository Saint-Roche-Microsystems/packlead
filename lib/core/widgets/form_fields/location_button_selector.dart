import 'package:flutter/material.dart';
import 'package:packlead/core/models/location.dart';
import 'package:packlead/core/themes/index.dart';
import 'package:packlead/core/widgets/maps/location_picker_map.dart';

class LocationButtonSelector extends StatelessWidget {
  final TextEditingController latitudeController;
  final TextEditingController longitudeController;
  final bool enabled;
  final String? errorText;
  final VoidCallback? onLocationChanged;

  const LocationButtonSelector({
    super.key,
    required this.latitudeController,
    required this.longitudeController,
    this.enabled = true,
    this.errorText,
    this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    Future<void> selectLocationOnMap() async {
      final currentLat = double.tryParse(latitudeController.text);
      final currentLng = double.tryParse(longitudeController.text);

      Location? initialLocation;
      if (currentLat != null && currentLng != null) {
        initialLocation = Location(lat: currentLat, lng: currentLng);
      }

      await Navigator.push<Location>(
        context,
        MaterialPageRoute(
          builder: (context) => LocationPickerMap(
            initialLocation: initialLocation,
            onLocationConfirmed: (Location selectedLocation) {
              // We know for sure that the user selected a location
              // we can update the controller values safely
              latitudeController.text = selectedLocation.lat.toStringAsFixed(6);
              longitudeController.text = selectedLocation.lng.toStringAsFixed(
                6,
              );
              // Notify the change to the parent (in this case it refresh the error message)
              onLocationChanged?.call();
            },
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        ElevatedButton.icon(
          onPressed: selectLocationOnMap,
          icon: Icon(Icons.location_on),
          label: Text('Seleccionar ubicación en el mapa'),
          style: ElevatedButton.styleFrom(
            backgroundColor: SaintColors.primary,
            foregroundColor: Colors.white,
          ),
        ),

        // From the parent we check if the coordinates are valid from the form
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 12.0),
            child: Text(
              errorText!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: SaintColors.error),
            ),
          ),
      ],
    );
  }
}
