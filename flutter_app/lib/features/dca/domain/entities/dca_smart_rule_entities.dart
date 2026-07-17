import 'package:vit_trade_flutter/features/dca/domain/entities/dca_common_entities.dart';

enum DcaSmartRuleType { entry, exit, adjust }

enum DcaSmartRuleStatus { active, paused, triggered }

enum DcaSmartRuleResult { executed, failed, pending }

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
