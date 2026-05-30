import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PKycStatusPage extends ConsumerWidget {
  const P2PKycStatusPage({super.key, this.shellRenderMode});

  static const statusCardKey = Key('sc248_p2p_kyc_status_card');
  static const timelineKey = Key('sc248_p2p_kyc_status_timeline');
  static Key stepKey(String stepId) => Key('sc248_p2p_kyc_status_step_$stepId');
  static Key actionKey(String stepId) =>
      Key('sc248_p2p_kyc_status_action_$stepId');
  static const supportKey = Key('sc248_p2p_kyc_status_support');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pKycStatusProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-248 P2PKycStatusPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'KYC Status',
              subtitle: 'KYC · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: RefreshIndicator(
                color: AppModuleAccents.p2p,
                backgroundColor: AppColors.surface2,
                onRefresh: () async {
                  HapticFeedback.selectionClick();
                  await Future<void>.delayed(const Duration(milliseconds: 120));
                },
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _OverallStatusCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x5),
                        Text(
                          'Chi tiết các bước',
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x4),
                        _StatusTimeline(steps: snapshot.steps),
                        const SizedBox(height: AppSpacing.x5),
                        _SupportCard(snapshot: snapshot),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallStatusCard extends StatelessWidget {
  const _OverallStatusCard({required this.snapshot});

  final P2PKycStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycStatusPage.statusCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: AppSpacing.inputHeight,
                height: AppSpacing.inputHeight,
                decoration: BoxDecoration(
                  color: AppColors.primary15,
                  borderRadius: AppRadii.lgRadius,
                  border: Border.all(color: AppColors.primary20),
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tier ${snapshot.tier} - ${snapshot.tierName}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Gửi lúc ${snapshot.submittedAt}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              VitStatusPill(
                label: snapshot.statusLabel,
                status: _verificationPill(snapshot.overallStatus),
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiến độ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                snapshot.progressLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressTrack(value: snapshot.progress),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            borderColor: AppColors.primary20,
            padding: const EdgeInsets.all(AppSpacing.x3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppModuleAccents.p2p,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    snapshot.infoBody,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
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

class _ProgressTrack extends StatelessWidget {
  const _ProgressTrack({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xsRadius,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: AppSpacing.x2,
            color: AppColors.surface3,
            alignment: Alignment.centerLeft,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              width: constraints.maxWidth * value.clamp(0, 1),
              decoration: const BoxDecoration(color: AppModuleAccents.p2p),
            ),
          );
        },
      ),
    );
  }
}

class _StatusTimeline extends StatelessWidget {
  const _StatusTimeline({required this.steps});

  final List<P2PKycStatusStepDraft> steps;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycStatusPage.timelineKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < steps.length; i++)
            _StepTimelineRow(step: steps[i], isLast: i == steps.length - 1),
        ],
      ),
    );
  }
}

class _StepTimelineRow extends StatelessWidget {
  const _StepTimelineRow({required this.step, required this.isLast});

  final P2PKycStatusStepDraft step;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final color = _stepColor(step.status);
    return IntrinsicHeight(
      child: Row(
        key: P2PKycStatusPage.stepKey(step.id),
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppSpacing.inputHeight,
            child: Column(
              children: [
                Container(
                  width: AppSpacing.inputHeight,
                  height: AppSpacing.inputHeight,
                  decoration: BoxDecoration(
                    color: _stepBackground(step.status),
                    borderRadius: AppRadii.lgRadius,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(
                    _stepIcon(step.iconKey),
                    color: color,
                    size: AppSpacing.iconMd,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: step.status == P2PKycStepStatus.completed
                          ? AppColors.buy
                          : AppColors.borderSolid,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.label,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            Text(
                              step.description,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      VitStatusPill(
                        label: step.statusLabel,
                        status: _stepPill(step.status),
                        icon: _stepStatusIcon(step.status),
                        size: VitStatusPillSize.sm,
                      ),
                    ],
                  ),
                  if (step.completedAt != null) ...[
                    const SizedBox(height: AppSpacing.x2),
                    _StepMeta(
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.text3,
                      text: 'Hoàn thành lúc ${step.completedAt}',
                    ),
                  ],
                  if (step.status == P2PKycStepStatus.processing &&
                      step.estimatedTime != null) ...[
                    const SizedBox(height: AppSpacing.x2),
                    _StepMeta(
                      icon: Icons.schedule_rounded,
                      color: AppModuleAccents.p2p,
                      text: 'Ước tính: ${step.estimatedTime}',
                    ),
                  ],
                  if (step.status == P2PKycStepStatus.waiting &&
                      !step.hasAction &&
                      step.estimatedTime != null) ...[
                    const SizedBox(height: AppSpacing.x2),
                    _StepMeta(
                      icon: Icons.schedule_rounded,
                      color: AppColors.text3,
                      text: 'Thời gian xử lý: ${step.estimatedTime}',
                    ),
                  ],
                  if (step.hasAction) ...[
                    const SizedBox(height: AppSpacing.x3),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _StepActionButton(step: step),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepMeta extends StatelessWidget {
  const _StepMeta({
    required this.icon,
    required this.color,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 11),
        const SizedBox(width: AppSpacing.x1),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _StepActionButton extends StatelessWidget {
  const _StepActionButton({required this.step});

  final P2PKycStatusStepDraft step;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppModuleAccents.p2p,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: P2PKycStatusPage.actionKey(step.id),
        borderRadius: AppRadii.inputRadius,
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(step.actionRoute!);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                step.actionLabel!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.onAccent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.onAccent,
                size: AppSpacing.iconSm,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.snapshot});

  final P2PKycStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycStatusPage.supportKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.chat_bubble_outline_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.supportTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.supportBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.go(snapshot.supportRoute);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Mở Support Chat',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppModuleAccents.p2p,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      const Icon(
                        Icons.open_in_new_rounded,
                        color: AppModuleAccents.p2p,
                        size: AppSpacing.iconSm,
                      ),
                    ],
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

VitStatusPillStatus _verificationPill(P2PKycVerificationStatus status) {
  return switch (status) {
    P2PKycVerificationStatus.approved => VitStatusPillStatus.success,
    P2PKycVerificationStatus.pending => VitStatusPillStatus.warning,
    P2PKycVerificationStatus.rejected => VitStatusPillStatus.error,
    P2PKycVerificationStatus.incomplete => VitStatusPillStatus.neutral,
  };
}

VitStatusPillStatus _stepPill(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => VitStatusPillStatus.success,
    P2PKycStepStatus.processing => VitStatusPillStatus.info,
    P2PKycStepStatus.pending => VitStatusPillStatus.warning,
    P2PKycStepStatus.rejected => VitStatusPillStatus.error,
    P2PKycStepStatus.waiting => VitStatusPillStatus.neutral,
  };
}

Color _stepColor(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => AppColors.buy,
    P2PKycStepStatus.processing => AppModuleAccents.p2p,
    P2PKycStepStatus.pending => AppColors.warn,
    P2PKycStepStatus.rejected => AppColors.sell,
    P2PKycStepStatus.waiting => AppColors.text3,
  };
}

Color _stepBackground(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => AppColors.buy10,
    P2PKycStepStatus.processing => AppColors.primary12,
    P2PKycStepStatus.pending => AppColors.warn10,
    P2PKycStepStatus.rejected => AppColors.sell10,
    P2PKycStepStatus.waiting => AppColors.surface2,
  };
}

IconData _stepIcon(String iconKey) {
  return switch (iconKey) {
    'camera' => Icons.photo_camera_outlined,
    'face' => Icons.center_focus_strong_rounded,
    'shield' => Icons.shield_outlined,
    'upload' => Icons.upload_rounded,
    _ => Icons.description_outlined,
  };
}

IconData _stepStatusIcon(P2PKycStepStatus status) {
  return switch (status) {
    P2PKycStepStatus.completed => Icons.check_circle_outline_rounded,
    P2PKycStepStatus.processing => Icons.sync_rounded,
    P2PKycStepStatus.pending => Icons.schedule_rounded,
    P2PKycStepStatus.rejected => Icons.cancel_outlined,
    P2PKycStepStatus.waiting => Icons.schedule_rounded,
  };
}
