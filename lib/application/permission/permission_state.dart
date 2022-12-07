part of 'permission_cubit.dart';

class PermissionState {
  bool isLocationPermissionGranted;
  bool isLocationServicesEnabled;
  bool displayOpenAppSettingsDialog;

  bool get isLocationPermissionsGrantedAndServicesEnable =>
      isLocationPermissionGranted && isLocationServicesEnabled;

  PermissionState({
    this.isLocationPermissionGranted = false,
    this.isLocationServicesEnabled = false,
    this.displayOpenAppSettingsDialog = false,
  });

  PermissionState copyWith({
    bool? isLocationPermissionGranted,
    bool? isLocationServicesEnabled,
    bool? displayOpenAppSettingsDialog,
  }) {
    return PermissionState(
      isLocationPermissionGranted:
          isLocationPermissionGranted ?? this.isLocationPermissionGranted,
      isLocationServicesEnabled: isLocationServicesEnabled ?? this.isLocationServicesEnabled,
      displayOpenAppSettingsDialog: displayOpenAppSettingsDialog ?? this.displayOpenAppSettingsDialog,
    );
  }
}
