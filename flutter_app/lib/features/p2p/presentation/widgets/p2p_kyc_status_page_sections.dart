part of '../pages/p2p_kyc_status_page.dart';

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
