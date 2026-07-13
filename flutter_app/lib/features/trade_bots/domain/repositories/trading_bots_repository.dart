import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

abstract interface class TradingBotsRepository {
  TradeBotsSnapshot getTradingBots();
  TradeBotTermsSnapshot getBotTermsOfService();
  TradeBotRiskDisclosureSnapshot getBotRiskDisclosure();
  TradeBotSuitabilityAssessmentSnapshot getBotSuitabilityAssessment();
  TradeBotRiskDashboardSnapshot getBotRiskDashboard();
  TradeBotEmergencyStopSnapshot getBotEmergencyStop();
  TradeBotSecuritySettingsSnapshot getBotSecuritySettings();
  TradeBotHistorySnapshot getBotHistory();
  TradeBotPerformanceAnalyticsSnapshot getBotPerformanceAnalytics();
  TradeBotActionResult submitBotAction(TradeBotActionRequest request);
  TradeBotEmergencyStopResult submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  );
  TradeBotSecuritySettingsResult patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  );
  TradeBotHistoryExportResult createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  );
  TradeBotCreateResult createTradingBot(TradeBotCreateRequest request);
}
