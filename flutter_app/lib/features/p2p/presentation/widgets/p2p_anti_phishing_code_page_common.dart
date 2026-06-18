part of '../pages/p2p_anti_phishing_code_page.dart';

class _SoftActionButton extends StatelessWidget {
  const _SoftActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: color == AppColors.text1 ? .08 : .12),
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: AppSpacing.p2pSecurityDetailsActionPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction({super.key, required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: AppSpacing.p2pSecurityDetailsIconActionBox,
      child: IconButton(
        onPressed: onTap,
        padding: AppSpacing.zeroInsets,
        icon: Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
      ),
    );
  }
}
