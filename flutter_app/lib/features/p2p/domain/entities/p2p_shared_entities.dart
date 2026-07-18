part of 'p2p_entities.dart';

// Cross-domain vocabulary used by multiple p2p sub-domains — not owned by
// any single one, so kept separate from the 13 per-domain entity files.

/// Buy or sell direction of a P2P trade.
enum P2PTradeType { buy, sell }

/// UI loading/data state shared by every P2P screen snapshot.
enum P2PScreenState {
  loading,
  empty,
  error,
  offline,
  submitting,
  success,
  realtimeRefresh,
}
