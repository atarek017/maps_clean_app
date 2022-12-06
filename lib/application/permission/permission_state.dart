part of 'permission_cubit.dart';

class PermissionState {
  bool isLocationPermissionGranted;
  bool isLocationServicesEnabled;

  bool get isLocationPermissionsGrantedAndServicesEnable =>
      isLocationPermissionGranted && isLocationServicesEnabled;

  PermissionState({
    this.isLocationPermissionGranted = false,
    this.isLocationServicesEnabled = false,
  });

  PermissionState copyWith({
    bool? isLocationPermissionGranted,
    bool? isLocationServicesEnabled,
  }) {
    return PermissionState(
      isLocationPermissionGranted:
          isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isLocationServicesEnabled:
          isLocationServicesEnabled ?? this.isLocationServicesEnabled,
    );
  }
}
