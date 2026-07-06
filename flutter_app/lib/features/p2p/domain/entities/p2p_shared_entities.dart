part of 'p2p_entities.dart';

// Cross-domain vocabulary used by multiple p2p sub-domains — not owned by
// any single one, so kept separate from the 13 per-domain entity files.

enum P2PTradeType { buy, sell }

enum P2PScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}
