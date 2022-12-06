import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

import '../../domain/location/location_model/location_model.dart';
import '../../domain/location/location_service/i_location_services.dart';
import '../app_life_cycle/application_life_cycle_cubit.dart';
import '../permission/permission_cubit.dart';

part 'location_state.dart';

class LocationCubit extends Cubit<LocationState> {
  final ILocationServices _locationServices;
  final PermissionCubit _permissionCubit;

  final ApplicationLifeCycleCubit _applicationLifeCycleCubit;
  StreamSubscription<LocationModel>? _userPositionSubscription;
  StreamSubscription<Iterable<PermissionState>>? _permissionStatePairSubscription;
  StreamSubscription<Iterable<ApplicationLifeCycleState>>?
      _appLifeCycleStatePairSubscription;

  LocationCubit(this._locationServices, this._permissionCubit,
      this._applicationLifeCycleCubit)
      : super(LocationState.initial()) {
    if (_permissionCubit.state.isLocationPermissionsGrantedAndServicesEnable) {
      _userPositionSubscription =
          _locationServices.positionStream.listen(_userPositionListener);
    }

    /// permission subscription
    _permissionStatePairSubscription = _permissionCubit.stream
        .startWith(_permissionCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;

      if (previous.isLocationPermissionsGrantedAndServicesEnable !=
              current.isLocationPermissionsGrantedAndServicesEnable &&
          current.isLocationPermissionsGrantedAndServicesEnable) {
        await _userPositionSubscription?.cancel();

        _userPositionSubscription =
            _locationServices.positionStream.listen(_userPositionListener);
      } else if (previous.isLocationPermissionsGrantedAndServicesEnable !=
              current.isLocationPermissionsGrantedAndServicesEnable &&
          !current.isLocationPermissionsGrantedAndServicesEnable) {
        _userPositionSubscription?.cancel();
      }
    });

    /// app lifeCycle subscription

    _appLifeCycleStatePairSubscription = _applicationLifeCycleCubit.stream
        .startWith(_applicationLifeCycleCubit.state)
        .pairwise()
        .listen((pair) async {
      final previous = pair.first;
      final current = pair.last;

      final isLocationPermissionsGrantedAndServicesEnable =
          _permissionCubit.state.isLocationPermissionsGrantedAndServicesEnable;

      if (previous.isResumed != current.isResumed &&
          current.isResumed &&
          isLocationPermissionsGrantedAndServicesEnable) {
        await _userPositionSubscription?.cancel();

        _userPositionSubscription =
            _locationServices.positionStream.listen((location) {
          _userPositionListener(location);
        });
      } else if (previous.isResumed != current.isResumed &&
          !current.isResumed) {
        await _userPositionSubscription?.cancel();
      }
    });
  }

  void _userPositionListener(LocationModel location) {
    emit(state.copyWith(userLocation: location));
  }

  @override
  Future<void> close() {
    _userPositionSubscription?.cancel();
    _permissionStatePairSubscription?.cancel();
    _appLifeCycleStatePairSubscription?.cancel();
    return super.close();
  }
}
