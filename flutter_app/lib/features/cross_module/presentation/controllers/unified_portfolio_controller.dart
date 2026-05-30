import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';

export 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_entities.dart';
export 'package:vit_trade_flutter/features/cross_module/domain/repositories/unified_portfolio_repository.dart';

final class UnifiedPortfolioViewState {
  const UnifiedPortfolioViewState({required this.snapshot});

  final UnifiedPortfolioSnapshot snapshot;
}

final class UnifiedPortfolioController {
  const UnifiedPortfolioController({required this.state});

  final UnifiedPortfolioViewState state;

  bool supportsTab(UnifiedPortfolioTab tab) {
    return state.snapshot.tabs.any((item) => item.tab == tab);
  }
}
