import 'location_permission_status.dart';

abstract class IPermissionServices {
  // granted location permission
  Future<bool> isLocationPermissionGranted();

  // changes in location permission status

  // ----------------------------------- location services ---------------------------//

  // if user enabled location service at time
  Future<bool> isLocationServicesEnabled();

  // changes in location services status
  Stream<bool> get locationServicesStatusStream;


  // Request location permission
  Future<LocationPermissionStatus> requestLocationPermission();
}