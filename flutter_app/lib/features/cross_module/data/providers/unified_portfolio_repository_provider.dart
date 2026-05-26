import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/unified_portfolio_repository.dart';
import 'package:vit_trade_flutter/features/cross_module/data/repositories/mock_unified_portfolio_repository.dart';

final unifiedPortfolioRepositoryProvider = Provider<UnifiedPortfolioRepository>(
  (ref) {
    return const MockUnifiedPortfolioRepository();
  },
);
