import '../error/failures.dart';

/// Sealed class representing either a Success with data, or a Failure (ENGINEERING_GUIDE.md §4 Task 1.5)
sealed class Result<T> {
  const Result();

  /// Utility to map the result into a single value
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  );
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return onSuccess(data);
  }
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);

  @override
  R fold<R>(
    R Function(T data) onSuccess,
    R Function(Failure failure) onFailure,
  ) {
    return onFailure(failure);
  }
}
