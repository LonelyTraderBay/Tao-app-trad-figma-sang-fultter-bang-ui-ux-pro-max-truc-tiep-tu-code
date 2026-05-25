import 'package:flutter_riverpod/flutter_riverpod.dart';

final smartAlertsRepositoryProvider = Provider<SmartAlertsRepository>((ref) {
  return const MockSmartAlertsRepository();
});

abstract interface class SmartAlertsRepository {
  SmartAlertsSnapshot getCenter();
}

enum SmartAlertsScreenState { loading, empty, error, offline }

enum SmartAlertTab { active, history, settings }

enum SmartAlertModuleId { trading, p2p, predictions, arena, dca, wallet }

enum SmartAlertStatus { active, paused, triggered }

final class SmartAlertsSnapshot {
  const SmartAlertsSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.title,
    required this.backRoute,
    required this.tabs,
    required this.alerts,
    required this.history,
    required this.channels,
    required this.templates,
    required this.contractNotes,
    required this.supportedStates,
  });

  final String endpoint;
  final String actionDraft;
  final String title;
  final String backRoute;
  final List<SmartAlertTabDraft> tabs;
  final List<SmartAlertDraft> alerts;
  final List<SmartAlertHistoryDraft> history;
  final List<SmartAlertChannelDraft> channels;
  final List<SmartAlertTemplateDraft> templates;
  final String contractNotes;
  final Set<SmartAlertsScreenState> supportedStates;

  int get activeCount =>
      alerts.where((alert) => alert.status == SmartAlertStatus.active).length;

  int get totalTriggers =>
      alerts.fold(0, (sum, alert) => sum + alert.triggerCount);

  int get moduleCount => alerts.map((alert) => alert.module).toSet().length;
}

final class SmartAlertTabDraft {
  const SmartAlertTabDraft({required this.tab, required this.label});

  final SmartAlertTab tab;
  final String label;
}

final class SmartAlertDraft {
  const SmartAlertDraft({
    required this.id,
    required this.module,
    required this.moduleName,
    required this.type,
    required this.condition,
    required this.action,
    required this.status,
    required this.triggerCount,
    this.lastTriggeredLabel,
  });

  final String id;
  final SmartAlertModuleId module;
  final String moduleName;
  final String type;
  final String condition;
  final String action;
  final SmartAlertStatus status;
  final int triggerCount;
  final String? lastTriggeredLabel;
}

final class SmartAlertHistoryDraft {
  const SmartAlertHistoryDraft({
    required this.id,
    required this.alertName,
    required this.moduleName,
    required this.triggeredAtLabel,
    required this.action,
  });

  final String id;
  final String alertName;
  final String moduleName;
  final String triggeredAtLabel;
  final String action;
}

final class SmartAlertChannelDraft {
  const SmartAlertChannelDraft({
    required this.id,
    required this.label,
    required this.description,
    required this.enabled,
  });

  final String id;
  final String label;
  final String description;
  final bool enabled;
}

final class SmartAlertTemplateDraft {
  const SmartAlertTemplateDraft({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.popularity,
  });

  final String id;
  final String category;
  final String name;
  final String description;
  final int popularity;
}

final class MockSmartAlertsRepository implements SmartAlertsRepository {
  const MockSmartAlertsRepository();

  @override
  SmartAlertsSnapshot getCenter() {
    return const SmartAlertsSnapshot(
      endpoint: '/api/mobile/cross-module/smart-alerts',
      actionDraft: 'read-only or local navigation action',
      title: 'Smart Alerts',
      backRoute: '/home',
      tabs: [
        SmartAlertTabDraft(tab: SmartAlertTab.active, label: 'Hoat dong'),
        SmartAlertTabDraft(tab: SmartAlertTab.history, label: 'Lich su'),
        SmartAlertTabDraft(tab: SmartAlertTab.settings, label: 'Cai dat'),
      ],
      alerts: [
        SmartAlertDraft(
          id: 'a1',
          module: SmartAlertModuleId.trading,
          moduleName: 'Trading',
          type: 'Price Alert',
          condition: 'BTC > \$70,000',
          action: 'Push notification + Email',
          status: SmartAlertStatus.active,
          triggerCount: 0,
        ),
        SmartAlertDraft(
          id: 'a2',
          module: SmartAlertModuleId.p2p,
          moduleName: 'P2P',
          type: 'Order Status',
          condition: 'Order expires in 5 min',
          action: 'Push notification',
          status: SmartAlertStatus.active,
          triggerCount: 4,
          lastTriggeredLabel: '15 thg 5',
        ),
        SmartAlertDraft(
          id: 'a3',
          module: SmartAlertModuleId.predictions,
          moduleName: 'Predictions',
          type: 'Event Resolution',
          condition: 'Any prediction resolves',
          action: 'Push notification',
          status: SmartAlertStatus.active,
          triggerCount: 7,
          lastTriggeredLabel: '17 thg 5',
        ),
        SmartAlertDraft(
          id: 'a4',
          module: SmartAlertModuleId.arena,
          moduleName: 'Arena',
          type: 'Challenge Deadline',
          condition: 'My challenges end in 24h',
          action: 'Push notification',
          status: SmartAlertStatus.active,
          triggerCount: 3,
          lastTriggeredLabel: '16 thg 5',
        ),
        SmartAlertDraft(
          id: 'a5',
          module: SmartAlertModuleId.dca,
          moduleName: 'DCA',
          type: 'Execution Alert',
          condition: 'DCA plan executed',
          action: 'Push notification + Email',
          status: SmartAlertStatus.active,
          triggerCount: 12,
          lastTriggeredLabel: '11 thg 5',
        ),
        SmartAlertDraft(
          id: 'a6',
          module: SmartAlertModuleId.wallet,
          moduleName: 'Wallet',
          type: 'Large Transaction',
          condition: 'Transaction > \$10,000',
          action: 'Push notification + SMS',
          status: SmartAlertStatus.active,
          triggerCount: 8,
          lastTriggeredLabel: '13 thg 5',
        ),
        SmartAlertDraft(
          id: 'a7',
          module: SmartAlertModuleId.trading,
          moduleName: 'Trading',
          type: 'Portfolio Alert',
          condition: 'Portfolio down 5%',
          action: 'Push notification',
          status: SmartAlertStatus.paused,
          triggerCount: 2,
        ),
      ],
      history: [
        SmartAlertHistoryDraft(
          id: 'h1',
          alertName: 'BTC > \$70,000',
          moduleName: 'Trading',
          triggeredAtLabel: '12 gio truoc',
          action: 'Push notification sent',
        ),
        SmartAlertHistoryDraft(
          id: 'h2',
          alertName: 'Order expires in 5 min',
          moduleName: 'P2P',
          triggeredAtLabel: '15 thg 5, 23:38',
          action: 'Push notification sent',
        ),
        SmartAlertHistoryDraft(
          id: 'h3',
          alertName: 'Prediction resolves',
          moduleName: 'Predictions',
          triggeredAtLabel: '17 thg 5, 23:38',
          action: 'Push notification sent',
        ),
      ],
      channels: [
        SmartAlertChannelDraft(
          id: 'push',
          label: 'Push Notifications',
          description: 'Enabled',
          enabled: true,
        ),
        SmartAlertChannelDraft(
          id: 'email',
          label: 'Email Alerts',
          description: 'Enabled',
          enabled: true,
        ),
        SmartAlertChannelDraft(
          id: 'sms',
          label: 'SMS Alerts',
          description: 'Disabled',
          enabled: false,
        ),
      ],
      templates: [
        SmartAlertTemplateDraft(
          id: 't1',
          category: 'Trading',
          name: 'Price Breakout',
          description: 'Alert when price breaks resistance/support',
          popularity: 92,
        ),
        SmartAlertTemplateDraft(
          id: 't2',
          category: 'Trading',
          name: 'Volume Spike',
          description: 'Alert on abnormal trading volume',
          popularity: 78,
        ),
        SmartAlertTemplateDraft(
          id: 't3',
          category: 'P2P',
          name: 'Order Matching',
          description: 'Alert when your ad gets matched',
          popularity: 85,
        ),
        SmartAlertTemplateDraft(
          id: 't4',
          category: 'Predictions',
          name: 'Event Updates',
          description: 'Alert on event probability changes',
          popularity: 72,
        ),
        SmartAlertTemplateDraft(
          id: 't5',
          category: 'Arena',
          name: 'Challenge Invites',
          description: 'Alert when invited to challenges',
          popularity: 68,
        ),
        SmartAlertTemplateDraft(
          id: 't6',
          category: 'DCA',
          name: 'Execution Confirmation',
          description: 'Alert after each DCA purchase',
          popularity: 88,
        ),
        SmartAlertTemplateDraft(
          id: 't7',
          category: 'Wallet',
          name: 'Deposit Confirmed',
          description: 'Alert when deposit is confirmed',
          popularity: 95,
        ),
      ],
      contractNotes:
          'Smart alerts are cross-module notification rules only. Open Arena alerts stay points-only and must not expose wallet, PnL, payout, or stake return copy.',
      supportedStates: {
        SmartAlertsScreenState.loading,
        SmartAlertsScreenState.empty,
        SmartAlertsScreenState.error,
        SmartAlertsScreenState.offline,
      },
    );
  }
}
