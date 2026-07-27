import 'package:hive/hive.dart';
import '../models/ride_dto.dart';

abstract class RideLocalDataSource {
  Future<void> saveRide(RideDto ride);
  Future<List<RideDto>> getAllRides();
  Future<void> deleteRide(String id);
}

class RideLocalDataSourceImpl implements RideLocalDataSource {
  final Box<RideDto> _ridesBox;

  RideLocalDataSourceImpl(this._ridesBox);

  @override
  Future<void> saveRide(RideDto ride) async {
    await _ridesBox.put(ride.id, ride);
  }

  @override
  Future<List<RideDto>> getAllRides() async {
    return _ridesBox.values.toList();
  }

  @override
  Future<void> deleteRide(String id) async {
    await _ridesBox.delete(id);
  }
}
