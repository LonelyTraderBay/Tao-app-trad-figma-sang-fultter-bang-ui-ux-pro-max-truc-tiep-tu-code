import 'package:vit_trade_flutter/features/cross_module/domain/entities/unified_portfolio_errors.dart';
import 'package:vit_trade_flutter/features/cross_module/domain/repositories/unified_portfolio_repository.dart';

final class FailClosedUnifiedPortfolioRepository
    implements UnifiedPortfolioRepository {
  const FailClosedUnifiedPortfolioRepository();

  @override
  Never noSuchMethod(Invocation invocation) {
    throw const UnifiedPortfolioBackendContractMissingException();
  }
}
