part of '../pages/p2p_insurance_score_page.dart';

class _ScoreOverviewCard extends StatelessWidget {
  const _ScoreOverviewCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.scoreCardKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: Column(
        children: [
          _ScoreRing(snapshot: snapshot),
          const SizedBox(height: AppSpacing.x4),
          Text(
            snapshot.gradeLabel,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppModuleAccents.p2p,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            snapshot.gradeDescription,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.lg,
            borderColor: AppColors.buy20,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.trending_up_rounded,
                  color: AppColors.buy,
                  size: 16,
                ),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '+${snapshot.potentialGain} điểm có thể cải thiện',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
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

class _ScoreRing extends StatelessWidget {
  const _ScoreRing({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final progress = snapshot.overallScore / snapshot.maxScore;
    return SizedBox(
      width: 160,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 150,
            height: 150,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              backgroundColor: AppColors.surface3,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppModuleAccents.p2p,
              ),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${snapshot.overallScore}',
                style: AppTextStyles.display.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                '/ ${snapshot.maxScore}',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                snapshot.grade,
                style: AppTextStyles.caption.copyWith(
                  color: AppModuleAccents.p2p,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FactorBreakdownCard extends StatelessWidget {
  const _FactorBreakdownCard({required this.snapshot});

  final P2PInsuranceScoreSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PInsuranceScorePage.factorsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.track_changes_rounded,
                color: AppColors.text2,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Chi tiết điểm số',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          for (var i = 0; i < snapshot.factors.length; i++) ...[
            _ScoreFactorRow(factor: snapshot.factors[i]),
            if (i != snapshot.factors.length - 1)
              const Divider(height: AppSpacing.x6, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _ScoreFactorRow extends StatelessWidget {
  const _ScoreFactorRow({required this.factor});

  final P2PInsuranceScoreFactorDraft factor;

  @override
  Widget build(BuildContext context) {
    final color = _toneColor(factor.toneKey);
    final progress = factor.score / factor.maxScore;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: AppRadii.mdRadius,
              ),
              child: Icon(_iconFor(factor.iconKey), color: color, size: 17),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    factor.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    factor.description,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '${factor.score}',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: color,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  TextSpan(
                    text: '/${factor.maxScore}',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Padding(
          padding: const EdgeInsets.only(left: 46),
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: AppRadii.xsRadius,
                  child: SizedBox(
                    height: 5,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const ColoredBox(color: AppColors.surface3),
                        FractionallySizedBox(
                          widthFactor: progress,
                          alignment: Alignment.centerLeft,
                          child: ColoredBox(color: color),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              SizedBox(
                width: 62,
                child: Text(
                  factor.statusLabel,
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (factor.recommendation != null) ...[
          const SizedBox(height: AppSpacing.x3),
          Padding(
            padding: const EdgeInsets.only(left: 46),
            child: VitCard(
              variant: VitCardVariant.inner,
              radius: VitCardRadius.sm,
              padding: const EdgeInsets.all(AppSpacing.x3),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.bolt_rounded, color: color, size: 14),
                  const SizedBox(width: AppSpacing.x2),
                  Expanded(
                    child: Text(
                      factor.recommendation!,
                      style: AppTextStyles.micro.copyWith(
                        color: color,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({required this.actions});

  final List<P2PInsuranceScoreQuickActionDraft> actions;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.north_east_rounded,
                color: AppColors.buy,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Cải thiện nhanh',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final action in actions) ...[
            _QuickActionRow(action: action),
            const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}
