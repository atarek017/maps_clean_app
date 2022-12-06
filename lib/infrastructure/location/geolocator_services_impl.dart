import 'package:geolocator/geolocator.dart';
import 'package:maps_clean_app/domain/location/location_model/location_model.dart';

import '../../domain/location/location_service/i_location_services.dart';

class GeolocatorLocationServices implements ILocationServices {
  @override
  Stream<LocationModel> get positionStream =>
      Geolocator.getPositionStream(locationSettings:const LocationSettings(accuracy: LocationAccuracy.high,distanceFilter: 100) ).map((position) => LocationModel(latitude: position.latitude, longitude: position.longitude));
}
