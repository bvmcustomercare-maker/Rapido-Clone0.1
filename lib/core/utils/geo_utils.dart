import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Geometry and geographic helpers for mapping & live routing (teck-stack.md §4)
abstract class GeoUtils {
  /// Calculates Haversine distance between two coordinates in Kilometers
  static double haversineDistance(LatLng from, LatLng to) {
    const earthRadiusKm = 6371.0;

    final dLat = _toRadians(to.latitude - from.latitude);
    final dLng = _toRadians(to.longitude - from.longitude);

    final lat1 = _toRadians(from.latitude);
    final lat2 = _toRadians(to.latitude);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLng / 2) * sin(dLng / 2) * cos(lat1) * cos(lat2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  /// Calculates bearing angle between two coordinates (0 - 360 degrees)
  static double calculateBearing(LatLng from, LatLng to) {
    final lat1 = _toRadians(from.latitude);
    final lng1 = _toRadians(from.longitude);
    final lat2 = _toRadians(to.latitude);
    final lng2 = _toRadians(to.longitude);

    final dLng = lng2 - lng1;

    final y = sin(dLng) * cos(lat2);
    final x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);

    final bearing = atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  /// Generates intermediate LatLng waypoints along path with slight jitter (design.md §15)
  static List<LatLng> interpolateRoute(LatLng start, LatLng end, {int steps = 60}) {
    final List<LatLng> points = [];
    final random = Random(start.latitude.toInt() + end.longitude.toInt());

    for (int i = 0; i <= steps; i++) {
      final t = i / steps;
      final lat = start.latitude + (end.latitude - start.latitude) * t;
      final lng = start.longitude + (end.longitude - start.longitude) * t;

      // Slight natural road jitter to simulate physical road paths
      final jitterLat = (i == 0 || i == steps) ? 0.0 : (random.nextDouble() - 0.5) * 0.0003;
      final jitterLng = (i == 0 || i == steps) ? 0.0 : (random.nextDouble() - 0.5) * 0.0003;

      points.add(LatLng(lat + jitterLat, lng + jitterLng));
    }

    return points;
  }

  static double _toRadians(double degree) => degree * pi / 180.0;
  static double _toDegrees(double radian) => radian * 180.0 / pi;
}
