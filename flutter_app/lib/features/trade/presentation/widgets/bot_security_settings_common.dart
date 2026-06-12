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
    return VitCard(
      height: 46,
      alignment: Alignment.center,
      borderColor: _securityPrimary.withValues(alpha: .72),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _securityPrimary, size: 18),
          const SizedBox(width: 9),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: _securityPrimary,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
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
      borderRadius: AppRadii.cardLargeRadius,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        width: 48,
        height: 24,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: enabled ? _securityGreen : _securityPanel2,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: Align(
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.onAccent,
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 20, height: 20),
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
    return VitCard(constraints: constraints, padding: padding, child: child);
  }
}
