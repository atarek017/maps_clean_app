import 'package:geolocator/geolocator.dart';
import 'package:maps_clean_app/domain/permetions/location_permission_status.dart';
import 'package:maps_clean_app/domain/permetions/i_permention_service.dart';

class PermissionServicesImpl implements IPermissionServices {
  @override
  Stream<bool> get locationServicesStatusStream =>
      Geolocator.getServiceStatusStream()
          .map((serviceStatus) => serviceStatus == ServiceStatus.enabled);

  @override
  Future<bool> isLocationPermissionGranted() async {
    final status = await Geolocator.checkPermission();
    final isGranted = status == LocationPermission.always ||
        status == LocationPermission.whileInUse;
    return isGranted;
  }

  @override
  Future<bool> isLocationServicesEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  Future<LocationPermissionStatus> requestLocationPermission() async {
    final status = await Geolocator.requestPermission();
    LocationPermissionStatus result = LocationPermissionStatus.granted;

    switch (status) {
      case LocationPermission.deniedForever:
        result = LocationPermissionStatus.deniedForEver;
        break;

      case LocationPermission.denied:
        result = LocationPermissionStatus.denied;
        break;
      case LocationPermission.unableToDetermine:
        result = LocationPermissionStatus.denied;
        break;
    }

    return result;
  }

  @override
  Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<void> openLocationSettings() {
    return Geolocator.openLocationSettings();
  }
}
