import '../error/exceptions.dart';
import '../error/failures.dart';
import '../utils/logger.dart';
import '../utils/result.dart';

/// Base Repository class providing generic data-safe execution helpers (ENGINEERING_GUIDE.md §6.2)
abstract class BaseRepository {
  const BaseRepository();

  /// Execute an asynchronous data-source operation safely, wrapping any exceptions into clean Result failures
  Future<Result<T>> executeSafe<T>(Future<T> Function() operation) async {
    try {
      final data = await operation();
      return Success(data);
    } on DatabaseException catch (e, stack) {
      AppLogger.e('Database exception in repository: ${e.message}', e, stack);
      return FailureResult(DatabaseFailure(e.message));
    } on SimulationException catch (e, stack) {
      AppLogger.e('Simulation exception in repository: ${e.message}', e, stack);
      return FailureResult(SimulationFailure(e.message));
    } on PermissionException catch (e, stack) {
      AppLogger.e('Permission exception in repository: ${e.message}', e, stack);
      return FailureResult(PermissionFailure(e.message));
    } catch (e, stack) {
      AppLogger.f('Unexpected raw error caught in repository: $e', e, stack);
      return FailureResult(UnknownFailure(e.toString()));
    }
  }
}
