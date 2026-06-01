part of '../pages/bot_security_settings_page.dart';

class _DashedActionButton extends StatelessWidget {
  const _DashedActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Container(
          height: 46,
          alignment: Alignment.center,
          decoration: BoxDecoration(borderRadius: AppRadii.cardRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: _securityPrimary, size: 18),
              const SizedBox(width: 9),
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: _securityPrimary,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Switch extends StatelessWidget {
  const _Switch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: enabled ? _securityGreen : _securityPanel2,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: AppColors.onAccent,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding, this.constraints});

  final Widget child;
  final EdgeInsetsGeometry padding;
  final BoxConstraints? constraints;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      padding: padding,
      decoration: BoxDecoration(
        color: _securityPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _securityPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = _securityPrimary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final radius = Radius.circular(18);
    final rect = RRect.fromRectAndRadius(
      Offset.zero & size,
      radius,
    ).deflate(.5);
    final path = Path()..addRRect(rect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final segment = metric.extractPath(distance, distance + 4);
        canvas.drawPath(segment, paint);
        distance += 8;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => false;
}
