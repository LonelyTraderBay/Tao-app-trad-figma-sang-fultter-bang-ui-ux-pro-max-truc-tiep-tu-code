// Advanced terminal demo controller providers only.
// Spot / Futures / Margin / Convert live in trade_controller_providers.dart.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_core/data/providers/trade_repository_provider.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/controllers/trade_controller_models.dart';

export 'package:vit_trade_flutter/features/trade_terminal/data/providers/trade_repository_provider.dart';

/// Shared read-model used by advanced terminal demos (chart / quality / etc.).
final tradeReadModelControllerProvider = Provider<TradeReadModelController>((
  ref,
) {
  return ref.watch(tradeRepositoryProvider);
});

final tradeRiskManagementControllerProvider =
    Provider<TradeRiskManagementController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeRiskManagementController(
        repository: repository,
        state: TradeRiskManagementViewState(
          snapshot: repository.getRiskManagement(),
        ),
      );
    });

final tradeAdvancedToolsControllerProvider =
    Provider<TradeAdvancedToolsController>((ref) {
      final repository = ref.watch(tradeRepositoryProvider);
      return TradeAdvancedToolsController(
        repository: repository,
        state: TradeAdvancedToolsViewState(
          snapshot: repository.getAdvancedTools(),
        ),
      );
    });
