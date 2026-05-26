import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

abstract interface class UnifiedPortfolioRepository {
  UnifiedPortfolioSnapshot getDashboard();
}
