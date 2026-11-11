import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'supabase_service.dart';

class LocationService {
  static Future<bool> requestPermission() async {
    var status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<void> uploadCurrentLocation(String userId) async {
    if (await requestPermission()) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      await SupabaseService.client.from('location_logs').insert({
        'user_id': userId,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'accuracy': position.accuracy,
        'is_sharing_active': true,
      });
    }
  }
}