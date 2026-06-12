part of '../pages/savings_comparison_page.dart';

class _ProductPickerSheet extends StatelessWidget {
  const _ProductPickerSheet({
    required this.availableProducts,
    required this.selectedCount,
    required this.maxCompare,
    required this.onAdd,
  });

  final List<SavingsProductDraft> availableProducts;
  final int selectedCount;
  final int maxCompare;
  final ValueChanged<String> onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Chọn sản phẩm so sánh',
                style: AppTextStyles.sectionTitle,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.close_rounded, color: AppColors.text3),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          'Đã chọn $selectedCount/$maxCompare sản phẩm',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        if (availableProducts.isEmpty)
          VitCard(
            variant: VitCardVariant.inner,
            padding: const EdgeInsets.all(AppSpacing.x5),
            child: Text(
              'Đã chọn hết sản phẩm',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          )
        else
          for (final product in availableProducts) ...[
            _PickerProductTile(
              product: product,
              onTap: () => onAdd(product.id),
            ),
            if (product != availableProducts.last)
              const SizedBox(height: AppSpacing.x3),
          ],
      ],
    );
  }
}

class _PickerProductTile extends StatelessWidget {
  const _PickerProductTile({required this.product, required this.onTap});

  final SavingsProductDraft product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsComparisonPage.pickerOptionKey(product.id),
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: _assetColor(product.asset)),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${product.type == SavingsProductType.flexible ? 'Linh hoạt' : 'Cố định ${product.lockDays} ngày'} - ${product.apy} APY',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.add_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _EmptyComparisonState extends StatelessWidget {
  const _EmptyComparisonState({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsComparisonPage.emptyStateKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.compare_arrows_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text('Chọn ít nhất 2 sản phẩm', style: AppTextStyles.baseMedium),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Thêm sản phẩm để bắt đầu so sánh chi tiết các chỉ số',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            variant: VitCtaButtonVariant.secondary,
            height: AppSpacing.buttonCompact,
            fullWidth: false,
            leading: const Icon(Icons.add_rounded),
            onPressed: onAdd,
            child: const Text('Thêm sản phẩm'),
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SavingsComparisonPage.disclaimerKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.primary20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.primary,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: AppSpacing.savingsConsumerBodyLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
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

class _AssetBadge extends StatelessWidget {
  const _AssetBadge({required this.asset, required this.color});

  final String asset;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color.withValues(alpha: 0.25)),
        borderRadius: AppRadii.xlRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x5,
        height: AppSpacing.x5,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: AppSpacing.savingsConsumerPillLineHeight,
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _cellStyle({
  Color color = AppColors.text1,
  FontWeight fontWeight = AppTextStyles.medium,
}) {
  return AppTextStyles.caption.copyWith(
    color: color,
    fontWeight: fontWeight,
    fontFeatures: AppTextStyles.tabularFigures,
  );
}

double _apyNumber(String value) {
  return double.tryParse(value.replaceAll('%', '')) ?? 0;
}

String _formatCount(int? value, {required String fallback}) {
  if (value == null) return fallback;
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}

Color _assetColor(String asset) {
  return switch (asset) {
    'USDT' => AppColors.buy,
    'BTC' => AppColors.warn,
    'SOL' => AppColors.accent,
    'ETH' => AppColors.primary,
    _ => AppColors.primary,
  };
}

String _riskLabel(EarnRiskLevel risk) {
  return switch (risk) {
    EarnRiskLevel.low => 'Thấp',
    EarnRiskLevel.medium => 'Trung bình',
    EarnRiskLevel.high => 'Cao',
  };
}

Color _riskColor(EarnRiskLevel risk) {
  return switch (risk) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}
