import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class SavingsComparisonPage extends ConsumerStatefulWidget {
  const SavingsComparisonPage({super.key, this.shellRenderMode});

  static const selectedProductsKey = Key('sc340_selected_products');
  static const comparisonTableKey = Key('sc340_comparison_table');
  static const addProductButtonKey = Key('sc340_add_product_button');
  static const emptyStateKey = Key('sc340_empty_state');
  static const disclaimerKey = Key('sc340_disclaimer');

  static Key productChipKey(String productId) => Key('sc340_chip_$productId');
  static Key removeProductKey(String productId) =>
      Key('sc340_remove_$productId');
  static Key pickerOptionKey(String productId) =>
      Key('sc340_picker_$productId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsComparisonPage> createState() =>
      _SavingsComparisonPageState();
}

class _SavingsComparisonPageState extends ConsumerState<SavingsComparisonPage> {
  List<String>? _selectedIds;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsComparisonRepositoryProvider)
        .getComparison();
    final selectedIds = _selectedIds ?? snapshot.defaultProductIds;
    final selectedProducts = _selectedProducts(snapshot, selectedIds);
    final availableProducts = snapshot.products
        .where((product) => !selectedIds.contains(product.id))
        .toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-340 SavingsComparisonPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    VitPageSection(
                      label: 'Sản phẩm đã chọn',
                      accentColor: AppColors.primary,
                      children: [
                        _SelectedProducts(
                          selectedProducts: selectedProducts,
                          selectedCount: selectedIds.length,
                          maxCompare: snapshot.maxCompare,
                          canAdd: selectedIds.length < snapshot.maxCompare,
                          onRemove: _removeProduct,
                          onAdd: () => _openPicker(
                            snapshot,
                            availableProducts,
                            selectedIds.length,
                          ),
                        ),
                      ],
                    ),
                    if (selectedProducts.length >= 2) ...[
                      VitPageSection(
                        label: 'So sánh chi tiết',
                        accentColor: AppColors.buy,
                        children: [
                          _ComparisonTable(
                            products: selectedProducts,
                            details: snapshot.details,
                          ),
                        ],
                      ),
                      VitPageSection(
                        label: 'Tính năng nổi bật',
                        accentColor: AppColors.accent,
                        children: [
                          for (final product in selectedProducts)
                            _FeatureCard(
                              product: product,
                              detail: snapshot.details[product.id],
                            ),
                        ],
                      ),
                    ] else
                      _EmptyComparisonState(
                        onAdd: () => _openPicker(
                          snapshot,
                          availableProducts,
                          selectedIds.length,
                        ),
                      ),
                    _Disclaimer(text: snapshot.disclaimer),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<SavingsProductDraft> _selectedProducts(
    SavingsComparisonSnapshot snapshot,
    List<String> selectedIds,
  ) {
    return [
      for (final id in selectedIds)
        for (final product in snapshot.products)
          if (product.id == id) product,
    ];
  }

  void _removeProduct(String productId) {
    HapticFeedback.selectionClick();
    setState(() {
      final selectedIds = List<String>.of(_selectedIds ?? const []);
      final baseline = selectedIds.isEmpty
          ? ref
                .read(savingsComparisonRepositoryProvider)
                .getComparison()
                .defaultProductIds
          : selectedIds;
      _selectedIds = baseline.where((id) => id != productId).toList();
    });
  }

  Future<void> _openPicker(
    SavingsComparisonSnapshot snapshot,
    List<SavingsProductDraft> availableProducts,
    int selectedCount,
  ) async {
    HapticFeedback.selectionClick();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.72,
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadii.xl),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x5,
                  AppSpacing.contentPad,
                  AppSpacing.x6,
                ),
                child: _ProductPickerSheet(
                  availableProducts: availableProducts,
                  selectedCount: selectedCount,
                  maxCompare: snapshot.maxCompare,
                  onAdd: _addProduct,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _addProduct(String productId) {
    HapticFeedback.selectionClick();
    setState(() {
      final baseline =
          _selectedIds ??
          ref
              .read(savingsComparisonRepositoryProvider)
              .getComparison()
              .defaultProductIds;
      if (baseline.contains(productId)) return;
      _selectedIds = [...baseline, productId];
    });
    Navigator.of(context).pop();
  }
}

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
      color: Colors.transparent,
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
        color: highlighted ? AppColors.surface2 : Colors.transparent,
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

class _ApyValue extends StatelessWidget {
  const _ApyValue({required this.product, required this.bestApy});

  final SavingsProductDraft product;
  final double bestApy;

  @override
  Widget build(BuildContext context) {
    final apy = _apyNumber(product.apy);
    final best = apy == bestApy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          product.apy,
          style: AppTextStyles.baseMedium.copyWith(
            color: best ? AppColors.buy : AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        if (best) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            'Cao nhất',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
        if (product.maxApy != null) ...[
          const SizedBox(height: AppSpacing.x1),
          Text(
            product.maxApy!,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.warn,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ],
    );
  }
}

class _TypeValue extends StatelessWidget {
  const _TypeValue({required this.type});

  final SavingsProductType type;

  @override
  Widget build(BuildContext context) {
    final flexible = type == SavingsProductType.flexible;
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            flexible ? Icons.lock_open_rounded : Icons.lock_outline_rounded,
            color: flexible ? AppColors.buy : AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x1),
          Text(flexible ? 'Linh hoạt' : 'Cố định', style: _cellStyle()),
        ],
      ),
    );
  }
}

class _MinAmountValue extends StatelessWidget {
  const _MinAmountValue({required this.detail, required this.lowestMin});

  final SavingsComparisonDetailDraft? detail;
  final double lowestMin;

  @override
  Widget build(BuildContext context) {
    final isLowest = detail != null && detail!.minAmountValue == lowestMin;
    return Text(
      detail?.minAmount ?? '—',
      textAlign: TextAlign.center,
      style: _cellStyle(
        color: isLowest ? AppColors.buy : AppColors.text1,
        fontWeight: isLowest ? AppTextStyles.bold : AppTextStyles.medium,
      ),
    );
  }
}

class _RiskValue extends StatelessWidget {
  const _RiskValue({required this.risk});

  final EarnRiskLevel risk;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(risk);
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shield_outlined, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x1),
          Text(
            _riskLabel(risk),
            style: _cellStyle(color: color, fontWeight: AppTextStyles.bold),
          ),
        ],
      ),
    );
  }
}

class _CapacityValue extends StatelessWidget {
  const _CapacityValue({required this.capacity});

  final int capacity;

  @override
  Widget build(BuildContext context) {
    final color = capacity > 85
        ? AppColors.sell
        : capacity > 60
        ? AppColors.warn
        : AppColors.buy;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: AppRadii.xlRadius,
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (capacity / 100).clamp(0, 1),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          '$capacity% đã đăng ký',
          textAlign: TextAlign.center,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _IconTextValue extends StatelessWidget {
  const _IconTextValue({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x1),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: _cellStyle(),
          ),
        ),
      ],
    );
  }
}

class _TextMetricValue extends StatelessWidget {
  const _TextMetricValue({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.center,
      style: _cellStyle(color: color, fontWeight: AppTextStyles.bold),
    );
  }
}

class _BooleanValue extends StatelessWidget {
  const _BooleanValue({required this.value, this.icon});

  final bool value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Icon(
      value ? (icon ?? Icons.check_rounded) : Icons.close_rounded,
      color: value ? AppColors.buy : AppColors.text3,
      size: AppSpacing.iconSm,
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.product, required this.detail});

  final SavingsProductDraft product;
  final SavingsComparisonDetailDraft? detail;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _AssetBadge(
                asset: product.asset,
                color: _assetColor(product.asset),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  product.name,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final feature in detail?.features ?? const <String>[])
                _TinyPill(
                  label: feature,
                  color: AppColors.buy,
                  icon: Icons.check_rounded,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

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
                height: 1.55,
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
              height: 1,
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
