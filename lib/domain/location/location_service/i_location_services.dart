import 'package:maps_clean_app/domain/location/location_model/location_model.dart';

abstract class ILocationServices {
  Stream<LocationModel> get positionStream;

}
