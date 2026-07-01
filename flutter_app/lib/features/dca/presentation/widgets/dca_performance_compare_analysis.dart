part of '../pages/dca_performance_compare_page.dart';

class _ProsConsCard extends StatelessWidget {
  const _ProsConsCard.dca()
    : title = 'DCA Strategy',
      color = AppColors.buy,
      pros = const [
        'Lower timing risk',
        'Easier emotionally',
        'Flexible budget',
      ],
      cons = const ['May miss rallies', 'Lower upside'];

  const _ProsConsCard.lumpSum()
    : title = 'Lump Sum',
      color = AppColors.primary,
      pros = const ['Max time in market', 'Higher upside'],
      cons = const ['High timing risk', 'Emotional stress', 'Large capital'];

  final String title;
  final Color color;
  final List<String> pros;
  final List<String> cons;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.dcaPaddingX4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(title: 'Pros', items: pros, icon: Icons.check_rounded),
          const SizedBox(height: AppSpacing.x4),
          _ProsConsList(
            title: 'Cons',
            items: cons,
            icon: Icons.warning_amber_rounded,
            warning: true,
          ),
        ],
      ),
    );
  }
}

class _ProsConsList extends StatelessWidget {
  const _ProsConsList({
    required this.title,
    required this.items,
    required this.icon,
    this.warning = false,
  });

  final String title;
  final List<String> items;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x2),
        for (final item in items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: warning ? AppColors.warn : AppColors.buy,
                size: AppSpacing.dcaPerformanceCompareSmallIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  item,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          if (item != items.last) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.text,
  });

  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: AppColors.primary20,
      padding: AppSpacing.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: AppColors.primary,
            size: AppSpacing.dcaPerformanceCompareInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  text,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: AppColors.warningBorder,
      padding: AppSpacing.dcaPaddingX4,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.warn,
            size: AppSpacing.dcaPerformanceCompareInlineIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}
