part of 'savings_goal_page.dart';

class _SheetMetric extends StatelessWidget {
  const _SheetMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.earnVerticalPaddingX2,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetHeading extends StatelessWidget {
  const _SheetHeading({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.warn, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _ProgressRing extends StatelessWidget {
  const _ProgressRing({
    required this.progress,
    required this.color,
    required this.size,
    required this.strokeWidth,
    this.centerLabel,
  });

  final double progress;
  final Color color;
  final double size;
  final double strokeWidth;
  final String? centerLabel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size.square(size),
            painter: _ProgressRingPainter(
              progress: progress,
              color: color,
              strokeWidth: strokeWidth,
            ),
          ),
          if (centerLabel != null)
            Text(
              centerLabel!,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
        ],
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  const _ProgressRingPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;
    final track = Paint()
      ..color = AppColors.surface3
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    final active = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0, 1),
      false,
      active,
    );
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalIcon extends StatelessWidget {
  const _GoalIcon({required this.iconKey, required this.color});

  final String iconKey;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Icon(_iconFor(iconKey), color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _MetaItem extends StatelessWidget {
  const _MetaItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.14),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.savingsGoalSheetTitleLineHeight,
          ),
        ),
      ),
    );
  }
}

IconData _iconFor(String iconKey) {
  return switch (iconKey) {
    'house' => Icons.savings_outlined,
    'car' => Icons.paid_outlined,
    'vacation' => Icons.star_border_rounded,
    'education' => Icons.workspace_premium_outlined,
    'emergency' => Icons.error_outline_rounded,
    'sparkles' => Icons.auto_awesome_outlined,
    'trophy' => Icons.emoji_events_outlined,
    _ => Icons.track_changes_rounded,
  };
}

Color _goalColor(SavingsGoalDraft goal) {
  return switch (goal.iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ =>
      goal.status == SavingsGoalStatus.completed
          ? AppColors.primary
          : AppColors.accent,
  };
}

Color _templateColor(String iconKey) {
  return switch (iconKey) {
    'emergency' => AppColors.sell,
    'vacation' => AppColors.warn,
    'education' => AppColors.accent,
    'house' => AppColors.primary,
    'car' => AppColors.buy,
    _ => AppColors.accent,
  };
}

Color _toneColor(EarnRiskLevel tone) {
  return switch (tone) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.accent,
    EarnRiskLevel.high => AppColors.warn,
  };
}

int _daysRemaining(String targetDate) {
  final now = DateTime(2026, 3, 9);
  final target = DateTime.parse(targetDate);
  return math.max(0, target.difference(now).inDays);
}

String _formatDate(String value) {
  final date = DateTime.parse(value);
  return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
