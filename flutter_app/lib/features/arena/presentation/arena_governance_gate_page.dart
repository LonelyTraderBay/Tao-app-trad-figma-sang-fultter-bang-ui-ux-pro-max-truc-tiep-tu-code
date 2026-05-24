import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/arena_repository.dart';

const _arenaAccent = AppModuleAccents.arena;

class ArenaGovernanceGatePage extends ConsumerStatefulWidget {
  const ArenaGovernanceGatePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc188_governance_content');
  static const titleKey = Key('sc188_title');
  static const compareKey = Key('sc188_compare');
  static const saveKey = Key('sc188_save');
  static const continueKey = Key('sc188_continue');

  static Key privacyKey(String id) => Key('sc188_privacy_$id');

  static Key domainKey(String id) => Key('sc188_domain_$id');

  static Key challengeTypeKey(String id) => Key('sc188_type_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaGovernanceGatePage> createState() =>
      _ArenaGovernanceGatePageState();
}

class _ArenaGovernanceGatePageState
    extends ConsumerState<ArenaGovernanceGatePage> {
  String _privacy = 'public';
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
  String _resolutionSource = '';
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
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaGovernance();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final result = _governanceResult();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-188 ArenaGovernanceGatePage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'Arena Studio',
              subtitle: '10C — Governance Gate',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaGovernanceGatePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Column(
                    children: [
                      VitPageContent(
                        padding: VitContentPadding.compact,
                        customGap: AppSpacing.x5,
                        children: [
                          _GovernanceStepper(steps: snapshot.steps, step: 3),
                          const _GovernanceTitle(),
                          _PrivacyCard(
                            options: snapshot.privacyOptions,
                            privacy: _privacy,
                            onSelected: _setPrivacy,
                            onCompare: _showGuidance,
                          ),
                          _ClarityScoreCard(result: result),
                          _TitleField(
                            title: _title,
                            onChanged: (value) =>
                                setState(() => _title = value),
                          ),
                          _DomainGrid(
                            domains: snapshot.domains,
                            selectedId: _domainId,
                            publicRoom: _privacy == 'public',
                            onSelected: _selectDomain,
                          ),
                          _ChallengeTypeGrid(
                            types: snapshot.challengeTypes,
                            selectedId: _challengeTypeId,
                            publicRoom: _privacy == 'public',
                            onSelected: _selectChallengeType,
                          ),
                          _WinConditionCard(
                            snapshot: snapshot,
                            subject: _subject,
                            action: _action,
                            metric: _metric,
                            winType: _winType,
                            deadlineContext: _deadlineContext,
                            customWinCondition: _customWinCondition,
                            publicRoom: _privacy == 'public',
                            onSubject: () => setState(
                              () => _subject = snapshot.subjects.first,
                            ),
                            onAction: () => setState(
                              () => _action = snapshot.actions.first,
                            ),
                            onMetric: () => setState(
                              () => _metric = snapshot.metrics.first,
                            ),
                            onWinType: () => setState(
                              () => _winType = snapshot.winTypes.first,
                            ),
                            onDeadlineContext: () => setState(
                              () => _deadlineContext =
                                  snapshot.deadlineContexts.first,
                            ),
                            onCustomWinChanged: (value) =>
                                setState(() => _customWinCondition = value),
                          ),
                          _DescriptionField(
                            value: _description,
                            onChanged: (value) =>
                                setState(() => _description = value),
                          ),
                          _ResolutionSourceField(
                            publicRoom: _privacy == 'public',
                            value: _resolutionSource,
                            options: snapshot.resolutionSources,
                            onTap: () => setState(
                              () => _resolutionSource =
                                  snapshot.resolutionSources.first,
                            ),
                          ),
                          _TimingRulesCard(
                            snapshot: snapshot,
                            endDate: _endDate,
                            tieRule: _tieRule,
                            voidRule: _voidRule,
                            resultDeadline: _resultDeadline,
                            rematchEnabled: _rematchEnabled,
                            saveAsMode: _saveAsMode,
                            publicRoom: _privacy == 'public',
                            onDate: (value) => setState(() => _endDate = value),
                            onTieRule: () => setState(
                              () => _tieRule = snapshot.tieRules.first,
                            ),
                            onVoidRule: () => setState(
                              () => _voidRule = snapshot.voidRules.first,
                            ),
                            onResultDeadline: () => setState(
                              () => _resultDeadline =
                                  snapshot.resultDeadlines.first,
                            ),
                            onRematch: () => setState(
                              () => _rematchEnabled = !_rematchEnabled,
                            ),
                            onSaveAsMode: () =>
                                setState(() => _saveAsMode = !_saveAsMode),
                          ),
                          _WarningStack(result: result),
                          _SuggestedFallbackCard(
                            suggestions: snapshot.suggestionActions,
                            onTap: _applySuggestion,
                          ),
                          _EligibilityPanel(result: result),
                          _GovernanceSummary(
                            result: result,
                            privacy: _privacy,
                            resolutionSource: _resolutionSource,
                          ),
                          const _ModerationNote(),
                        ],
                      ),
                      _GovernanceFooter(
                        canContinue: result.canProceed,
                        result: result,
                        statusLabel: _statusLabel,
                        onBack: _close,
                        onSave: _saveDraft,
                        onContinue: _continue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _GovernanceResult _governanceResult() {
    var score = 5;
    if (_title.length >= 5) score += 10;
    if (_domainId.isNotEmpty) score += _domainId == 'other' ? 4 : 10;
    if (_challengeTypeId.isNotEmpty) score += 10;
    if (_subject.isNotEmpty) score += 7;
    if (_action.isNotEmpty) score += 7;
    if (_metric.isNotEmpty) score += 5;
    if (_winType.isNotEmpty) score += 4;
    if (_deadlineContext.isNotEmpty) score += 4;
    if (_customWinCondition.length >= 10) score += 10;
    if (_description.length >= 15) score += 6;
    if (_resolutionSource.isNotEmpty) score += 8;
    if (_tieRule.isNotEmpty) score += 8;
    if (_voidRule.isNotEmpty) score += 8;
    if (_resultDeadline.isNotEmpty) score += 8;
    score = score.clamp(0, 100);

    final hasWin =
        (_subject.isNotEmpty && _action.isNotEmpty) ||
        _customWinCondition.length >= 10;
    final checks = [
      _GovernanceCheck('Lĩnh vực đã chọn', _domainId.isNotEmpty),
      _GovernanceCheck('Loại challenge đã chọn', _challengeTypeId.isNotEmpty),
      _GovernanceCheck('Cách thắng rõ ràng', hasWin),
      _GovernanceCheck('Cách chốt kết quả rõ', _resolutionSource.isNotEmpty),
      _GovernanceCheck('Luật hòa (tie rule)', _tieRule.isNotEmpty),
      _GovernanceCheck('Luật hủy bỏ (void rule)', _voidRule.isNotEmpty),
      _GovernanceCheck('Deadline kết quả', _resultDeadline.isNotEmpty),
    ];
    final passed = checks.where((item) => item.passed).length;
    final allPassed = checks.every((item) => item.passed);
    final publicRoom = _privacy == 'public';
    final level = score >= 85
        ? 'Public-ready'
        : score >= 60
        ? 'Cao'
        : score >= 35
        ? 'Trung bình'
        : 'Thấp';
    final tier = publicRoom
        ? allPassed && score >= 60
              ? _EligibilityTier.green
              : passed >= 4
              ? _EligibilityTier.amber
              : _EligibilityTier.red
        : hasWin && passed >= 3
        ? _EligibilityTier.green
        : passed > 0
        ? _EligibilityTier.amber
        : _EligibilityTier.red;
    final warnings = <String>[
      if (publicRoom && !allPassed)
        'Room public nhưng chưa đủ thông tin bắt buộc. Hoàn thành checklist hoặc chuyển sang Private.',
      if (_tieRule.isEmpty && _voidRule.isEmpty)
        'Thiếu luật hòa và luật hủy bỏ. Bổ sung để tránh tranh chấp khi có tình huống đặc biệt.',
      if (_domainId == 'other' && publicRoom)
        'Custom domain trên room Public cần rule rất rõ. Cân nhắc Invite Only nếu rule phức tạp.',
    ];
    final nextAction = _domainId.isEmpty
        ? 'Chọn lĩnh vực'
        : _challengeTypeId.isEmpty
        ? 'Chọn loại challenge'
        : !hasWin
        ? 'Thiết lập điều kiện thắng'
        : _resolutionSource.isEmpty
        ? 'Chọn cách chốt kết quả'
        : _tieRule.isEmpty
        ? 'Bổ sung luật hòa'
        : _voidRule.isEmpty
        ? 'Bổ sung luật hủy bỏ'
        : _resultDeadline.isEmpty
        ? 'Bổ sung deadline kết quả'
        : 'Sẵn sàng tiếp tục';

    return _GovernanceResult(
      clarity: score,
      level: level,
      tier: tier,
      checks: checks,
      warnings: warnings,
      risk: _domainId == 'other' && publicRoom ? 'Cao' : 'Thấp',
      nextAction: nextAction,
      canProceed:
          tier == _EligibilityTier.green ||
          (_privacy != 'public' && tier == _EligibilityTier.amber),
    );
  }

  void _setPrivacy(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      _privacy = value;
      _statusLabel = null;
    });
  }

  void _selectDomain(String id) {
    HapticFeedback.selectionClick();
    setState(() => _domainId = id);
  }

  void _selectChallengeType(String id) {
    HapticFeedback.selectionClick();
    setState(() => _challengeTypeId = id);
  }

  void _showGuidance() {
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = 'Public room cần checklist đầy đủ');
  }

  void _applySuggestion(ArenaGovernanceSuggestionDraft suggestion) {
    HapticFeedback.selectionClick();
    setState(() {
      if (suggestion.id == 'closest_guess') {
        _challengeTypeId = 'closest_guess';
      } else if (suggestion.id == 'proof_challenge') {
        _challengeTypeId = 'proof_challenge';
      } else if (suggestion.id == 'invite_only') {
        _privacy = 'private';
      } else if (suggestion.id == 'add_rules') {
        _tieRule = 'Chia đều pool';
        _voidRule = 'Không đủ bằng chứng -> hủy';
      }
      _statusLabel = 'Đã áp dụng gợi ý';
    });
  }

  void _saveDraft() {
    HapticFeedback.selectionClick();
    setState(() => _statusLabel = 'Đã lưu nháp');
  }

  void _continue() {
    HapticFeedback.selectionClick();
    final result = _governanceResult();
    setState(() {
      _statusLabel = result.canProceed
          ? 'Governance Gate passed'
          : result.nextAction;
    });
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arenaStudio);
  }
}

enum _EligibilityTier { green, amber, red }

final class _GovernanceCheck {
  const _GovernanceCheck(this.label, this.passed);

  final String label;
  final bool passed;
}

final class _GovernanceResult {
  const _GovernanceResult({
    required this.clarity,
    required this.level,
    required this.tier,
    required this.checks,
    required this.warnings,
    required this.risk,
    required this.nextAction,
    required this.canProceed,
  });

  final int clarity;
  final String level;
  final _EligibilityTier tier;
  final List<_GovernanceCheck> checks;
  final List<String> warnings;
  final String risk;
  final String nextAction;
  final bool canProceed;
}

class _GovernanceStepper extends StatelessWidget {
  const _GovernanceStepper({required this.steps, required this.step});

  final List<ArenaStudioStepDraft> steps;
  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < steps.length; i++) ...[
          Expanded(
            child: _StepMarker(item: steps[i], activeStep: step),
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

class _StepMarker extends StatelessWidget {
  const _StepMarker({required this.item, required this.activeStep});

  final ArenaStudioStepDraft item;
  final int activeStep;

  @override
  Widget build(BuildContext context) {
    final done = item.index < activeStep;
    final active = item.index == activeStep;
    return Column(
      children: [
        Container(
          width: active ? 31 : 28,
          height: active ? 31 : 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: done
                ? AppColors.buy
                : active
                ? AppColors.accent
                : AppColors.surface3,
            shape: BoxShape.circle,
          ),
          child: done
              ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
              : Text(
                  '${item.index}',
                  style: AppTextStyles.micro.copyWith(
                    color: active ? Colors.white : AppColors.text3,
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

class _GovernanceTitle extends StatelessWidget {
  const _GovernanceTitle();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const VitModuleSectionHeader(
          title: 'Luật chơi — Governed Mode',
          accentColor: _arenaAccent,
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          'Governance Gate tự động kiểm tra rule trước khi publish',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard({
    required this.options,
    required this.privacy,
    required this.onSelected,
    required this.onCompare,
  });

  final List<ArenaPrivacyOptionDraft> options;
  final String privacy;
  final ValueChanged<String> onSelected;
  final VoidCallback onCompare;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Quyền riêng tư',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              VitCard(
                key: ArenaGovernanceGatePage.compareKey,
                variant: VitCardVariant.ghost,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x2,
                  vertical: AppSpacing.x1,
                ),
                onTap: onCompare,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.help_outline_rounded,
                      color: AppColors.accent,
                      size: 14,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      'So sánh',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.accent,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              for (final option in options) ...[
                Expanded(
                  child: _PrivacyChip(
                    option: option,
                    active: privacy == option.id,
                    onTap: () => onSelected(option.id),
                  ),
                ),
                if (option != options.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (privacy == 'public') ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              'Public room yêu cầu tất cả mục rule bắt buộc. Governance Gate sẽ kiểm tra tự động.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _PrivacyChip extends StatelessWidget {
  const _PrivacyChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ArenaPrivacyOptionDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaGovernanceGatePage.privacyKey(option.id),
      variant: active ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: active ? AppColors.accent20 : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      onTap: onTap,
      child: Column(
        children: [
          Icon(
            _privacyIcon(option.id),
            color: active ? AppColors.accent : AppColors.text3,
            size: 16,
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: active ? AppColors.accent : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ClarityScoreCard extends StatelessWidget {
  const _ClarityScoreCard({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = result.clarity >= 60 ? AppColors.buy : AppColors.sell;
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: color, size: 16),
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
                '${result.clarity}',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _StatusPill(label: result.level, color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: LinearProgressIndicator(
              minHeight: 7,
              value: result.clarity / 100,
              backgroundColor: AppColors.surface3,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({required this.title, required this.onChanged});

  final String title;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Tên challenge',
      required: true,
      child: TextFormField(
        key: ArenaGovernanceGatePage.titleKey,
        initialValue: title,
        onChanged: onChanged,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration('VD: BTC Weekly Predict — Tuần 10'),
      ),
    );
  }
}

class _DomainGrid extends StatelessWidget {
  const _DomainGrid({
    required this.domains,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> domains;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Lĩnh vực',
      required: publicRoom,
      child: Wrap(
        spacing: AppSpacing.x2,
        runSpacing: AppSpacing.x3,
        children: [
          for (final domain in domains)
            _MiniOptionChip(
              key: ArenaGovernanceGatePage.domainKey(domain.id),
              icon: _domainIcon(domain.id),
              label: domain.label,
              selected: selectedId == domain.id,
              onTap: () => onSelected(domain.id),
            ),
        ],
      ),
    );
  }
}

class _ChallengeTypeGrid extends StatelessWidget {
  const _ChallengeTypeGrid({
    required this.types,
    required this.selectedId,
    required this.publicRoom,
    required this.onSelected,
  });

  final List<ArenaSmartOptionDraft> types;
  final String selectedId;
  final bool publicRoom;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Loại challenge',
      required: publicRoom,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: types.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3.2,
          crossAxisSpacing: AppSpacing.x2,
          mainAxisSpacing: AppSpacing.x2,
        ),
        itemBuilder: (context, index) {
          final type = types[index];
          return _MiniOptionChip(
            key: ArenaGovernanceGatePage.challengeTypeKey(type.id),
            icon: _challengeIcon(type.id),
            label: type.label,
            selected: selectedId == type.id,
            onTap: () => onSelected(type.id),
          );
        },
      ),
    );
  }
}

class _WinConditionCard extends StatelessWidget {
  const _WinConditionCard({
    required this.snapshot,
    required this.subject,
    required this.action,
    required this.metric,
    required this.winType,
    required this.deadlineContext,
    required this.customWinCondition,
    required this.publicRoom,
    required this.onSubject,
    required this.onAction,
    required this.onMetric,
    required this.onWinType,
    required this.onDeadlineContext,
    required this.onCustomWinChanged,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String subject;
  final String action;
  final String metric;
  final String winType;
  final String deadlineContext;
  final String customWinCondition;
  final bool publicRoom;
  final VoidCallback onSubject;
  final VoidCallback onAction;
  final VoidCallback onMetric;
  final VoidCallback onWinType;
  final VoidCallback onDeadlineContext;
  final ValueChanged<String> onCustomWinChanged;

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
                Icons.adjust_rounded,
                color: AppColors.accent,
                size: 16,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Điều kiện thắng',
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (publicRoom) const _RequiredPill(text: 'BẮT BUỘC'),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: AppSpacing.x2,
            mainAxisSpacing: AppSpacing.x2,
            childAspectRatio: 2.45,
            children: [
              _BuilderField(
                label: 'A. Chủ thể',
                value: subject,
                onTap: onSubject,
              ),
              _BuilderField(
                label: 'B. Hành động',
                value: action,
                onTap: onAction,
              ),
              _BuilderField(label: 'C. Chỉ số', value: metric, onTap: onMetric),
              _BuilderField(
                label: 'D. Kiểu thắng',
                value: winType,
                onTap: onWinType,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _BuilderField(
            label: 'E. Thời điểm',
            value: deadlineContext,
            onTap: onDeadlineContext,
          ),
          const SizedBox(height: AppSpacing.x3),
          TextFormField(
            initialValue: customWinCondition,
            onChanged: onCustomWinChanged,
            maxLines: 2,
            style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            decoration: _inputDecoration(
              'VD: Người đoán gần nhất với giá ETH vào 25/03 lúc 10:00 sẽ thắng.',
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
      child: TextFormField(
        initialValue: value,
        onChanged: onChanged,
        maxLines: 2,
        style: AppTextStyles.base.copyWith(color: AppColors.text1),
        decoration: _inputDecoration(
          'Mô tả bối cảnh nếu cần. Không cần lặp lại luật chơi.',
        ),
      ),
    );
  }
}

class _ResolutionSourceField extends StatelessWidget {
  const _ResolutionSourceField({
    required this.publicRoom,
    required this.value,
    required this.options,
    required this.onTap,
  });

  final bool publicRoom;
  final String value;
  final List<String> options;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return _FieldBlock(
      label: 'Cách chốt kết quả',
      required: publicRoom,
      child: _DropdownCard(
        value: value,
        placeholder: 'Chọn resolution source...',
        onTap: onTap,
      ),
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
    required this.publicRoom,
    required this.onDate,
    required this.onTieRule,
    required this.onVoidRule,
    required this.onResultDeadline,
    required this.onRematch,
    required this.onSaveAsMode,
  });

  final ArenaGovernanceSnapshot snapshot;
  final String endDate;
  final String tieRule;
  final String voidRule;
  final String resultDeadline;
  final bool rematchEnabled;
  final bool saveAsMode;
  final bool publicRoom;
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
          const SizedBox(height: AppSpacing.x3),
          _FieldBlock(
            label: 'Thời hạn kết thúc',
            child: TextFormField(
              initialValue: _formatArenaDateInput(endDate),
              onChanged: (value) => onDate(_normalizeArenaDateInput(value)),
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
          _EdgeField(
            label: 'Luật hòa',
            publicRoom: publicRoom,
            value: tieRule,
            placeholder: 'Chọn tie rule...',
            onTap: onTieRule,
          ),
          _EdgeField(
            label: 'Luật hủy bỏ',
            publicRoom: publicRoom,
            value: voidRule,
            placeholder: 'Chọn void rule...',
            onTap: onVoidRule,
          ),
          _EdgeField(
            label: 'Hạn chốt kết quả',
            publicRoom: publicRoom,
            value: resultDeadline,
            placeholder: 'Chọn result deadline...',
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
            description: 'Người khác có thể clone luật chơi',
            value: saveAsMode,
            onTap: onSaveAsMode,
          ),
        ],
      ),
    );
  }
}

class _WarningStack extends StatelessWidget {
  const _WarningStack({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    if (result.warnings.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        for (final warning in result.warnings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.x2),
            child: VitCard(
              variant: VitCardVariant.inner,
              borderColor: AppColors.warningBorder,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.warn,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      warning,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _SuggestedFallbackCard extends StatelessWidget {
  const _SuggestedFallbackCard({
    required this.suggestions,
    required this.onTap,
  });

  final List<ArenaGovernanceSuggestionDraft> suggestions;
  final ValueChanged<ArenaGovernanceSuggestionDraft> onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.lightbulb_outline_rounded,
            label: 'Gợi ý cải thiện',
            pill: 'SMART',
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final item in suggestions)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.all(AppSpacing.x3),
                onTap: () => onTap(item),
                child: Row(
                  children: [
                    const Icon(
                      Icons.auto_fix_high_rounded,
                      color: _arenaAccent,
                      size: 16,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                          Text(
                            item.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.text3,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EligibilityPanel extends StatelessWidget {
  const _EligibilityPanel({required this.result});

  final _GovernanceResult result;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return VitCard(
      borderColor: _tierBorder(result.tier),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_tierIcon(result.tier), color: color, size: 16),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  _tierLabel(result.tier),
                  style: AppTextStyles.base.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              _StatusPill(label: 'Clarity: ${result.clarity}', color: color),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final check in result.checks)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.x2),
              child: Row(
                children: [
                  Icon(
                    check.passed
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: check.passed ? AppColors.buy : AppColors.text3,
                    size: 18,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      check.label,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: check.passed
                            ? AppTextStyles.bold
                            : AppTextStyles.medium,
                      ),
                    ),
                  ),
                  if (!check.passed)
                    const _RequiredPill(text: 'PUBLIC', compact: true),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _GovernanceSummary extends StatelessWidget {
  const _GovernanceSummary({
    required this.result,
    required this.privacy,
    required this.resolutionSource,
  });

  final _GovernanceResult result;
  final String privacy;
  final String resolutionSource;

  @override
  Widget build(BuildContext context) {
    final privacyLabel = privacy == 'public'
        ? 'Công khai'
        : privacy == 'private'
        ? 'Riêng tư'
        : 'Unlisted';
    return VitCard(
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.summarize_outlined,
            label: 'Governance Summary',
            pill: 'TỰ SINH',
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryRow(label: 'Rule clarity', value: '${result.clarity} / 100'),
          _SummaryRow(
            label: 'Publish eligibility',
            value: _tierLabel(result.tier),
          ),
          _SummaryRow(label: 'Risk tier', value: result.risk),
          _SummaryRow(
            label: 'Resolution method',
            value: resolutionSource.isEmpty ? '-' : resolutionSource,
          ),
          _SummaryRow(label: 'Privacy', value: privacyLabel),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    result.tier == _EligibilityTier.green
                        ? 'Rule đủ rõ để tiếp tục.'
                        : 'Nên chuyển sang Private hoặc Unlisted cho đến khi rule rõ ràng hơn.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _NextActionChip(text: result.nextAction),
        ],
      ),
    );
  }
}

class _GovernanceFooter extends StatelessWidget {
  const _GovernanceFooter({
    required this.canContinue,
    required this.result,
    required this.statusLabel,
    required this.onBack,
    required this.onSave,
    required this.onContinue,
  });

  final bool canContinue;
  final _GovernanceResult result;
  final String? statusLabel;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.bg,
        border: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x4,
          AppSpacing.x5,
          AppSpacing.x2,
        ),
        child: Column(
          children: [
            Row(
              children: [
                VitCard(
                  variant: VitCardVariant.inner,
                  width: AppSpacing.ctaHeight,
                  height: AppSpacing.ctaHeight,
                  onTap: onBack,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.text2,
                    size: 22,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitCtaButton(
                    key: ArenaGovernanceGatePage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tiếp tục'),
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: canContinue ? Colors.white : AppColors.text3,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                VitCard(
                  key: ArenaGovernanceGatePage.saveKey,
                  variant: VitCardVariant.ghost,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x1,
                    vertical: AppSpacing.x2,
                  ),
                  onTap: onSave,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        color: AppColors.text3,
                        size: 14,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Lưu nháp',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    statusLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                _StatusPill(label: _tierLabel(result.tier), color: color),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Bước 3 / 6',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldBlock extends StatelessWidget {
  const _FieldBlock({
    required this.label,
    required this.child,
    this.required = false,
  });

  final String label;
  final Widget child;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text(
              label,
              style: AppTextStyles.base.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            if (required) ...[
              const SizedBox(width: AppSpacing.x1),
              Text(
                '*',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontWeight: AppTextStyles.bold,
                ),
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

class _MiniOptionChip extends StatelessWidget {
  const _MiniOptionChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: selected ? VitCardVariant.inner : VitCardVariant.ghost,
      borderColor: selected ? AppColors.warn : AppColors.borderSolid,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x2,
      ),
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: selected ? AppColors.warn : AppColors.text3,
            size: 14,
          ),
          const SizedBox(width: AppSpacing.x1),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 132),
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: selected ? AppColors.warn : AppColors.text3,
                fontWeight: selected
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BuilderField extends StatelessWidget {
  const _BuilderField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        _DropdownCard(value: value, placeholder: 'Chọn...', onTap: onTap),
      ],
    );
  }
}

class _EdgeField extends StatelessWidget {
  const _EdgeField({
    required this.label,
    required this.publicRoom,
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String label;
  final bool publicRoom;
  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: AppSpacing.x1,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              if (publicRoom)
                const _RequiredPill(text: 'PUBLIC', compact: true),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _DropdownCard(value: value, placeholder: placeholder, onTap: onTap),
        ],
      ),
    );
  }
}

class _DropdownCard extends StatelessWidget {
  const _DropdownCard({
    required this.value,
    required this.placeholder,
    required this.onTap,
  });

  final String value;
  final String placeholder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value.isNotEmpty;
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: hasValue ? AppColors.accent20 : AppColors.borderSolid,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasValue ? value : placeholder,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: hasValue ? AppColors.text1 : AppColors.text3,
                fontWeight: hasValue
                    ? AppTextStyles.bold
                    : AppTextStyles.medium,
              ),
            ),
          ),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.text3,
            size: 18,
          ),
        ],
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
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.x2),
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
            onChanged: (_) => onTap(),
            activeThumbColor: AppColors.warn,
            activeTrackColor: AppColors.warn15,
            inactiveThumbColor: AppColors.text2,
            inactiveTrackColor: AppColors.surface3,
          ),
        ],
      ),
    );
  }
}

class _MiniHeader extends StatelessWidget {
  const _MiniHeader({required this.icon, required this.label, this.pill});

  final IconData icon;
  final String label;
  final String? pill;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _arenaAccent, size: 16),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.base.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        if (pill != null) _StatusPill(label: pill!, color: AppColors.accent),
      ],
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
      padding: const EdgeInsets.only(bottom: AppSpacing.x2),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequiredPill extends StatelessWidget {
  const _RequiredPill({required this.text, this.compact = false});

  final String text;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return _StatusPill(label: text, color: AppColors.sell, compact: compact);
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.color,
    this.compact = false,
  });

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color == AppColors.sell
            ? AppColors.sell10
            : color == AppColors.buy
            ? AppColors.buy10
            : AppColors.warn10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? AppSpacing.x1 : AppSpacing.x2,
          vertical: compact ? 1 : 3,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _NextActionChip extends StatelessWidget {
  const _NextActionChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      child: Row(
        children: [
          const Icon(Icons.add_rounded, color: AppColors.accent, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.accent,
                fontWeight: AppTextStyles.bold,
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
      borderColor: AppColors.accent20,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.accent,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Governance Gate giúp bạn tạo room chất lượng, không cản bạn sáng tạo. Custom mode vẫn mở cho mọi lĩnh vực, nhưng room public cần rule rõ ràng để bảo vệ người tham gia.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.base.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: AppColors.surface2,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.x4,
      vertical: AppSpacing.x3,
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.borderSolid, width: 1.4),
    ),
    focusedBorder: const OutlineInputBorder(
      borderRadius: AppRadii.inputRadius,
      borderSide: BorderSide(color: AppColors.accent, width: 1.4),
    ),
  );
}

String _formatArenaDateInput(String isoDate) {
  final parts = isoDate.split('-');
  if (parts.length != 3) return isoDate;
  return '${parts[1]}/${parts[2]}/${parts[0]}';
}

String _normalizeArenaDateInput(String displayDate) {
  final parts = displayDate.split('/');
  if (parts.length != 3) return displayDate;
  return '${parts[2].padLeft(4, '0')}-${parts[0].padLeft(2, '0')}-${parts[1].padLeft(2, '0')}';
}

IconData _privacyIcon(String id) {
  switch (id) {
    case 'public':
      return Icons.public_rounded;
    case 'private':
      return Icons.lock_outline_rounded;
    default:
      return Icons.link_rounded;
  }
}

IconData _domainIcon(String id) {
  switch (id) {
    case 'sports':
      return Icons.sports_soccer_rounded;
    case 'esports':
      return Icons.sports_esports_rounded;
    case 'crypto':
      return Icons.show_chart_rounded;
    case 'tech':
      return Icons.smart_toy_outlined;
    case 'science':
      return Icons.science_outlined;
    case 'health':
      return Icons.fitness_center_rounded;
    case 'entertainment':
      return Icons.movie_outlined;
    case 'work':
      return Icons.business_center_outlined;
    case 'community':
      return Icons.groups_2_outlined;
    default:
      return Icons.category_outlined;
  }
}

IconData _challengeIcon(String id) {
  switch (id) {
    case 'multi_choice':
      return Icons.format_list_bulleted_rounded;
    case 'closest_guess':
      return Icons.adjust_rounded;
    case 'highest_wins':
      return Icons.bar_chart_rounded;
    case 'lowest_wins':
      return Icons.trending_down_rounded;
    case 'first_to_finish':
      return Icons.flag_outlined;
    case 'team_score':
      return Icons.groups_rounded;
    case 'referee_decision':
      return Icons.gavel_rounded;
    case 'community_vote':
      return Icons.how_to_vote_outlined;
    case 'proof_challenge':
      return Icons.verified_outlined;
    default:
      return Icons.check_box_outlined;
  }
}

String _tierLabel(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return 'Public-ready';
    case _EligibilityTier.amber:
      return 'Private only';
    case _EligibilityTier.red:
      return 'Chưa đủ điều kiện';
  }
}

Color _tierColor(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return AppColors.buy;
    case _EligibilityTier.amber:
      return AppColors.warn;
    case _EligibilityTier.red:
      return AppColors.sell;
  }
}

Color _tierBorder(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return AppColors.buy20;
    case _EligibilityTier.amber:
      return AppColors.warningBorder;
    case _EligibilityTier.red:
      return AppColors.sell20;
  }
}

IconData _tierIcon(_EligibilityTier tier) {
  switch (tier) {
    case _EligibilityTier.green:
      return Icons.verified_user_outlined;
    case _EligibilityTier.amber:
      return Icons.shield_outlined;
    case _EligibilityTier.red:
      return Icons.shield_outlined;
  }
}
