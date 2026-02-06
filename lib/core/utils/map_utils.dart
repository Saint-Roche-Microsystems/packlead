import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:packlead/core/models/location.dart';

class MapUtils {
  MapUtils._();

  /// Open Google Maps with a query for the given location
  static Future<void> openInGoogleMaps(Location location) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.lng}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  ///TODO obtain directions from API
  static Future<List<Location>> getRoute({
    required Location origin,
    required Location destination,
    String travelMode = 'driving',
  }) async {
    return [];
  }

  /// Center the camera at a location
  static Future<void> animateToLocation(
      GoogleMapController controller,
      Location location, {
        double zoom = 15,
      }) async {
    await controller.animateCamera(
      CameraUpdate.newLatLngZoom(location.toLatLng(), zoom),
    );
  }
}