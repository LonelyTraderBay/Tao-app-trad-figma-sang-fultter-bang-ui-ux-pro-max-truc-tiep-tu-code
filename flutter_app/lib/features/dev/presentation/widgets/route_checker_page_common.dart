part of '../pages/route_checker_page.dart';

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.testedCount,
    required this.totalCount,
    required this.onReset,
  });

  final int testedCount;
  final int totalCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final complete = testedCount == totalCount;

    return Row(
      children: [
        Expanded(
          child: VitCtaButton(
            key: RouteChecker.resetButtonKey,
            onPressed: onReset,
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            padding: AppSpacing.devVerticalPaddingX4,
            child: const Text('Reset Tests', textAlign: TextAlign.center),
          ),
        ),
        if (complete) ...[
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: DecoratedBox(
              decoration: const ShapeDecoration(
                color: AppColors.buy10,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadii.inputRadius,
                ),
              ),
              child: Padding(
                padding: AppSpacing.devVerticalPaddingX4,
                child: Text(
                  'All Routes Tested',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhaseStats extends StatelessWidget {
  const _PhaseStats({required this.snapshot, required this.testedRoutes});

  final RouteCheckerSnapshot snapshot;
  final Set<String> testedRoutes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats by Phase',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            crossAxisCount: AppSpacing.devRouteGridColumns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: AppSpacing.devRouteGridAspect,
            children: [
              for (final phase in snapshot.phases)
                _PhaseStatTile(
                  phase: phase,
                  total: snapshot.phaseTotal(phase),
                  tested: snapshot.routes
                      .where(
                        (route) =>
                            route.phase == phase &&
                            testedRoutes.contains(route.path),
                      )
                      .length,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseStatTile extends StatelessWidget {
  const _PhaseStatTile({
    required this.phase,
    required this.total,
    required this.tested,
  });

  final int phase;
  final int total;
  final int tested;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : tested / total;

    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.surface2,
        shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
      ),
      child: Padding(
        padding: AppSpacing.devTinyPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phase $phase',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '$tested/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.bg,
                child: SizedBox(
                  height: AppSpacing.x1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      child: const ColoredBox(color: AppColors.buy),
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

class _InternalNotice extends StatelessWidget {
  const _InternalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: AppColors.primary08,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadii.cardRadius,
          side: BorderSide(color: AppColors.primary20),
        ),
      ),
      child: Padding(
        padding: AppSpacing.devCompactPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.admin_panel_settings_outlined,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.x6,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: background,
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}
