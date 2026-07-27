/// Sealed class representing domain-level failures (ENGINEERING_GUIDE.md §1.1/§4)
sealed class Failure {
  final String message;
  const Failure(this.message);
}

/// Represents failures related to local storage or database errors
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// Represents failures related to the simulation engine or system state
class SimulationFailure extends Failure {
  const SimulationFailure(super.message);
}

/// Represents failures related to permissions (e.g. location, notifications)
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Represents generic/unknown application errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
