import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity state representation for offline/online simulations
enum ConnectivityStatus {
  online,
  offline,
}

/// State notifier managing simulated internet connection toggling (teck-stack.md §4)
class ConnectivityStateNotifier extends StateNotifier<ConnectivityStatus> {
  ConnectivityStateNotifier() : super(ConnectivityStatus.online);

  void toggleStatus() {
    state = state == ConnectivityStatus.online
        ? ConnectivityStatus.offline
        : ConnectivityStatus.online;
  }

  void setOnline() => state = ConnectivityStatus.online;
  void setOffline() => state = ConnectivityStatus.offline;
}

/// Riverpod provider for simulated connectivity status
final connectivityStateProvider = StateNotifierProvider<ConnectivityStateNotifier, ConnectivityStatus>((ref) {
  return ConnectivityStateNotifier();
});
