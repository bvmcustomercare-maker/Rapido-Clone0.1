import '../error/failures.dart';

/// Sealed class representing view model state configurations
sealed class UIState<T> {
  const UIState();

  R fold<R>({
    required R Function() onInitial,
    required R Function() onLoading,
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    if (this is UIStateInitial<T>) return onInitial();
    if (this is UIStateLoading<T>) return onLoading();
    if (this is UIStateSuccess<T>) return onSuccess((this as UIStateSuccess<T>).data);
    if (this is UIStateError<T>) return onError((this as UIStateError<T>).failure);
    throw StateError('Invalid UIState instance type.');
  }
}

class UIStateInitial<T> extends UIState<T> {
  const UIStateInitial();
}

class UIStateLoading<T> extends UIState<T> {
  const UIStateLoading();
}

class UIStateSuccess<T> extends UIState<T> {
  final T data;
  const UIStateSuccess(this.data);
}

class UIStateError<T> extends UIState<T> {
  final Failure failure;
  const UIStateError(this.failure);
}
