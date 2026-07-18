import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

/// Data contract for the bot lifecycle: terms/risk/suitability onboarding,
/// running-bot management, risk dashboard, emergency stop, and security
/// settings.
///
/// GD4-F6: mọi method — kể cả method GHI (submit/patch/create) — giờ đều
/// là `Future<T>` (ADR-001's read idiom mở rộng sang đường ghi phụ, xem
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md bẫy 19).
/// Mock implementations simulate network latency via `loadDelay`;
/// production implementations will be real network calls with the same
/// signature. [TradeBotsController]'s optimistic local mutations now
/// `await` these calls (see
/// `presentation/controllers/trade_bots_controller_models.dart` /
/// `app/providers/trade_bots_controller_providers.dart`).
abstract interface class TradingBotsRepository {
  Future<TradeBotsSnapshot> getTradingBots();
  Future<TradeBotTermsSnapshot> getBotTermsOfService();
  Future<TradeBotRiskDisclosureSnapshot> getBotRiskDisclosure();
  Future<TradeBotSuitabilityAssessmentSnapshot> getBotSuitabilityAssessment();
  Future<TradeBotRiskDashboardSnapshot> getBotRiskDashboard();
  Future<TradeBotEmergencyStopSnapshot> getBotEmergencyStop();
  Future<TradeBotSecuritySettingsSnapshot> getBotSecuritySettings();
  Future<TradeBotHistorySnapshot> getBotHistory();
  Future<TradeBotPerformanceAnalyticsSnapshot> getBotPerformanceAnalytics();
  Future<TradeBotActionResult> submitBotAction(TradeBotActionRequest request);
  Future<TradeBotEmergencyStopResult> submitBotEmergencyStop(
    TradeBotEmergencyStopDraft draft,
  );
  Future<TradeBotSecuritySettingsResult> patchBotSecuritySettings(
    TradeBotSecuritySettingsDraft draft,
  );
  Future<TradeBotHistoryExportResult> createBotHistoryExport(
    TradeBotHistoryExportRequest request,
  );
  Future<TradeBotCreateResult> createTradingBot(TradeBotCreateRequest request);
}
