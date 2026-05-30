import 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';

export 'package:vit_trade_flutter/features/cross_module/domain/entities/smart_alerts_entities.dart';
export 'package:vit_trade_flutter/features/cross_module/domain/repositories/smart_alerts_repository.dart';

final class SmartAlertsViewState {
  const SmartAlertsViewState({required this.snapshot});

  final SmartAlertsSnapshot snapshot;
}

final class SmartAlertsController {
  const SmartAlertsController({required this.state});

  final SmartAlertsViewState state;

  bool supportsTab(SmartAlertTab tab) {
    return state.snapshot.tabs.any((item) => item.tab == tab);
  }
}
