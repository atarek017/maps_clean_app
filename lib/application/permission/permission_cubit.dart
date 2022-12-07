import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/permetions/location_permission_status.dart';
import '../../domain/permetions/i_permention_service.dart';
import '../app_life_cycle/application_life_cycle_cubit.dart';

part 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  final IPermissionServices _iPermissionServices;
  StreamSubscription? _locationServicesStatusSubscription;

  final ApplicationLifeCycleCubit _applicationLifeCycleCubit;
  StreamSubscription<Iterable<ApplicationLifeCycleState>>?
      _appLifeCycleSubscription;

  PermissionCubit(this._iPermissionServices, this._applicationLifeCycleCubit)
      : super(PermissionState()) {
    /// Location Permission isGranted
    _iPermissionServices
        .isLocationPermissionGranted()
        .then((bool isLocationPermissionGranted) {
      emit(state.copyWith(
          isLocationPermissionGranted: isLocationPermissionGranted));
    });

    /// Location Services isEnabled
    _iPermissionServices
        .isLocationServicesEnabled()
        .then((bool isLocationServicesEnabled) {
      emit(
          state.copyWith(isLocationServicesEnabled: isLocationServicesEnabled));
    });

    /// Listen on change location Services
    _locationServicesStatusSubscription = _iPermissionServices
        .locationServicesStatusStream
        .listen((isLocationServicesEnabled) {
      emit(
          state.copyWith(isLocationServicesEnabled: isLocationServicesEnabled));
    });

    /// listen on change app life cycle
    _appLifeCycleSubscription = _applicationLifeCycleCubit.stream
        .startWith(_applicationLifeCycleCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;

      if (previous.isResumed != current.isResumed && current.isResumed) {
        bool isGranted = await _iPermissionServices.isLocationPermissionGranted();
        if(state.isLocationPermissionGranted !=isGranted && isGranted){
          hideOpenAppSettingsDialog();
        }

        emit(state.copyWith(isLocationPermissionGranted: isGranted));
      }
    });
  }


  void hideOpenAppSettingsDialog() {
    emit(state.copyWith(displayOpenAppSettingsDialog: false));
  }


  Future<void> requestLocationPermission() async {
    final status = await _iPermissionServices.requestLocationPermission();
    bool displayOpenAppSettingsDialog=status==LocationPermissionStatus.deniedForEver;

    final bool isGranted = status == LocationPermissionStatus.granted;
    emit(state.copyWith(isLocationPermissionGranted: isGranted,displayOpenAppSettingsDialog: displayOpenAppSettingsDialog));
  }

  Future<void> openAppSettings() async {
    await _iPermissionServices.openAppSettings();
  }

  Future<void> openLocationSettings() async {
    await _iPermissionServices.openLocationSettings();
  }

  @override
  Future<void> close() async {
    await _locationServicesStatusSubscription?.cancel();
    await _appLifeCycleSubscription?.cancel();
    return super.close();
  }
}
