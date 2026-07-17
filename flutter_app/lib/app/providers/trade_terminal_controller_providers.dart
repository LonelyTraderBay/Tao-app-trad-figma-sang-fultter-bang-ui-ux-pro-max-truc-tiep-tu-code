// Advanced terminal demo controller providers only.
// Spot / Futures / Margin / Convert live in trade_controller_providers.dart.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_terminal/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/repositories/spot_trade_repository.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/controllers/trade_controller_models.dart';

/// Shared read-model used by advanced terminal demos (chart / quality / etc.).
final tradeReadModelControllerProvider = Provider<SpotTradeRepository>((ref) {
  return ref.watch(spotTradeRepositoryProvider);
});

final tradeRiskManagementControllerProvider =
    Provider<TradeRiskManagementController>((ref) {
      final repository = ref.watch(spotTradeRepositoryProvider);
      return TradeRiskManagementController(
        repository: repository,
        state: TradeRiskManagementViewState(
          snapshot: repository.getRiskManagement(),
        ),
      );
    });

final tradeAdvancedToolsControllerProvider =
    Provider<TradeAdvancedToolsController>((ref) {
      final repository = ref.watch(spotTradeRepositoryProvider);
      return TradeAdvancedToolsController(
        repository: repository,
        state: TradeAdvancedToolsViewState(
          snapshot: repository.getAdvancedTools(),
        ),
      );
    });
