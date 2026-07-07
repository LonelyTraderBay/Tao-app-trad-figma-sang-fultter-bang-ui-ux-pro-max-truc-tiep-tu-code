part of '../pages/savings_faq_page.dart';

class _FeedbackPill extends StatelessWidget {
  const _FeedbackPill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: 0.10),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.smRadius),
      ),
      child: Padding(
        padding: EarnSpacingTokens.earnSmallPillPadding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Column(
        children: [
          const Icon(
            Icons.search_off_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Text('Không tìm thấy câu hỏi', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thử từ khóa khác hoặc đổi danh mục',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            onPressed: onReset,
            child: const Text('Xóa bộ lọc'),
          ),
        ],
      ),
    );
  }
}

class _SupportCard extends StatelessWidget {
  const _SupportCard({required this.snapshot});

  final SavingsFAQSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.large,
      padding: EarnSpacingTokens.earnCardPaddingX3,
      child: Row(
        children: [
          const _QuestionIcon(color: AppColors.primary),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.supportTitle, style: AppTextStyles.baseMedium),
                Text(
                  snapshot.supportSubtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          VitCtaButton(
            key: SavingsFAQPage.supportButtonKey,
            fullWidth: false,
            height: AppSpacing.buttonCompact,
            padding: EarnSpacingTokens.earnHorizontalPaddingX3,
            onPressed: () {
              HapticFeedback.selectionClick();
              context.go(snapshot.supportRoute);
            },
            trailing: const Icon(Icons.open_in_new_rounded),
            child: const Text('Liên hệ'),
          ),
        ],
      ),
    );
  }
}

List<SavingsFAQItemDraft> _filteredItems(
  List<SavingsFAQItemDraft> items,
  SavingsFAQCategory? category,
  String query,
) {
  final normalized = query.trim().toLowerCase();
  return [
    for (final item in items)
      if ((category == null || item.category == category) &&
          (normalized.isEmpty ||
              item.question.toLowerCase().contains(normalized) ||
              item.answer.toLowerCase().contains(normalized)))
        item,
  ];
}

Map<String, int> _categoryCounts(List<SavingsFAQItemDraft> items) {
  final counts = <String, int>{'all': items.length};
  for (final category in SavingsFAQCategory.values) {
    counts[category.name] = items
        .where((item) => item.category == category)
        .length;
  }
  return counts;
}

Color _categoryColor(SavingsFAQCategory category) {
  return switch (category) {
    SavingsFAQCategory.general => AppColors.primary,
    SavingsFAQCategory.products => AppColors.buy,
    SavingsFAQCategory.operations => AppColors.accent,
    SavingsFAQCategory.fees => AppColors.warn,
    SavingsFAQCategory.risks => AppColors.sell,
  };
}
