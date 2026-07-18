import 'package:vit_trade_flutter/features/trade_bots/domain/entities/trade_bots_entities.dart';

/// Data contract for the bot lifecycle: terms/risk/suitability onboarding,
/// running-bot management, risk dashboard, emergency stop, and security
/// settings.
///
/// GD4-F3: every READ method is `Future<T>` (ADR-001's read idiom — see
/// docs/02_FLUTTER_MIGRATION/a-plus-roadmap/GD4-Async-Playbook.md). Mock
/// implementations simulate network latency via `loadDelay`; production
/// implementations will be real network calls with the same signature.
/// Write/mutation methods (submit/patch/create) stay synchronous — the
/// full write-path error idiom (ADR-001 §"đường ghi tài chính") is a
/// separate, later migration (ADR-001's "hệ quả / nợ còn lại": "các đường
/// ghi phụ ... vẫn đồng bộ — migrate dần khi chạm tới"), and
/// [TradeBotsController]'s optimistic local mutations depend on these
/// resolving synchronously (see
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
