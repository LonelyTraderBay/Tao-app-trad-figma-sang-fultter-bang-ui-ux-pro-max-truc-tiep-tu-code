import 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';

export 'package:vit_trade_flutter/features/cross_module/domain/entities/cross_module_analytics_entities.dart';
export 'package:vit_trade_flutter/features/cross_module/domain/repositories/cross_module_analytics_repository.dart';

final class CrossModuleAnalyticsViewState {
  const CrossModuleAnalyticsViewState({required this.snapshot});

  final CrossModuleAnalyticsSnapshot snapshot;
}

final class CrossModuleAnalyticsController {
  const CrossModuleAnalyticsController({required this.state});

  final CrossModuleAnalyticsViewState state;

  bool supportsTab(CrossModuleAnalyticsTab tab) {
    return state.snapshot.tabs.any((item) => item.tab == tab);
  }
}
