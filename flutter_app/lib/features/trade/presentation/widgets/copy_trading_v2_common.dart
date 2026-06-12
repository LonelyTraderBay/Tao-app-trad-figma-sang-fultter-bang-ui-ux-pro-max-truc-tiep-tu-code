part of '../pages/copy_trading_v2_page.dart';

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .18),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

final class _TierStyle {
  const _TierStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_TierStyle _tierFor(int copiers) {
  if (copiers > 3000) {
    return const _TierStyle(
      label: 'Pro',
      color: AppColors.warn,
      icon: Icons.star_outline_rounded,
    );
  }
  if (copiers > 1000) {
    return const _TierStyle(
      label: 'Verified',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
    );
  }
  return const _TierStyle(
    label: 'Basic',
    color: AppColors.text3,
    icon: Icons.info_outline_rounded,
  );
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value.substring(0, 1).toUpperCase() + value.substring(1);
}

double _sortChipWidth(String label) {
  if (label == 'Top ROI') return 78;
  if (label == 'AUM cao') return 82;
  if (label == 'Nhiều copier') return 108;
  return 106;
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(0)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
