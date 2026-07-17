part of 'trade_core_entities.dart';

/// Supported UI states (loading/empty/error/offline/submitting/success/
/// realtime-refresh/ready) shared by trade screen read-model snapshots.
enum TradeScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
  ready,
}
