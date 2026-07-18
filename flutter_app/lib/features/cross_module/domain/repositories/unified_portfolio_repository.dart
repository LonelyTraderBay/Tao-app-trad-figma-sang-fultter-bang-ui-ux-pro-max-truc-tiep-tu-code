import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

/// Data source contract for the unified (cross-module) portfolio
/// dashboard.
abstract interface class UnifiedPortfolioRepository {
  Future<UnifiedPortfolioSnapshot> getDashboard();
}
