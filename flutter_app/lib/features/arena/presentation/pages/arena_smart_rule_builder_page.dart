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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaSmartRules();
    _endDate = _endDate.isEmpty ? snapshot.defaultEndDate : _endDate;
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
        child: Column(
          children: [
            VitHeader(
              title: 'Arena Studio',
              subtitle: 'Smart Rule Builder',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ArenaSmartRuleBuilderPage.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  customGap: AppSpacing.x5,
                  children: [
                    _SmartStepper(steps: snapshot.steps, step: 3),
                    _IntroSection(),
                    _ClarityScoreCard(score: clarity.score),
                    _GuidanceLink(onTap: _showGuidance),
                    _TitleField(
                      title: _title,
                      suggestions: snapshot.titleSuggestions,
                      onChanged: (value) => setState(() => _title = value),
                    ),
                    _DomainField(
                      domain: _selectedDomain(snapshot),
                      onTap: () => _selectDomain(snapshot, 'crypto'),
                    ),
                    _ChallengeTypeGrid(
                      types: snapshot.challengeTypes,
                      selectedId: _challengeTypeId,
                      onSelected: (id) => setState(() => _challengeTypeId = id),
                    ),
                    _ConditionBuilder(
                      subject: _subject,
                      action: _action,
                      metric: _metric,
                      winType: _winType,
                      deadlineContext: _deadlineContext,
                      customWinCondition: _customWinCondition,
                      onSubject: () =>
                          setState(() => _subject = snapshot.subjects.first),
                      onAction: () =>
                          setState(() => _action = snapshot.actions.first),
                      onMetric: () =>
                          setState(() => _metric = snapshot.metrics.first),
                      onWinType: () =>
                          setState(() => _winType = snapshot.winTypes.first),
                      onDeadlineContext: () => setState(
                        () =>
                            _deadlineContext = snapshot.deadlineContexts.first,
                      ),
                      onCustomWinChanged: (value) =>
                          setState(() => _customWinCondition = value),
                    ),
                    _DescriptionField(
                      value: _description,
                      onChanged: (value) =>
                          setState(() => _description = value),
                    ),
                    _QuickSuggestions(
                      suggestions: _quickSuggestions(snapshot),
                      onTap: (value) => setState(() {
                        if (_title.isEmpty) {
                          _title = value;
                        } else {
                          _customWinCondition = value;
                        }
                      }),
                    ),
                    _TimingRulesCard(
                      snapshot: snapshot,
                      endDate: _endDate,
                      tieRule: _tieRule,
                      voidRule: _voidRule,
                      resultDeadline: _resultDeadline,
                      rematchEnabled: _rematchEnabled,
                      saveAsMode: _saveAsMode,
                      onDate: (value) => setState(() => _endDate = value),
                      onTieRule: () =>
                          setState(() => _tieRule = snapshot.tieRules.first),
                      onVoidRule: () =>
                          setState(() => _voidRule = snapshot.voidRules.first),
                      onResultDeadline: () => setState(
                        () => _resultDeadline = snapshot.resultDeadlines.first,
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

class _ClarityResult {
  const _ClarityResult(this.score);

  final int score;

  String get label {
    if (score >= 85) return 'Public-ready';
    if (score >= 60) return 'Cao';
    if (score >= 35) return 'Trung bình';
    return 'Thấp';
  }

  Color get color {
    if (score >= 85) return AppColors.accent;
    if (score >= 60) return AppColors.buy;
    if (score >= 35) return AppColors.warn;
    return AppColors.sell;
  }

  Color get softColor {
    if (score >= 85) return AppColors.accent12;
    if (score >= 60) return AppColors.buy15;
    if (score >= 35) return AppColors.warn15;
    return AppColors.sell15;
  }
}

class _SmartStepper extends StatelessWidget {
  const _SmartStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _SmartStepMarker(item: steps[i], activeStep: step),
          ),
          if (i != steps.length - 1)
            Container(
              width: AppSpacing.x5,
              height: 2,
              margin: const EdgeInsets.only(bottom: AppSpacing.x5),
              decoration: BoxDecoration(
                color: steps[i].index < step
                    ? AppColors.buy
                    : AppColors.surface3,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
        ],
      ],
    );
  }
}

class _SmartStepMarker extends StatelessWidget {
  const _SmartStepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final done = item.index < activeStep;
    final active = item.index == activeStep;
    final color = done
        ? AppColors.buy
        : active
        ? AppColors.accent
        : AppColors.surface2;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: active ? AppColors.accent20 : AppColors.borderSolid,
            ),
          ),
          alignment: Alignment.center,
          child: done
              ? const Icon(
                  Icons.check_rounded,
                  color: AppColors.navCenterIcon,
                  size: 14,
                )
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: active ? AppColors.navCenterIcon : AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          item.label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _IntroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Smart Builder',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Chọn rule có cấu trúc để room dễ hiểu và dễ được tin tưởng hơn',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _ClarityScoreCard extends StatelessWidget {
  const _ClarityScoreCard({required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final result = _ClarityResult(score);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: result.color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Rule Clarity Score',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$score',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: result.color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: result.label,
                status: score >= 35
                    ? VitStatusPillStatus.orange
                    : VitStatusPillStatus.error,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              color: result.color,
              backgroundColor: AppColors.surface3,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            score >= 35
                ? 'Rule đã ổn, thêm edge rules sẽ rõ ràng hơn'
                : 'Cần bổ sung thêm thông tin để room dễ hiểu',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Chọn rule có cấu trúc để room dễ hiểu và dễ được tin tưởng hơn',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _GuidanceLink extends StatelessWidget {
  const _GuidanceLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaSmartRuleBuilderPage.guidanceKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Icons.help_outline_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Public vs Private — Room cần rule gì?',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
            size: 16,
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.title,
    required this.suggestions,
    required this.onChanged,
  });

  final String title;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Tên challenge',
      required: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            key: ArenaSmartRuleBuilderPage.titleKey,
            onChanged: onChanged,
            style: AppTextStyles.base.copyWith(color: AppColors.text1),
            decoration: _inputDecoration('VD: BTC Weekly Predict — Tuần 10'),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x5,
            runSpacing: AppSpacing.x3,
            children: [
              for (final suggestion in suggestions)
                GestureDetector(
                  onTap: () => onChanged(suggestion),
                  child: Text(
                    '"$suggestion"',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DomainField extends StatelessWidget {
  const _DomainField({required this.domain, required this.onTap});

  final ArenaSmartOptionDraft? domain;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Lĩnh vực',
      required: true,
      child: VitCard(
        key: ArenaSmartRuleBuilderPage.domainKey,
        variant: VitCardVariant.inner,
        borderColor: domain == null
            ? AppColors.borderSolid
            : AppColors.accent20,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x4,
          vertical: AppSpacing.x4,
        ),
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Text(
                domain?.label ?? 'Chọn lĩnh vực...',
                style: AppTextStyles.base.copyWith(
                  color: domain == null ? AppColors.text3 : AppColors.text1,
                  fontWeight: domain == null
                      ? AppTextStyles.normal
                      : AppTextStyles.bold,
                ),
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.text3,
            ),
          ],
        ),
      ),
    );
  }
}

class _ChallengeTypeGrid extends StatelessWidget {
  const _ChallengeTypeGrid({
    required this.types,
    required this.selectedId,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> types;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Loại challenge',
      required: true,
      child: Wrap(
        runSpacing: AppSpacing.x3,
        children: [
          for (final type in types)
            SizedBox(
              width: 200,
              child: _ChallengeTypeTile(
                key: ArenaSmartRuleBuilderPage.challengeTypeKey(type.id),
                type: type,
                selected: selectedId == type.id,
                onTap: () => onSelected(type.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTypeTile extends StatelessWidget {
  const _ChallengeTypeTile({
    super.key,
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final ArenaSmartOptionDraft type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
        child: Row(
          children: [
            Icon(
              _challengeTypeIcon(type.id),
              color: selected ? AppColors.buy : _challengeTypeColor(type.id),
              size: 15,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: selected ? AppColors.buy : AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    type.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _challengeTypeIcon(String id) {
    return switch (id) {
      'yes_no' => Icons.check_box_rounded,
      'multi_choice' => Icons.fact_check_outlined,
      'closest_guess' => Icons.track_changes_rounded,
      'highest_wins' => Icons.bar_chart_rounded,
      'lowest_wins' => Icons.show_chart_rounded,
      'first_to_finish' => Icons.flag_outlined,
      'team_score' => Icons.groups_2_outlined,
      'referee_decision' => Icons.gavel_outlined,
      'community_vote' => Icons.how_to_vote_outlined,
      _ => Icons.photo_camera_outlined,
    };
  }

  Color _challengeTypeColor(String id) {
    return switch (id) {
      'yes_no' => AppColors.buy,
      'multi_choice' => AppColors.primary,
      'closest_guess' => AppColors.accent,
      'highest_wins' => AppColors.buy,
      'lowest_wins' => AppColors.sell,
      'first_to_finish' => AppColors.text2,
      'team_score' => AppColors.accent,
      'referee_decision' => AppColors.primarySoft,
      'community_vote' => AppColors.text2,
      _ => AppColors.primarySoft,
    };
  }
}

class _ConditionBuilder extends StatelessWidget {
  const _ConditionBuilder({
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinCondition,
    required this.onSubject,
    required this.onAction,
    required this.onMetric,
    required this.onWinType,
    required this.onDeadlineContext,
    required this.onCustomWinChanged,
  });

  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final String customWinCondition;
  final VoidCallback onSubject;
  final VoidCallback onAction;
  final VoidCallback onMetric;
  final VoidCallback onWinType;
  final VoidCallback onDeadlineContext;
  final ValueChanged<String> onCustomWinChanged;

  @override
  Widget build(BuildContext context) {
    final preview = [
      if (subject.isNotEmpty) subject,
      if (action.isNotEmpty) action,
      if (metric.isNotEmpty) metric,
      if (deadlineContext.isNotEmpty) deadlineContext,
      if (winType.isNotEmpty) winType,
    ].join(' ');

    return _FieldBlock(
      label: 'Điều kiện thắng',
      required: true,
      hint: 'Chọn hoặc tự nhập',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitCard(
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.track_changes_rounded,
                      color: AppColors.accent,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Text(
                        'Builder điều kiện thắng',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x4),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
                  children: [
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.subjectKey,
                      label: 'A. Chủ thể',
                      value: subject,
                      onTap: onSubject,
                    ),
                    _BuilderBox(
                      key: ArenaSmartRuleBuilderPage.actionKey,
                      label: 'B. Hành động',
                      value: action,
                      onTap: onAction,
                    ),
                    _BuilderBox(
                      label: 'C. Chỉ số / đối tượng',
                      value: metric,
                      onTap: onMetric,
                    ),
                    _BuilderBox(
                      label: 'D. Kiểu thắng',
                      value: winType,
                      onTap: onWinType,
                    ),
                    _BuilderBox(
                      wide: true,
                      label: 'E. Thời điểm / hạn kết quả',
                      value: deadlineContext,
                      onTap: onDeadlineContext,
                    ),
                  ],
                ),
                if (preview.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.x3),
                  VitCard(
                    variant: VitCardVariant.inner,
                    borderColor: AppColors.accent20,
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Text(
                      '"$preview."',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Hoặc tự nhập điều kiện thắng:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x2),
          TextField(
            minLines: 2,
            maxLines: 3,
            onChanged: onCustomWinChanged,
            style: AppTextStyles.base.copyWith(color: AppColors.text1),
            decoration: _inputDecoration(
              'VD: Người đoán gần nhất với giá ETH vào 25/03/2026 lúc 10:00 sẽ thắng.',
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderBox extends StatelessWidget {
  const _BuilderBox({
    super.key,
    required this.label,
    required this.value,
    required this.onTap,
    this.wide = false,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: wide ? double.infinity : 181,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: value.isEmpty
                ? AppColors.borderSolid
                : AppColors.accent20,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x3,
              vertical: AppSpacing.x3,
            ),
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value.isEmpty ? 'Chọn...' : value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: value.isEmpty ? AppColors.text3 : AppColors.text1,
                      fontWeight: value.isEmpty
                          ? AppTextStyles.normal
                          : AppTextStyles.bold,
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.text3,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DescriptionField extends StatelessWidget {
  const _DescriptionField({required this.value, required this.onChanged});

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Mô tả ngắn',
      hint: 'Tùy chọn',
      child: TextField(
        minLines: 2,
        maxLines: 3,
        onChanged: onChanged,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration(
          'Mô tả bối cảnh nếu cần. Không cần lặp lại luật chơi.',
        ),
      ),
    );
  }
}

class _QuickSuggestions extends StatelessWidget {
  const _QuickSuggestions({required this.suggestions, required this.onTap});

  final List<String> suggestions;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.lightbulb_outline_rounded,
              color: _arenaAccent,
              size: 14,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Gợi ý nhanh',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Wrap(
          spacing: AppSpacing.x3,
          runSpacing: AppSpacing.x3,
          children: [
            for (final suggestion in suggestions)
              VitStatusPill(
                label: suggestion,
                status: VitStatusPillStatus.neutral,
                icon: Icons.auto_awesome_outlined,
                size: VitStatusPillSize.sm,
                onTap: () => onTap(suggestion),
              ),
          ],
        ),
      ],
    );
  }
}

class _TimingRulesCard extends StatelessWidget {
  const _TimingRulesCard({
    required this.snapshot,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
    required this.rematchEnabled,
    required this.saveAsMode,
    required this.onDate,
    required this.onTieRule,
    required this.onVoidRule,
    required this.onResultDeadline,
    required this.onRematch,
    required this.onSaveAsMode,
  });

  final ArenaSmartRulesSnapshot snapshot;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final ValueChanged<String> onDate;
  final VoidCallback onTieRule;
  final VoidCallback onVoidRule;
  final VoidCallback onResultDeadline;
  final VoidCallback onRematch;
  final VoidCallback onSaveAsMode;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule_outlined,
                color: AppColors.buy,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Timing & Edge Rules',
                style: AppTextStyles.base.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _FieldBlock(
            label: 'Thời hạn kết thúc',
            required: true,
            child: TextFormField(
              onChanged: (value) => onDate(_normalizeArenaRuleDateInput(value)),
              initialValue: _formatArenaRuleDateInput(endDate),
              style: AppTextStyles.base.copyWith(color: AppColors.text1),
              decoration: _inputDecoration('03/15/2026').copyWith(
                suffixIcon: const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.text3,
                  size: 16,
                ),
              ),
            ),
          ),
          _EdgeRuleField(
            label: 'Luật hòa (Tie rule)',
            value: tieRule,
            onTap: onTieRule,
          ),
          _EdgeRuleField(
            label: 'Luật hủy bỏ (Void rule)',
            value: voidRule,
            onTap: onVoidRule,
          ),
          _EdgeRuleField(
            label: 'Hạn chốt kết quả (Result deadline)',
            value: resultDeadline,
            onTap: onResultDeadline,
          ),
          const SizedBox(height: AppSpacing.x2),
          _SwitchRow(
            label: 'Cho phép rematch',
            description: 'Người chơi có thể yêu cầu chơi lại',
            value: rematchEnabled,
            onTap: onRematch,
          ),
          _SwitchRow(
            label: 'Lưu thành reusable mode',
            description: 'Người khác có thể clone luật chơi này',
            value: saveAsMode,
            onTap: onSaveAsMode,
          ),
        ],
      ),
    );
  }
}

class _EdgeRuleField extends StatelessWidget {
  const _EdgeRuleField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x4),
      child: _FieldBlock(
        label: label,
        hint: 'Nên có',
        child: VitCard(
          variant: VitCardVariant.inner,
          borderColor: value.isEmpty ? AppColors.borderSolid : AppColors.buy20,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x4,
          ),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value.isEmpty ? 'Chọn ${label.toLowerCase()}...' : value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: value.isEmpty ? AppColors.text3 : AppColors.text1,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.label,
    required this.description,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String description;
  final bool value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              activeThumbColor: _arenaAccent,
              activeTrackColor: AppColors.warn15,
              inactiveThumbColor: AppColors.text1,
              inactiveTrackColor: AppColors.surface3,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleSummaryCard extends StatelessWidget {
  const _RuleSummaryCard({
    required this.domain,
    required this.challengeType,
    required this.winCondition,
    required this.endDate,
    required this.tieRule,
    required this.voidRule,
    required this.resultDeadline,
  });

  final String? domain;
  final String? challengeType;
  final String winCondition;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.summarize_outlined,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Tóm tắt luật chơi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const VitStatusPill(
                label: 'Tự sinh',
                status: VitStatusPillStatus.purple,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryRow(label: 'Lĩnh vực', value: domain ?? '-'),
          _SummaryRow(label: 'Loại challenge', value: challengeType ?? '-'),
          _SummaryRow(label: 'Điều kiện thắng', value: winCondition),
          _SummaryRow(label: 'Kết thúc', value: endDate),
          _SummaryRow(
            label: 'Luật hòa',
            value: tieRule.isEmpty ? '-' : tieRule,
          ),
          _SummaryRow(
            label: 'Luật hủy bỏ',
            value: voidRule.isEmpty ? '-' : voidRule,
          ),
          _SummaryRow(
            label: 'Hạn chốt kết quả',
            value: resultDeadline.isEmpty ? '-' : resultDeadline,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 112,
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: AppTextStyles.micro.copyWith(
                color: value == '-' ? AppColors.text3 : AppColors.text1,
                fontWeight: value == '-'
                    ? AppTextStyles.normal
                    : AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationNote extends StatelessWidget {
  const _ModerationNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Challenge sẽ được kiểm duyệt tự động. Nội dung vi phạm sẽ bị ẩn. Arena Points không phải tài sản tài chính.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterActions extends StatelessWidget {
  const _FooterActions({
    required this.canProceed,
    required this.clarityScore,
    required this.onBack,
    required this.onContinue,
    required this.onSave,
    this.statusLabel,
  });

  final bool canProceed;
  final int clarityScore;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: AppSpacing.ctaHeight,
              height: AppSpacing.ctaHeight,
              child: VitCtaButton(
                onPressed: onBack,
                variant: VitCtaButtonVariant.secondary,
                fullWidth: false,
                padding: EdgeInsets.zero,
                child: const Icon(Icons.chevron_left_rounded),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                key: ArenaSmartRuleBuilderPage.continueKey,
                onPressed: canProceed ? onContinue : null,
                trailing: const Icon(Icons.chevron_right_rounded),
                child: const Text('Tiếp tục'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            TextButton.icon(
              key: ArenaSmartRuleBuilderPage.saveKey,
              onPressed: onSave,
              icon: const Icon(Icons.save_outlined, size: 15),
              label: const Text('Lưu nháp'),
            ),
            if (statusLabel != null)
              Expanded(
                child: Text(
                  statusLabel!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.micro.copyWith(color: AppColors.buy),
                ),
              )
            else
              const Spacer(),
            VitStatusPill(
              label: 'Clarity: $clarityScore',
              status: clarityScore >= 35
                  ? VitStatusPillStatus.orange
                  : VitStatusPillStatus.error,
              size: VitStatusPillSize.sm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Bước 3 / 6',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
    this.hint,
  });

  final String label;
  final Widget child;
  final bool required;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.x1,
          runSpacing: AppSpacing.x1,
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
            if (hint != null) ...[
              Text(
                hint!,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        child,
      ],
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: AppColors.searchBg,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x4,
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.searchBorder, width: 1.5),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.5),
    ),
  );
}
