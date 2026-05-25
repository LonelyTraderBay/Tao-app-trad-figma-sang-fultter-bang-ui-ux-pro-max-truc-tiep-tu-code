import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

class StakingWithdrawalPolicyPage extends ConsumerStatefulWidget {
  const StakingWithdrawalPolicyPage({super.key, this.shellRenderMode});

  static const infoKey = Key('sc355_withdrawal_info');
  static const processKey = Key('sc355_withdrawal_process');
  static const calculatorCtaKey = Key('sc355_withdrawal_calculator_cta');
  static const calculatorResultKey = Key('sc355_withdrawal_calculator_result');
  static const emergencyKey = Key('sc355_withdrawal_emergency');

  static Key tabKey(String id) => Key('sc355_withdrawal_tab_$id');
  static Key timelineKey(String product) =>
      Key('sc355_withdrawal_timeline_$product');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<StakingWithdrawalPolicyPage> createState() =>
      _StakingWithdrawalPolicyPageState();
}

class _StakingWithdrawalPolicyPageState
    extends ConsumerState<StakingWithdrawalPolicyPage> {
  String? _activeTab;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingWithdrawalPolicyRepositoryProvider)
        .getPolicy();
    final activeTab = _activeTab ?? snapshot.defaultTab;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-355 StakingWithdrawalPolicyPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    _PolicyTabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _activeTab = tab);
                      },
                    ),
                    if (activeTab == 'timeline')
                      _TimelineTab(snapshot: snapshot)
                    else if (activeTab == 'penalties')
                      _PenaltiesTab(
                        snapshot: snapshot,
                        onOpenCalculator: () => _openCalculator(snapshot),
                      )
                    else
                      _EmergencyTab(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCalculator(StakingWithdrawalPolicySnapshot snapshot) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _PenaltyCalculatorSheet(snapshot: snapshot),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingWithdrawalPolicyPage.infoKey,
      constraints: const BoxConstraints(minHeight: 104),
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20, width: 1.5),
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PolicyTabs extends StatelessWidget {
  const _PolicyTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<StakingRiskDisclosureTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface2,
      constraints: const BoxConstraints(minHeight: 54),
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
      child: VitTabBar(
        variant: VitTabBarVariant.underline,
        activeKey: active,
        onChanged: onChanged,
        tabs: [
          for (final tab in tabs)
            VitTabItem(key: tab.id, label: tab.label, icon: null),
        ],
      ),
    );
  }
}

class _TimelineTab extends StatelessWidget {
  const _TimelineTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.processTitle,
          children: [_ProcessCard(steps: snapshot.processSteps)],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: snapshot.timelineTitle,
          children: [
            for (final timeline in snapshot.timelines)
              _TimelineCard(timeline: timeline),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _NoteCard(text: snapshot.timelineNote),
      ],
    );
  }
}

class _ProcessCard extends StatelessWidget {
  const _ProcessCard({required this.steps});

  final List<StakingWithdrawalStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWithdrawalPolicyPage.processKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final step in steps) ...[
            _ProcessStepRow(step: step),
            if (step != steps.last) const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _ProcessStepRow extends StatelessWidget {
  const _ProcessStepRow({required this.step});

  final StakingWithdrawalStepDraft step;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(step.tone);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: _toneTint(step.tone),
            border: Border.all(color: color.withValues(alpha: .28), width: 1.5),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Icon(_stepIcon(step.step), color: color, size: 21),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.x2,
                runSpacing: AppSpacing.x1,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _SmallBadge(label: 'Bước ${step.step}', color: color),
                  Text(
                    step.title,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                step.description,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.timeline});

  final StakingWithdrawalTimelineDraft timeline;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWithdrawalPolicyPage.timelineKey(timeline.product),
      radius: VitCardRadius.lg,
      constraints: BoxConstraints(
        minHeight: timeline.penalty.contains('\n') ? 152 : 122,
      ),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            timeline.product,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Có thể rút',
                  value: timeline.initiate,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Unbonding',
                  value: timeline.unbonding,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _TimelineMetric(
                  label: 'Nhận tiền',
                  value: timeline.receive,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _TimelineMetric(
                  label: 'Phí rút sớm',
                  value: timeline.penalty,
                  color: timeline.penalty == 'Không'
                      ? AppColors.buy
                      : AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineMetric extends StatelessWidget {
  const _TimelineMetric({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color ?? AppColors.text1,
            fontWeight: AppTextStyles.bold,
            height: 1.45,
          ),
        ),
      ],
    );
  }
}

class _PenaltiesTab extends StatelessWidget {
  const _PenaltiesTab({required this.snapshot, required this.onOpenCalculator});

  final StakingWithdrawalPolicySnapshot snapshot;
  final VoidCallback onOpenCalculator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.penaltyTitle,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.penaltyBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.65,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.x4),
                    decoration: BoxDecoration(
                      color: AppColors.surface2,
                      borderRadius: AppRadii.lgRadius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.cancel_outlined,
                              color: AppColors.sell,
                              size: 20,
                            ),
                            const SizedBox(width: AppSpacing.x2),
                            Expanded(
                              child: Text(
                                'Công thức Phí rút sớm:',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        for (final rule in snapshot.penaltyRules) ...[
                          _BulletLine(
                            text: rule.label,
                            color: _toneColor(rule.tone),
                          ),
                          if (rule != snapshot.penaltyRules.last)
                            const SizedBox(height: AppSpacing.x2),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Ví dụ Tính toán',
          children: [
            for (final example in snapshot.penaltyExamples)
              _PenaltyExampleCard(example: example),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: StakingWithdrawalPolicyPage.calculatorCtaKey,
          onPressed: onOpenCalculator,
          leading: const Icon(Icons.calculate_rounded),
          child: Text(snapshot.calculatorCta),
        ),
        const SizedBox(height: AppSpacing.x4),
        const _NoteCard(
          text:
              'Số lượng gốc không bị ảnh hưởng. Chỉ phần thưởng staking bị phạt; bạn luôn nhận lại 100% số tiền gốc đã stake.',
        ),
      ],
    );
  }
}

class _PenaltyExampleCard extends StatelessWidget {
  const _PenaltyExampleCard({required this.example});

  final StakingWithdrawalPenaltyExampleDraft example;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            example.title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Container(
            padding: const EdgeInsets.all(AppSpacing.x3),
            decoration: BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.lgRadius,
            ),
            child: Column(
              children: [
                for (final row in example.rows) ...[
                  if (row.label.startsWith('Phí'))
                    const Divider(color: AppColors.divider),
                  _CalculationRow(row: row),
                  if (row != example.rows.last)
                    const SizedBox(height: AppSpacing.x2),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CalculationRow extends StatelessWidget {
  const _CalculationRow({required this.row});

  final StakingWithdrawalCalculationRowDraft row;

  @override
  Widget build(BuildContext context) {
    final color = row.tone == null ? AppColors.text1 : _toneColor(row.tone!);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            row.label,
            style: AppTextStyles.caption.copyWith(
              color: row.highlight ? AppColors.text1 : AppColors.text3,
              fontWeight: row.highlight
                  ? AppTextStyles.bold
                  : AppTextStyles.normal,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Text(
          row.value,
          textAlign: TextAlign.end,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontWeight: row.highlight
                ? AppTextStyles.bold
                : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _EmergencyTab extends StatelessWidget {
  const _EmergencyTab({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: StakingWithdrawalPolicyPage.emergencyKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: snapshot.emergencyTitle,
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: AppColors.sell10,
                          border: Border.all(
                            color: AppColors.sell20,
                            width: 1.5,
                          ),
                          borderRadius: AppRadii.cardRadius,
                        ),
                        child: const Icon(
                          Icons.emergency_rounded,
                          color: AppColors.sell,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x3),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Khi nào cần rút khẩn cấp?',
                              style: AppTextStyles.baseMedium.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x2),
                            Text(
                              snapshot.emergencyBody,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text2,
                                fontSize: 12,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  for (final reason in snapshot.emergencyReasons) ...[
                    _BulletLine(text: reason, color: AppColors.sell),
                    if (reason != snapshot.emergencyReasons.last)
                      const SizedBox(height: AppSpacing.x2),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Quy trình Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                children: [
                  for (final step in snapshot.emergencySteps) ...[
                    _EmergencyStepRow(step: step),
                    if (step != snapshot.emergencySteps.last)
                      const SizedBox(height: AppSpacing.x4),
                  ],
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x5),
        VitPageSection(
          label: 'Phí Rút khẩn cấp',
          children: [
            VitCard(
              radius: VitCardRadius.lg,
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Phí rút khẩn cấp cao hơn phí rút sớm thông thường vì cần xử lý ưu tiên và bỏ qua unbonding period.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Wrap(
                    spacing: AppSpacing.x3,
                    runSpacing: AppSpacing.x3,
                    children: [
                      for (final fee in snapshot.emergencyFees)
                        _EmergencyFeeTile(fee: fee),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _WarningBox(text: snapshot.emergencyWarning),
        const SizedBox(height: AppSpacing.x4),
        _SupportCard(contacts: snapshot.supportContacts),
      ],
    );
  }
}

class _EmergencyStepRow extends StatelessWidget {
  const _EmergencyStepRow({required this.step});

  final StakingEmergencyStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primary12,
            border: Border.all(color: AppColors.primary20, width: 1.5),
            shape: BoxShape.circle,
          ),
          child: Text(
            '${step.step}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Row(
                children: [
                  const Icon(
                    Icons.timer_outlined,
                    color: AppColors.text3,
                    size: 14,
                  ),
                  const SizedBox(width: AppSpacing.x1),
                  Text(
                    step.time,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EmergencyFeeTile extends StatelessWidget {
  const _EmergencyFeeTile({required this.fee});

  final StakingEmergencyFeeDraft fee;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 174,
      child: Container(
        constraints: const BoxConstraints(minHeight: 84),
        padding: const EdgeInsets.all(AppSpacing.x3),
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: AppRadii.lgRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              fee.product,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              fee.fee,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.sell,
                fontWeight: AppTextStyles.bold,
                height: 1.35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.contacts});

  final List<StakingSupportContactDraft> contacts;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Liên hệ Support:',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final contact in contacts) ...[
            _SupportRow(contact: contact),
            if (contact != contacts.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SupportRow extends StatelessWidget {
  const _SupportRow({required this.contact});

  final StakingSupportContactDraft contact;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '${contact.label}:',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            contact.value,
            textAlign: TextAlign.end,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.medium,
            ),
          ),
        ),
      ],
    );
  }
}

class _PenaltyCalculatorSheet extends StatefulWidget {
  const _PenaltyCalculatorSheet({required this.snapshot});

  final StakingWithdrawalPolicySnapshot snapshot;

  @override
  State<_PenaltyCalculatorSheet> createState() =>
      _PenaltyCalculatorSheetState();
}

class _PenaltyCalculatorSheetState extends State<_PenaltyCalculatorSheet> {
  final _principalController = TextEditingController();
  final _earnedController = TextEditingController();
  final _daysController = TextEditingController();
  bool _previewRequested = false;

  @override
  void dispose() {
    _principalController.dispose();
    _earnedController.dispose();
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculate();
    final bottomPadding =
        MediaQuery.viewInsetsOf(context).bottom +
        MediaQuery.paddingOf(context).bottom +
        AppSpacing.x5;

    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            AppSpacing.x5,
            AppSpacing.x4,
            AppSpacing.x5,
            bottomPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Text(
                'Tính phí rút sớm',
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              VitInput(
                controller: _principalController,
                fieldKey: const Key('sc355_calculator_principal'),
                label: 'Số lượng gốc (Principal)',
                hintText: '1000',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.account_balance_wallet_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              const SizedBox(height: AppSpacing.x3),
              VitInput(
                controller: _earnedController,
                fieldKey: const Key('sc355_calculator_earned'),
                label: 'Phần thưởng đã tích lũy',
                hintText: '50',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                prefix: const Icon(Icons.savings_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              const SizedBox(height: AppSpacing.x3),
              VitInput(
                controller: _daysController,
                fieldKey: const Key('sc355_calculator_days'),
                label: 'Số ngày đã stake',
                hintText: '45',
                keyboardType: TextInputType.number,
                prefix: const Icon(Icons.calendar_month_rounded),
                onChanged: (_) => setState(() => _previewRequested = false),
              ),
              if (result != null) ...[
                const SizedBox(height: AppSpacing.x4),
                _CalculatorResult(
                  result: result,
                  previewRequested: _previewRequested,
                ),
              ],
              const SizedBox(height: AppSpacing.x4),
              _WarningBox(text: widget.snapshot.calculatorDisclaimer),
              const SizedBox(height: AppSpacing.x4),
              VitCtaButton(
                onPressed: result == null
                    ? null
                    : () {
                        HapticFeedback.mediumImpact();
                        setState(() => _previewRequested = true);
                      },
                leading: const Icon(Icons.fact_check_rounded),
                child: const Text('Xem preview rút'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _PenaltyCalculation? _calculate() {
    final principal = double.tryParse(_principalController.text);
    final earned = double.tryParse(_earnedController.text);
    final days = int.tryParse(_daysController.text);
    if (principal == null || earned == null || days == null) return null;
    if (principal <= 0 || earned < 0 || days < 0) return null;

    final rate = days < 30 ? 100 : 50;
    final penalty = rate == 100 ? earned : earned * .5;
    final remaining = earned - penalty;
    return _PenaltyCalculation(
      principal: principal,
      penalty: penalty,
      remaining: remaining,
      receive: principal + remaining,
      rate: rate,
    );
  }
}

class _PenaltyCalculation {
  const _PenaltyCalculation({
    required this.principal,
    required this.penalty,
    required this.remaining,
    required this.receive,
    required this.rate,
  });

  final double principal;
  final double penalty;
  final double remaining;
  final double receive;
  final int rate;
}

class _CalculatorResult extends StatelessWidget {
  const _CalculatorResult({
    required this.result,
    required this.previewRequested,
  });

  final _PenaltyCalculation result;
  final bool previewRequested;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: StakingWithdrawalPolicyPage.calculatorResultKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardLargeRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kết quả:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Phí rút sớm',
              value: '-${result.penalty.toStringAsFixed(2)} (${result.rate}%)',
              tone: result.rate == 100
                  ? StakingDisclosureRiskLevel.high
                  : StakingDisclosureRiskLevel.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Phần thưởng còn lại',
              value: '+${result.remaining.toStringAsFixed(2)}',
              tone: StakingDisclosureRiskLevel.low,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _CalculationRow(
            row: StakingWithdrawalCalculationRowDraft(
              label: 'Số lượng nhận về',
              value: result.receive.toStringAsFixed(2),
              highlight: true,
            ),
          ),
          if (previewRequested) ...[
            const SizedBox(height: AppSpacing.x3),
            _SmallBadge(
              label: 'Preview mock đã sẵn sàng - cần xác nhận trước khi rút',
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text3,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletLine extends StatelessWidget {
  const _BulletLine({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 7),
          child: SizedBox(
            width: 5,
            height: 5,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _SmallBadge extends StatelessWidget {
  const _SmallBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

IconData _stepIcon(int step) {
  switch (step) {
    case 1:
      return Icons.account_balance_wallet_rounded;
    case 2:
      return Icons.verified_user_rounded;
    case 3:
      return Icons.schedule_rounded;
    default:
      return Icons.check_circle_rounded;
  }
}

Color _toneColor(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy,
    StakingDisclosureRiskLevel.medium => AppColors.warn,
    StakingDisclosureRiskLevel.high => AppColors.sell,
  };
}

Color _toneTint(StakingDisclosureRiskLevel level) {
  return switch (level) {
    StakingDisclosureRiskLevel.low => AppColors.buy10,
    StakingDisclosureRiskLevel.medium => AppColors.warn10,
    StakingDisclosureRiskLevel.high => AppColors.sell10,
  };
}
