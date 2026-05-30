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
import 'package:vit_trade_flutter/app/providers/earn_controller_providers.dart';

enum _EarnTab { products, positions }

enum _EarnFilter { all, fixed, flexible, defi }

class StakingEarnPage extends ConsumerStatefulWidget {
  const StakingEarnPage({
    super.key,
    this.shellRenderMode,
    this.route = StakingEarnRoute.earn,
  });

  static const productsTabKey = Key('sc327_tab_products');
  static const positionsTabKey = Key('sc327_tab_positions');
  static const savingsButtonKey = Key('sc327_savings_button');
  static Key filterKey(String filter) => Key('sc327_filter_$filter');
  static Key productKey(String id) => Key('sc327_product_$id');

  final ShellRenderMode? shellRenderMode;
  final StakingEarnRoute route;

  @override
  ConsumerState<StakingEarnPage> createState() => _StakingEarnPageState();
}

class _StakingEarnPageState extends ConsumerState<StakingEarnPage> {
  _EarnTab _tab = _EarnTab.products;
  _EarnFilter _filter = _EarnFilter.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(stakingEarnRepositoryProvider)
        .getStakingEarn(route: widget.route);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final products = _filteredProducts(snapshot.products, _filter);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: widget.route == StakingEarnRoute.earn
          ? 'SC-327 StakingEarnPage'
          : 'SC-328 StakingEarnPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
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
                    _EarnHero(snapshot: snapshot),
                    _MainTabs(
                      activeTab: _tab,
                      positionCount: snapshot.positions.length,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _EarnTab.products) ...[
                      _FilterRow(
                        activeFilter: _filter,
                        onChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = filter);
                        },
                      ),
                      _ProductList(products: products),
                    ] else
                      _PositionsList(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EarnHero extends StatelessWidget {
  const _EarnHero({required this.snapshot});

  final StakingEarnSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tong thu nhap (USD)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.totalEarnedUsd,
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
                        fontSize: 24,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    Text(
                      'Tich luy tu truoc den nay',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              VitCard(
                variant: VitCardVariant.inner,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x5,
                  vertical: AppSpacing.x3,
                ),
                child: Column(
                  children: [
                    Text(
                      '${snapshot.activePositions}',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.buy,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Vi the hoat dong',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroPill(
                  icon: Icons.bolt_rounded,
                  label: snapshot.maxApyLabel,
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  icon: Icons.shield_outlined,
                  label: snapshot.fundProtectionLabel,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroPill(
                  key: StakingEarnPage.savingsButtonKey,
                  icon: Icons.savings_outlined,
                  label: 'Tiet kiem',
                  color: AppColors.text2,
                  onTap: () => context.go(snapshot.savingsRoute),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
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

class _MainTabs extends StatelessWidget {
  const _MainTabs({
    required this.activeTab,
    required this.positionCount,
    required this.onChanged,
  });

  final _EarnTab activeTab;
  final int positionCount;
  final ValueChanged<_EarnTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_EarnTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _EarnTab.products.name,
          label: 'San pham',
          icon: Icons.inventory_2_outlined,
        ),
        VitTabItem(
          key: _EarnTab.positions.name,
          label: 'Cua toi ($positionCount)',
          icon: Icons.business_center_outlined,
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.activeFilter, required this.onChanged});

  final _EarnFilter activeFilter;
  final ValueChanged<_EarnFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in _EarnFilter.values) ...[
            _FilterChip(
              key: StakingEarnPage.filterKey(filter.name),
              filter: filter,
              selected: filter == activeFilter,
              onTap: () => onChanged(filter),
            ),
            if (filter != _EarnFilter.values.last)
              const SizedBox(width: AppSpacing.x1),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _EarnFilter filter;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary12 : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            children: [
              if (_filterIcon(filter) != null) ...[
                Icon(
                  _filterIcon(filter),
                  color: selected ? AppColors.primary : AppColors.text2,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x1),
              ],
              Text(
                _filterLabel(filter),
                style: AppTextStyles.micro.copyWith(
                  color: selected ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  const _ProductList({required this.products});

  final List<EarnProductDraft> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in products) ...[
          _ProductCard(product: product),
          if (product != products.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final EarnProductDraft product;

  @override
  Widget build(BuildContext context) {
    final riskColor = _riskColor(product.riskLevel);
    final accent = _productAccent(product);

    return VitCard(
      key: StakingEarnPage.productKey(product.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AssetBadge(asset: product.asset, color: accent),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        if (product.isHot)
                          const _StatusBadge(
                            label: 'HOT',
                            color: AppColors.sell,
                            background: AppColors.sell10,
                          ),
                        if (product.isNew)
                          const _StatusBadge(
                            label: 'MOI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          _productTypeIcon(product.type),
                          color: _productTypeColor(product.type),
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            '${product.lockLabel} - ${product.participants}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    product.apy,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontSize: 22,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                  if (product.boostApy != null)
                    Text(
                      product.boostApy!,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.warn,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Da staking: ${product.totalStaked}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Rui ro: ${_riskLabel(product.riskLevel)}',
                style: AppTextStyles.micro.copyWith(
                  color: riskColor,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(progress: product.progress, color: accent),
        ],
      ),
    );
  }
}

class _PositionsList extends StatelessWidget {
  const _PositionsList({required this.snapshot});

  final StakingEarnSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in snapshot.positions) ...[
          _PositionCard(position: position),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.x3),
        ],
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: AppColors.buy20,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.trending_up_rounded,
                    color: AppColors.buy,
                    size: AppSpacing.iconMd,
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  Text(
                    'Tong thu nhap uoc tinh',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.x3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final item in snapshot.estimatedIncome)
                    _IncomeEstimate(item: item),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({required this.position});

  final EarnPositionDraft position;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _AssetBadge(
                asset: position.asset,
                color: _productTypeColor(position.type),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.product,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _productTypeLabel(position.type),
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${position.apy} APY',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x2,
            crossAxisSpacing: AppSpacing.x2,
            childAspectRatio: 2.7,
            children: [
              _PositionMetric(label: 'Dang staking', value: position.amount),
              _PositionMetric(
                label: 'Da nhan',
                value: position.earned,
                valueColor: AppColors.buy,
              ),
              _PositionMetric(label: 'Bat dau', value: position.startDate),
              _PositionMetric(
                label: position.endDate == null ? 'Trang thai' : 'Ket thuc',
                value: position.endDate ?? 'Dang hoat dong',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PositionMetric extends StatelessWidget {
  const _PositionMetric({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: valueColor,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IncomeEstimate extends StatelessWidget {
  const _IncomeEstimate({required this.item});

  final EarnIncomeEstimateDraft item;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        Text(
          item.value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
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
        color: AppColors.surface2,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 4 ? asset.substring(0, 4) : asset,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppRadii.xlRadius,
      child: SizedBox(
        height: AppSpacing.x2,
        child: Stack(
          fit: StackFit.expand,
          children: [
            const ColoredBox(color: AppColors.surface3),
            FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress.clamp(0, 1),
              child: ColoredBox(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

List<EarnProductDraft> _filteredProducts(
  List<EarnProductDraft> products,
  _EarnFilter filter,
) {
  return switch (filter) {
    _EarnFilter.all => products,
    _EarnFilter.fixed =>
      products
          .where((product) => product.type == EarnProductType.fixed)
          .toList(),
    _EarnFilter.flexible =>
      products
          .where((product) => product.type == EarnProductType.flexible)
          .toList(),
    _EarnFilter.defi =>
      products
          .where((product) => product.type == EarnProductType.defi)
          .toList(),
  };
}

String _filterLabel(_EarnFilter filter) {
  return switch (filter) {
    _EarnFilter.all => 'Tat ca',
    _EarnFilter.fixed => 'Co dinh',
    _EarnFilter.flexible => 'Linh hoat',
    _EarnFilter.defi => 'DeFi',
  };
}

IconData? _filterIcon(_EarnFilter filter) {
  return switch (filter) {
    _EarnFilter.all => null,
    _EarnFilter.fixed => Icons.lock_outline_rounded,
    _EarnFilter.flexible => Icons.lock_open_rounded,
    _EarnFilter.defi => Icons.bolt_rounded,
  };
}

IconData _productTypeIcon(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => Icons.lock_outline_rounded,
    EarnProductType.flexible => Icons.lock_open_rounded,
    EarnProductType.defi => Icons.bolt_rounded,
  };
}

Color _productTypeColor(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => AppColors.warn,
    EarnProductType.flexible => AppColors.buy,
    EarnProductType.defi => AppColors.primary,
  };
}

String _productTypeLabel(EarnProductType type) {
  return switch (type) {
    EarnProductType.fixed => 'Co dinh',
    EarnProductType.flexible => 'Linh hoat',
    EarnProductType.defi => 'DeFi Pool',
  };
}

Color _productAccent(EarnProductDraft product) {
  return switch (product.riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

Color _riskColor(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

String _riskLabel(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => 'Thap',
    EarnRiskLevel.medium => 'Trung binh',
    EarnRiskLevel.high => 'Cao',
  };
}
