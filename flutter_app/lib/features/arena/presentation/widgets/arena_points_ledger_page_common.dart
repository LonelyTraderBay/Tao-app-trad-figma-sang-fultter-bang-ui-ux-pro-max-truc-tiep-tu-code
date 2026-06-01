part of '../pages/arena_points_ledger_page.dart';

class _CommunityRulesButton extends StatelessWidget {
  const _CommunityRulesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaPointsLedgerPage.communityRulesKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Quy tắc cộng đồng',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _entryColor(String typeId) {
  return switch (typeId) {
    'earned' => AppColors.buy,
    'spent' => AppColors.sell,
    'entry' => AppColors.warn,
    'settlement' => AppColors.accent,
    'refund' => AppColors.primary,
    'adjustment' => AppColors.text3,
    _ => AppColors.text2,
  };
}

Color _entryTint(String typeId) {
  return switch (typeId) {
    'earned' => AppColors.buy10,
    'spent' => AppColors.sell10,
    'entry' => AppColors.warn10,
    'settlement' => AppColors.accent12,
    'refund' => AppColors.primary12,
    _ => AppColors.surface3,
  };
}

Color _amountColor(int amount) {
  if (amount > 0) return AppColors.buy;
  if (amount < 0) return AppColors.sell;
  return AppColors.text3;
}

IconData _entryIcon(String typeId) {
  return switch (typeId) {
    'earned' => Icons.trending_up_rounded,
    'spent' => Icons.trending_down_rounded,
    'entry' => Icons.sync_alt_rounded,
    'settlement' => Icons.shield_outlined,
    'refund' => Icons.history_rounded,
    'adjustment' => Icons.tune_rounded,
    _ => Icons.receipt_long_outlined,
  };
}

String _amountLabel(int amount) {
  if (amount > 0) return '+${formatArenaPoints(amount)}';
  if (amount < 0) return formatArenaPoints(amount.abs());
  return '0';
}
