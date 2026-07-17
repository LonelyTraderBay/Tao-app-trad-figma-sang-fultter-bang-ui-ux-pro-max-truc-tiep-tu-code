import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

/// What a [DcaSmartRule] governs: opening, closing, or adjusting a DCA
/// action.
enum DcaSmartRuleType { entry, exit, adjust }

/// Lifecycle status of a [DcaSmartRule].
enum DcaSmartRuleStatus { active, paused, triggered }

/// Outcome of one [DcaSmartRule] trigger, shown in [DcaRuleHistoryEntry].
enum DcaSmartRuleResult { executed, failed, pending }

/// Data for the DCA smart-rules screen: configured [smartRules], starter
/// [templates], and trigger [history] with a derived success rate.
class DcaSmartRulesSnapshot {
  const DcaSmartRulesSnapshot({
    required this.endpoint,
    required this.actionDraft,
    required this.supportedStates,
    required this.successPercent,
    required this.smartRules,
    required this.templates,
    required this.history,
    required this.dcaPlans,
    required this.schedules,
    required this.rules,
    required this.portfolioTargets,
    required this.backtests,
  });

  final String endpoint;
  final String actionDraft;
  final List<DcaScreenState> supportedStates;
  final int successPercent;
  final List<DcaSmartRule> smartRules;
  final List<DcaRuleTemplate> templates;
  final List<DcaRuleHistoryEntry> history;
  final List<String> dcaPlans;
  final List<String> schedules;
  final List<String> rules;
  final List<String> portfolioTargets;
  final List<String> backtests;

  int get activeRules {
    return smartRules
        .where((rule) => rule.status == DcaSmartRuleStatus.active)
        .length;
  }

  int get totalTriggers {
    return smartRules.fold(0, (sum, rule) => sum + rule.triggeredCount);
  }
}

/// One configured smart rule: condition, resulting action, status, and
/// trigger count.
class DcaSmartRule {
  const DcaSmartRule({
    required this.id,
    required this.name,
    required this.type,
    required this.condition,
    required this.action,
    required this.status,
    required this.triggeredCount,
    this.lastTriggeredLabel,
  });

  final String id;
  final String name;
  final DcaSmartRuleType type;
  final String condition;
  final String action;
  final DcaSmartRuleStatus status;
  final int triggeredCount;
  final String? lastTriggeredLabel;
}

/// A pre-built smart-rule template (condition/action pair) users can add
/// as-is.
class DcaRuleTemplate {
  const DcaRuleTemplate({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.condition,
    required this.action,
    required this.popularityPercent,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String condition;
  final String action;
  final int popularityPercent;
}

/// One past trigger event for a [DcaSmartRule], with its execution
/// [result].
class DcaRuleHistoryEntry {
  const DcaRuleHistoryEntry({
    required this.id,
    required this.ruleName,
    required this.triggeredAtLabel,
    required this.condition,
    required this.action,
    required this.result,
  });

  final String id;
  final String ruleName;
  final String triggeredAtLabel;
  final String condition;
  final String action;
  final DcaSmartRuleResult result;
}
