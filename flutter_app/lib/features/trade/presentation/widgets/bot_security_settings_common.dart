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
      height: AppSpacing.tradeBotControlHeight,
      alignment: Alignment.center,
      borderColor: _securityPrimary.withValues(alpha: .72),
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _securityPrimary, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x3),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: _securityPrimary,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.tradeBotLineHeightTight,
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
      child: VitTogglePill(
        enabled: enabled,
        activeColor: _securityGreen,
        inactiveColor: _securityPanel2,
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
