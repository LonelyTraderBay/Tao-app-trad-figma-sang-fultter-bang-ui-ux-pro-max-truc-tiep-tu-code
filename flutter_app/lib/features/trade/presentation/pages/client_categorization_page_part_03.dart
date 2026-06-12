part of 'client_categorization_page.dart';

class _QuickLinkButton extends StatelessWidget {
  const _QuickLinkButton({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      variant: VitCardVariant.inner,
      borderColor: _clientBorder.withValues(alpha: .72),
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: 17,
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: 49,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({
    required this.style,
    required this.size,
    required this.iconSize,
  });

  final _CategoryStyle style;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.color.withValues(alpha: .13),
          borderRadius: size >= 52
              ? AppRadii.cardLargeRadius
              : AppRadii.cardRadius,
        ),
        child: Icon(style.icon, color: style.color, size: iconSize),
      ),
    );
  }
}

class _CurrentPill extends StatelessWidget {
  const _CurrentPill({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      label: 'CURRENT',
      status: color == _clientAmber
          ? VitStatusPillStatus.warning
          : color == _clientPrimary
          ? VitStatusPillStatus.info
          : VitStatusPillStatus.success,
      size: VitStatusPillSize.sm,
    );
  }
}

class _CategoryStyle {
  const _CategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

_CategoryStyle _categoryStyle(String id) {
  return switch (id) {
    'professional' => const _CategoryStyle(
      color: _clientPrimary,
      icon: Icons.workspace_premium_outlined,
    ),
    'ecp' => const _CategoryStyle(
      color: _clientAmber,
      icon: Icons.lock_outline,
    ),
    _ => const _CategoryStyle(color: _clientGreen, icon: Icons.person_outline),
  };
}

String _historyActionLabel(String action) {
  return switch (action) {
    'opt-up-requested' => 'Opt-Up Requested',
    'opt-up-approved' => 'Opt-Up Approved',
    'opt-down' => 'Opted Down',
    _ => 'Initial Categorization',
  };
}

String _formatHistoryDate(String date) {
  return switch (date) {
    '2026-03-08' => 'March 8, 2026',
    '2025-12-15' => 'December 15, 2025',
    _ => date,
  };
}
