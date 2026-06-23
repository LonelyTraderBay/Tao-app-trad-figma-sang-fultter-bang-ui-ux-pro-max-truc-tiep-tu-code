part of '../pages/p2p_kyc_status_page.dart';

class _OverallStatusCard extends StatelessWidget {
  const _OverallStatusCard({required this.snapshot});

  final P2PKycStatusSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PKycStatusPage.statusCardKey,
      radius: VitCardRadius.lg,
      padding: _p2pKycCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: AppSpacing.buttonCompact,
                height: AppSpacing.buttonCompact,
                child: Material(
                  color: AppColors.primary15,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.lgRadius,
                    side: const BorderSide(color: AppColors.primary20),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield_outlined,
                      color: AppModuleAccents.p2p,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tier ${snapshot.tier} - ${snapshot.tierName}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.sectionTitle,
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
          const SizedBox(height: _p2pKycSectionGap),
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
          const SizedBox(height: _p2pKycTightGap),
          _ProgressTrack(value: snapshot.progress),
          const SizedBox(height: _p2pKycSectionGap),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            borderColor: AppColors.primary20,
            padding: _p2pKycNoticePadding,
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
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.p2pKycReadableLineHeight,
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
          return SizedBox(
            height: AppSpacing.x2,
            child: ColoredBox(
              color: AppColors.surface3,
              child: Align(
                alignment: Alignment.centerLeft,
                child: TweenAnimationBuilder<double>(
                  tween: Tween<double>(end: value.clamp(0, 1).toDouble()),
                  duration: const Duration(milliseconds: 220),
                  builder: (context, animatedValue, child) {
                    return SizedBox(
                      width: constraints.maxWidth * animatedValue,
                      height: AppSpacing.x2,
                      child: child,
                    );
                  },
                  child: const ColoredBox(color: AppModuleAccents.p2p),
                ),
              ),
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
      padding: _p2pKycNoticePadding,
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
            width: AppSpacing.buttonCompact,
            child: Column(
              children: [
                SizedBox(
                  width: AppSpacing.buttonCompact,
                  height: AppSpacing.buttonCompact,
                  child: Material(
                    color: _stepBackground(step.status),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.lgRadius,
                      side: BorderSide(
                        color: color,
                        width: AppSpacing.p2pKycTimelineNodeBorder,
                      ),
                    ),
                    child: Icon(
                      _stepIcon(step.iconKey),
                      color: color,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: SizedBox(
                      width: AppSpacing.p2pKycTimelineLineWidth,
                      child: ColoredBox(
                        color: step.status == P2PKycStepStatus.completed
                            ? AppColors.buy
                            : AppColors.borderSolid,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Padding(
              padding: isLast
                  ? AppSpacing.zeroInsets
                  : _p2pKycTimelineRowPadding,
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
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.baseMedium.copyWith(
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(height: _p2pKycTightGap),
                            Text(
                              step.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
                    const SizedBox(height: _p2pKycTightGap),
                    _StepMeta(
                      icon: Icons.check_circle_outline_rounded,
                      color: AppColors.text3,
                      text: 'Hoàn thành lúc ${step.completedAt}',
                    ),
                  ],
                  if (step.status == P2PKycStepStatus.processing &&
                      step.estimatedTime != null) ...[
                    const SizedBox(height: _p2pKycTightGap),
                    _StepMeta(
                      icon: Icons.schedule_rounded,
                      color: AppModuleAccents.p2p,
                      text: 'Ước tính: ${step.estimatedTime}',
                    ),
                  ],
                  if (step.status == P2PKycStepStatus.waiting &&
                      !step.hasAction &&
                      step.estimatedTime != null) ...[
                    const SizedBox(height: _p2pKycTightGap),
                    _StepMeta(
                      icon: Icons.schedule_rounded,
                      color: AppColors.text3,
                      text: 'Thời gian xử lý: ${step.estimatedTime}',
                    ),
                  ],
                  if (step.hasAction) ...[
                    const SizedBox(height: _p2pKycTightGap),
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
        Icon(icon, color: color, size: AppSpacing.p2pKycTimelineMetaIcon),
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
    return VitCtaButton(
      key: P2PKycStatusPage.actionKey(step.id),
      onPressed: () {
        HapticFeedback.selectionClick();
        context.go(step.actionRoute!);
      },
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      padding: AppSpacing.p2pKycInlineActionPadding,
      trailing: const Icon(Icons.chevron_right_rounded),
      child: Text(step.actionLabel!),
    );
  }
}
