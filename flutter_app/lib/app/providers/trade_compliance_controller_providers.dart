import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vit_trade_flutter/features/trade_compliance/domain/entities/trade_compliance_entities.dart';
import 'package:vit_trade_flutter/features/trade_compliance/data/providers/trade_repository_provider.dart';

export 'package:vit_trade_flutter/features/trade_compliance/data/providers/trade_repository_provider.dart';

/// Regulatory/compliance domain controller providers (trade_compliance
/// extraction, Batch 1 of Phase 1 of the trade module split). Pages must not
/// import `features/trade_compliance/data/providers/` directly (architecture
/// rule — presentation depends on `app/providers/*`, not feature data
/// facades); this file re-exports [tradeRegulatoryRepositoryProvider] above
/// and hosts derived controller providers for the domain, starting with
/// [tradeRiskIndicatorExplainerProvider] (moved here from
/// `trade_controller_providers.dart`, now wired to the narrow
/// [tradeRegulatoryRepositoryProvider] instead of the old union
/// `tradeRepositoryProvider`).
final tradeRiskIndicatorExplainerProvider =
    Provider<TradeRiskIndicatorSnapshot>(
      (ref) => ref
          .watch(tradeRegulatoryRepositoryProvider)
          .getRiskIndicatorExplainer(),
    );
