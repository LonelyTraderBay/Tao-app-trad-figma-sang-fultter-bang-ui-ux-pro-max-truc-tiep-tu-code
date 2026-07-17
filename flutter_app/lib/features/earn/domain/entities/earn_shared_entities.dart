part of 'earn_entities.dart';

/// UI states shared across the earn feature's screens.
enum EarnScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}

/// Relative risk tier used to badge earn products, positions, and tips.
enum EarnRiskLevel { low, medium, high }
