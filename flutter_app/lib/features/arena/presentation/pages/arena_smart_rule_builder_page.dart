import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/arena_controller_providers.dart';
import 'package:vit_trade_flutter/features/arena/presentation/controllers/arena_controller.dart';

part 'arena_smart_rule_builder_page_part_01.dart';
part 'arena_smart_rule_builder_page_part_02.dart';
part 'arena_smart_rule_builder_page_part_03.dart';

const _arenaAccent = AppModuleAccents.arena;

String _formatArenaRuleDateInput(String isoDate) {
  final parts = isoDate.split('-');
  if (parts.length != 3) return isoDate;
  final year = parts[0];
  final month = parts[1];
  final day = parts[2];
  if (year.length != 4 || month.length != 2 || day.length != 2) {
    return isoDate;
  }
  return '$month/$day/$year';
}

String _normalizeArenaRuleDateInput(String displayDate) {
  final parts = displayDate.split('/');
  if (parts.length != 3) return displayDate;
  final month = parts[0].padLeft(2, '0');
  final day = parts[1].padLeft(2, '0');
  final year = parts[2].padLeft(4, '0');
  return '$year-$month-$day';
}

class ArenaSmartRuleBuilderPage extends ConsumerStatefulWidget {
  const ArenaSmartRuleBuilderPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc186_smart_rule_content');
  static const titleKey = Key('sc186_title');
  static const domainKey = Key('sc186_domain');
  static const subjectKey = Key('sc186_subject');
  static const actionKey = Key('sc186_action');
  static const continueKey = Key('sc186_continue');
  static const saveKey = Key('sc186_save');
  static const guidanceKey = Key('sc186_guidance');

  static Key challengeTypeKey(String id) => Key('sc186_type_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaSmartRuleBuilderPage> createState() =>
      _ArenaSmartRuleBuilderPageState();
}

class _ArenaSmartRuleBuilderPageState
    extends ConsumerState<ArenaSmartRuleBuilderPage> {
  final _titleController = TextEditingController();
  final _customWinController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _endDateController = TextEditingController();

  String _title = '';
  String _domainId = '';
  String _challengeTypeId = '';
  String _subject = '';
  String _action = '';
  String _metric = '';
  String _winType = '';
  String _deadlineContext = '';
  String _customWinCondition = '';
  String _description = '';
  late String _endDate;
  String _tieRule = '';
  String _voidRule = '';
  String _resultDeadline = '';
  bool _rematchEnabled = false;
  bool _saveAsMode = false;
  String? _statusLabel;

  @override
  void initState() {
    super.initState();
    _endDate = '2026-03-15';
    _endDateController.text = _formatArenaRuleDateInput(_endDate);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _customWinController.dispose();
    _descriptionController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(arenaReadModelControllerProvider)
        .getArenaSmartRules();
    _endDate = _endDate.isEmpty ? snapshot.defaultEndDate : _endDate;
    if (_endDateController.text.isEmpty && _endDate.isNotEmpty) {
      _endDateController.text = _formatArenaRuleDateInput(_endDate);
    }
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        AppSpacing.x7 +
        MediaQuery.paddingOf(context).bottom;
    final clarity = _computeClarity();
    final canProceed = _canProceed;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-186 ArenaSmartRuleBuilderPage',
      child: Material(
        color: AppColors.bg,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Arena Studio',
            subtitle: 'Smart Rule Builder',
            showBack: true,
            onBack: _close,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: ArenaSmartRuleBuilderPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: AppSpacing.arenaBottomScrollPadding(bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    customGap: AppSpacing.x5,
                    children: [
                      _SmartStepper(steps: snapshot.steps, step: 3),
                      _IntroSection(),
                      _ClarityScoreCard(score: clarity.score),
                      _GuidanceLink(onTap: _showGuidance),
                      _TitleField(
                        controller: _titleController,
                        suggestions: snapshot.titleSuggestions,
                        onChanged: (value) => setState(() => _title = value),
                        onSuggestion: _setTitle,
                      ),
                      _DomainField(
                        domain: _selectedDomain(snapshot),
                        onTap: () => _selectDomain(snapshot, 'crypto'),
                      ),
                      _ChallengeTypeGrid(
                        types: snapshot.challengeTypes,
                        selectedId: _challengeTypeId,
                        onSelected: (id) =>
                            setState(() => _challengeTypeId = id),
                      ),
                      _ConditionBuilder(
                        subject: _subject,
                        action: _action,
                        metric: _metric,
                        winType: _winType,
                        deadlineContext: _deadlineContext,
                        customWinController: _customWinController,
                        onSubject: () =>
                            setState(() => _subject = snapshot.subjects.first),
                        onAction: () =>
                            setState(() => _action = snapshot.actions.first),
                        onMetric: () =>
                            setState(() => _metric = snapshot.metrics.first),
                        onWinType: () =>
                            setState(() => _winType = snapshot.winTypes.first),
                        onDeadlineContext: () => setState(
                          () => _deadlineContext =
                              snapshot.deadlineContexts.first,
                        ),
                        onCustomWinChanged: (value) =>
                            setState(() => _customWinCondition = value),
                      ),
                      _DescriptionField(
                        controller: _descriptionController,
                        onChanged: (value) =>
                            setState(() => _description = value),
                      ),
                      _QuickSuggestions(
                        suggestions: _quickSuggestions(snapshot),
                        onTap: (value) => setState(() {
                          if (_title.isEmpty) {
                            _setTitle(value);
                          } else {
                            _setCustomWinCondition(value);
                          }
                        }),
                      ),
                      _TimingRulesCard(
                        snapshot: snapshot,
                        endDateController: _endDateController,
                        tieRule: _tieRule,
                        voidRule: _voidRule,
                        resultDeadline: _resultDeadline,
                        rematchEnabled: _rematchEnabled,
                        saveAsMode: _saveAsMode,
                        onDate: (value) => setState(() => _endDate = value),
                        onTieRule: () =>
                            setState(() => _tieRule = snapshot.tieRules.first),
                        onVoidRule: () => setState(
                          () => _voidRule = snapshot.voidRules.first,
                        ),
                        onResultDeadline: () => setState(
                          () =>
                              _resultDeadline = snapshot.resultDeadlines.first,
                        ),
                        onRematch: () =>
                            setState(() => _rematchEnabled = !_rematchEnabled),
                        onSaveAsMode: () =>
                            setState(() => _saveAsMode = !_saveAsMode),
                      ),
                      _RuleSummaryCard(
                        domain: _selectedDomain(snapshot)?.label,
                        challengeType: _selectedChallengeType(snapshot)?.label,
                        winCondition: _generatedWinCondition,
                        endDate: _endDate,
                        tieRule: _tieRule,
                        voidRule: _voidRule,
                        resultDeadline: _resultDeadline,
                      ),
                      const _ModerationNote(),
                      _FooterActions(
                        canProceed: canProceed,
                        clarityScore: clarity.score,
                        statusLabel: _statusLabel,
                        onBack: _close,
                        onContinue: _continue,
                        onSave: _saveDraft,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool get _canProceed {
    final hasStructuredRule = _subject.isNotEmpty && _action.isNotEmpty;
    final hasCustomRule = _customWinCondition.trim().length >= 5;
    return _title.trim().length >= 3 &&
        _domainId.isNotEmpty &&
        _challengeTypeId.isNotEmpty &&
        (hasStructuredRule || hasCustomRule);
  }

  String get _generatedWinCondition {
    final parts = <String>[
      if (_subject.isNotEmpty) _subject,
      if (_action.isNotEmpty) _action,
      if (_metric.isNotEmpty) _metric,
      if (_deadlineContext.isNotEmpty) _deadlineContext,
      if (_winType.isNotEmpty) _winType,
    ];
    if (parts.isNotEmpty) return '${parts.join(' ')}.';
    if (_customWinCondition.trim().isNotEmpty) return _customWinCondition;
    return '-';
  }

  ArenaSmartOptionDraft? _selectedDomain(ArenaSmartRulesSnapshot snapshot) {
    if (_domainId.isEmpty) return null;
    for (final domain in snapshot.domains) {
      if (domain.id == _domainId) return domain;
    }
    return null;
  }

  ArenaSmartOptionDraft? _selectedChallengeType(
    ArenaSmartRulesSnapshot snapshot,
  ) {
    if (_challengeTypeId.isEmpty) return null;
    for (final type in snapshot.challengeTypes) {
      if (type.id == _challengeTypeId) return type;
    }
    return null;
  }

  List<String> _quickSuggestions(ArenaSmartRulesSnapshot snapshot) {
    if (_domainId == 'crypto') {
      return [
        'Giá gần đúng nhất?',
        'Vượt mốc giá?',
        'Token nào tăng mạnh nhất?',
      ];
    }
    return snapshot.titleSuggestions;
  }

  _ClarityResult _computeClarity() {
    var score = 0;
    if (_title.length >= 5) {
      score += 10;
    } else if (_title.length >= 3) {
      score += 5;
    }
    if (_domainId.isNotEmpty) score += 10;
    if (_challengeTypeId.isNotEmpty) score += 10;
    if (_subject.isNotEmpty) score += 8;
    if (_action.isNotEmpty) score += 8;
    if (_metric.isNotEmpty) score += 6;
    if (_winType.isNotEmpty) score += 5;
    if (_deadlineContext.isNotEmpty) score += 5;
    if (_customWinCondition.length >= 10) {
      score += 15;
    } else if (_customWinCondition.length >= 5) {
      score += 8;
    }
    if (_description.length >= 20) {
      score += 8;
    } else if (_description.length >= 5) {
      score += 4;
    }
    if (_tieRule.isNotEmpty) score += 8;
    if (_voidRule.isNotEmpty) score += 8;
    if (_resultDeadline.isNotEmpty) score += 8;
    if (_endDate.isNotEmpty) score += 5;
    return _ClarityResult(score.clamp(0, 100));
  }

  void _selectDomain(ArenaSmartRulesSnapshot snapshot, String id) {
    if (snapshot.domains.any((domain) => domain.id == id)) {
      HapticFeedback.selectionClick();
      setState(() => _domainId = id);
    }
  }

  void _setTitle(String value) {
    _titleController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _title = value);
  }

  void _setCustomWinCondition(String value) {
    _customWinController.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _customWinCondition = value);
  }

  void _showGuidance() {
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = 'Public room cần rule rõ ràng hơn');
  }

  void _continue() {
    if (!_canProceed) return;
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = 'Rule đã hoàn chỉnh');
  }

  void _saveDraft() {
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = 'Đã lưu nháp');
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaStudio);
  }
}
