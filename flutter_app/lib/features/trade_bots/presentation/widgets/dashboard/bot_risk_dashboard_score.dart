part of '../../pages/dashboard/bot_risk_dashboard_page.dart';

class _RiskScoreCard extends StatelessWidget {
  const _RiskScoreCard({required this.snapshot});

  final TradeBotRiskDashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(snapshot.riskScore);
    return VitCard(
      radius: VitCardRadius.tight,
      density: VitDensity.tool,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Portfolio Risk Score',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${snapshot.riskScore}/100',
                      style: AppTextStyles.heroNumber.copyWith(color: color),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.riskLabel,
                      style: AppTextStyles.caption.copyWith(
                        color: color,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: LaunchpadSpacingTokens.launchpadBox64,
                height: LaunchpadSpacingTokens.launchpadBox64,
                child: CustomPaint(
                  painter: _RiskRingPainter(
                    percent: snapshot.riskScore / 100,
                    color: color,
                  ),
                  child: Center(
                    child: ClipOval(
                      child: ColoredBox(
                        color: AppColors.surface,
                        child: SizedBox(
                          width: LaunchpadSpacingTokens.launchpadBox56,
                          height: LaunchpadSpacingTokens.launchpadBox56,
                          child: Icon(
                            Icons.shield_outlined,
                            color: color,
                            size: AppSpacing.x6,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          VitCard(
            variant: VitCardVariant.ghost,
            radius: VitCardRadius.tight,
            width: double.infinity,
            density: VitDensity.tool,
            borderColor: color.withValues(alpha: .28),
            child: Text(
              snapshot.riskMessage,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskRingPainter extends CustomPainter {
  const _RiskRingPainter({required this.percent, required this.color});

  final double percent;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = 7.0;
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(stroke / 2);
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = _riskTrack;
    final active = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.butt
      ..color = color;
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2, false, track);
    canvas.drawArc(arcRect, -math.pi / 2, math.pi * 2 * percent, false, active);
  }

  @override
  bool shouldRepaint(covariant _RiskRingPainter oldDelegate) {
    return oldDelegate.percent != percent || oldDelegate.color != color;
  }
}
