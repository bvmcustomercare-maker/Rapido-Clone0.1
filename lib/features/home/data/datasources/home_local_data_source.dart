import 'package:hive_flutter/hive_flutter.dart';
import '../models/place_dto.dart';

/// Abstract datasource contract for Home local persistence
abstract class HomeLocalDataSource {
  /// Get all stored places sorted by most recent first (max 10)
  Future<List<PlaceDto>> getRecentPlaces();

  /// Get only favourite places
  Future<List<PlaceDto>> getFavouritePlaces();

  /// Add or update a place in the local box
  Future<void> savePlace(PlaceDto place);

  /// Remove a place by id
  Future<void> removePlace(String id);

  /// Clear all places from the box
  Future<void> clearAll();
}

/// Hive implementation of HomeLocalDataSource
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  final Box<PlaceDto> _placesBox;

  HomeLocalDataSourceImpl({required Box<PlaceDto> placesBox})
      : _placesBox = placesBox;

  @override
  Future<List<PlaceDto>> getRecentPlaces() async {
    final all = _placesBox.values.toList();
    // Sort by lastUsedAtMillis descending (most recent first)
    all.sort((a, b) => b.lastUsedAtMillis.compareTo(a.lastUsedAtMillis));
    // Cap to 10 items as per PRD §FR-LOC-003
    return all.take(10).toList();
  }

  @override
  Future<List<PlaceDto>> getFavouritePlaces() async {
    return _placesBox.values.where((p) => p.isFavourite).toList();
  }

  @override
  Future<void> savePlace(PlaceDto place) async {
    await _placesBox.put(place.id, place);
  }

  @override
  Future<void> removePlace(String id) async {
    await _placesBox.delete(id);
  }

  @override
  Future<void> clearAll() async {
    await _placesBox.clear();
  }
}
