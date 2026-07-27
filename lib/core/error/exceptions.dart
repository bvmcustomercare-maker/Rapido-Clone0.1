/// Custom exceptions representing data-layer errors (teck-stack.md §4)
class DatabaseException implements Exception {
  final String message;
  const DatabaseException(this.message);

  @override
  String toString() => 'DatabaseException: $message';
}

class SimulationException implements Exception {
  final String message;
  const SimulationException(this.message);

  @override
  String toString() => 'SimulationException: $message';
}

class PermissionException implements Exception {
  final String message;
  const PermissionException(this.message);

  @override
  String toString() => 'PermissionException: $message';
}
