part of '../pages/savings_comparison_page.dart';

class _SelectedProducts extends StatelessWidget {
  const _SelectedProducts({
    required this.selectedProducts,
    required this.selectedCount,
    required this.maxCompare,
    required this.canAdd,
    required this.onRemove,
    required this.onAdd,
  });

  final List<SavingsProductDraft> selectedProducts;
  final int selectedCount;
  final int maxCompare;
  final bool canAdd;
  final ValueChanged<String> onRemove;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsComparisonPage.selectedProductsKey,
      children: [
        for (final product in selectedProducts) ...[
          _ProductChip(product: product, onRemove: () => onRemove(product.id)),
          if (product != selectedProducts.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        if (canAdd) ...[
          if (selectedProducts.isNotEmpty)
            const SizedBox(height: AppSpacing.x3),
          _AddProductButton(
            selectedCount: selectedCount,
            maxCompare: maxCompare,
            onTap: onAdd,
          ),
        ],
      ],
    );
  }
}

class _ProductChip extends StatelessWidget {
  const _ProductChip({required this.product, required this.onRemove});

  final SavingsProductDraft product;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final accent = _assetColor(product.asset);

    return VitCard(
      key: SavingsComparisonPage.productChipKey(product.id),
      variant: VitCardVariant.inner,
      borderColor: accent.withValues(alpha: 0.35),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        children: [
          _AssetBadge(asset: product.asset, color: accent),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          IconButton(
            key: SavingsComparisonPage.removeProductKey(product.id),
            onPressed: onRemove,
            icon: const Icon(
              Icons.close_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddProductButton extends StatelessWidget {
  const _AddProductButton({
    required this.selectedCount,
    required this.maxCompare,
    required this.onTap,
  });

  final int selectedCount;
  final int maxCompare;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.transparent,
      borderRadius: AppRadii.lgRadius,
      child: InkWell(
        key: SavingsComparisonPage.addProductButtonKey,
        onTap: onTap,
        borderRadius: AppRadii.lgRadius,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderSolid),
            borderRadius: AppRadii.lgRadius,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.add_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Thêm sản phẩm ($selectedCount/$maxCompare)',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.products, required this.details});

  final List<SavingsProductDraft> products;
  final Map<String, SavingsComparisonDetailDraft> details;

  @override
  Widget build(BuildContext context) {
    final bestApy = products
        .map((product) => _apyNumber(product.apy))
        .fold<double>(0, (current, value) => value > current ? value : current);
    final lowestMin = products
        .map((product) => details[product.id]?.minAmountValue ?? 0)
        .fold<double>(
          double.infinity,
          (current, value) => value < current ? value : current,
        );

    return VitCard(
      key: SavingsComparisonPage.comparisonTableKey,
      radius: VitCardRadius.lg,
      clip: true,
      child: Column(
        children: [
          _ComparisonHeader(products: products),
          _ComparisonRow(
            label: 'APY',
            highlighted: true,
            values: [
              for (final product in products)
                _ApyValue(product: product, bestApy: bestApy),
            ],
          ),
          _ComparisonRow(
            label: 'Loại',
            values: [
              for (final product in products) _TypeValue(type: product.type),
            ],
          ),
          _ComparisonRow(
            label: 'Kỳ hạn',
            values: [
              for (final product in products)
                Text(
                  product.lockDays == null
                      ? 'Không kỳ hạn'
                      : '${product.lockDays} ngày',
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Tối thiểu',
            highlighted: true,
            values: [
              for (final product in products)
                _MinAmountValue(
                  detail: details[product.id],
                  lowestMin: lowestMin,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Rủi ro',
            values: [
              for (final product in products)
                _RiskValue(
                  risk: details[product.id]?.risk ?? product.riskLevel,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Dung lượng',
            highlighted: true,
            values: [
              for (final product in products)
                _CapacityValue(
                  capacity:
                      details[product.id]?.capacityPercent ??
                      (product.progress * 100).round(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Người tham gia',
            values: [
              for (final product in products)
                _IconTextValue(
                  icon: Icons.group_outlined,
                  label: _formatCount(
                    details[product.id]?.participants,
                    fallback: product.participants,
                  ),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Rút sớm',
            highlighted: true,
            values: [
              for (final product in products)
                _TextMetricValue(
                  label: details[product.id]?.earlyWithdrawal ?? '—',
                  color:
                      details[product.id]?.earlyWithdrawal == 'Bất kỳ lúc nào'
                      ? AppColors.buy
                      : AppColors.warn,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Trả lãi',
            values: [
              for (final product in products)
                Text(
                  details[product.id]?.interestPayout ?? '—',
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Lãi kép',
            values: [
              for (final product in products)
                _BooleanValue(
                  value: details[product.id]?.compounding == 'Tự động',
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Bảo hiểm',
            highlighted: true,
            values: [
              for (final product in products)
                _BooleanValue(
                  value: details[product.id]?.insurance ?? false,
                  icon: Icons.shield_outlined,
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Quota còn lại',
            values: [
              for (final product in products)
                Text(
                  product.remainingQuota,
                  textAlign: TextAlign.center,
                  style: _cellStyle(),
                ),
            ],
          ),
          _ComparisonRow(
            label: 'Tổng đã ký',
            highlighted: true,
            isLast: true,
            values: [
              for (final product in products)
                Text(
                  product.totalSubscribed,
                  textAlign: TextAlign.center,
                  style: _cellStyle(fontWeight: AppTextStyles.bold),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComparisonHeader extends StatelessWidget {
  const _ComparisonHeader({required this.products});

  final List<SavingsProductDraft> products;

  @override
  Widget build(BuildContext context) {
    return _ComparisonRowShell(
      highlighted: true,
      label: const Icon(
        Icons.compare_arrows_rounded,
        color: AppColors.text3,
        size: AppSpacing.iconSm,
      ),
      values: [
        for (final product in products)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AssetBadge(
                asset: product.asset,
                color: _assetColor(product.asset),
              ),
              const SizedBox(height: AppSpacing.x2),
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

class _ComparisonRow extends StatelessWidget {
  const _ComparisonRow({
    required this.label,
    required this.values,
    this.highlighted = false,
    this.isLast = false,
  });

  final String label;
  final List<Widget> values;
  final bool highlighted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _ComparisonRowShell(
      highlighted: highlighted,
      isLast: isLast,
      label: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: AppColors.text3,
          fontWeight: AppTextStyles.bold,
        ),
      ),
      values: values,
    );
  }
}

class _ComparisonRowShell extends StatelessWidget {
  const _ComparisonRowShell({
    required this.label,
    required this.values,
    this.highlighted = false,
    this.isLast = false,
  });

  final Widget label;
  final List<Widget> values;
  final bool highlighted;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: highlighted ? AppColors.surface2 : AppColors.transparent,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              width: AppSpacing.buttonHero + AppSpacing.x4,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Align(alignment: Alignment.centerLeft, child: label),
              ),
            ),
            for (final value in values)
              Expanded(
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    border: Border(left: BorderSide(color: AppColors.divider)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.x3),
                    child: Center(child: value),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
