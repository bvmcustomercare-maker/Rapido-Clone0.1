import 'package:flutter/foundation.dart';

/// Enum representing the simulated ride lifecycle states (PRD §6.4)
enum RideStatus {
  /// Initial state: user is reviewing ride details before confirming.
  confirming,

  /// User confirmed; showing radar animation searching for driver.
  searching,

  /// Driver found and assigned; showing driver details and ETA.
  assigned,

  /// Driver is very close to pickup location.
  arriving,

  /// Driver arrived at pickup location, waiting for OTP.
  arrived,

  /// Driver arrived, user picked up, ride in progress.
  started,

  /// Driver reached destination.
  completed,
  
  /// Ride was cancelled by user (or simulation fallback).
  cancelled,
}
