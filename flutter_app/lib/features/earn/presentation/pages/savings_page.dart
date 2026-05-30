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

enum _SavingsTab { products, my }

enum _SavingsFilter { all, flexible, locked }

class SavingsPage extends ConsumerStatefulWidget {
  const SavingsPage({super.key, this.shellRenderMode});

  static const productsTabKey = Key('sc329_tab_products');
  static const myTabKey = Key('sc329_tab_my');
  static const portfolioButtonKey = Key('sc329_portfolio_button');
  static const productDetailButtonKey = Key('sc329_product_detail_button');
  static const guideButtonKey = Key('sc329_guide_button');
  static const exportButtonKey = Key('sc329_export_button');
  static const dcaInsightKey = Key('sc329_dca_insight');
  static const exportInsightKey = Key('sc329_export_insight');
  static const backtestInsightKey = Key('sc329_backtest_insight');
  static const autopilotInsightKey = Key('sc329_autopilot_insight');
  static const ladderInsightKey = Key('sc329_ladder_insight');
  static const whatIfInsightKey = Key('sc329_whatif_insight');
  static const smartSuggestionsInsightKey = Key(
    'sc329_smart_suggestions_insight',
  );
  static Key filterKey(String filter) => Key('sc329_filter_$filter');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsPage> createState() => _SavingsPageState();
}

class _SavingsPageState extends ConsumerState<SavingsPage> {
  _SavingsTab _tab = _SavingsTab.products;
  _SavingsFilter _filter = _SavingsFilter.all;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(savingsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final products = _filteredProducts(controller, _filter);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-329 SavingsPage',
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
                    _SavingsHero(snapshot: snapshot),
                    _InsightList(insights: snapshot.insights),
                    _ToolboxButton(
                      guideRoute: snapshot.guideRoute,
                      exportRoute: snapshot.exportRoute,
                    ),
                    _SavingsTabs(
                      activeTab: _tab,
                      positionCount: snapshot.positions.length,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (_tab == _SavingsTab.products) ...[
                      _SavingsFilters(
                        activeFilter: _filter,
                        onChanged: (filter) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = filter);
                        },
                      ),
                      _SavingsProductList(
                        products: products,
                        detailRoute: snapshot.productDetailRoute,
                      ),
                    ] else
                      _SavingsPositions(positions: snapshot.positions),
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

class _SavingsHero extends StatelessWidget {
  const _SavingsHero({required this.snapshot});

  final SavingsSnapshot snapshot;

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
                      'Tổng tiền gửi (USD)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      snapshot.totalDepositedUsd,
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: 26,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        DecoratedBox(
                          decoration: const BoxDecoration(
                            color: AppColors.buy10,
                            borderRadius: AppRadii.xlRadius,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.x3,
                              vertical: AppSpacing.x1,
                            ),
                            child: Text(
                              snapshot.gainLabel,
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.buy,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          'lãi tích lũy',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                key: SavingsPage.portfolioButtonKey,
                onPressed: () => context.go(snapshot.portfolioRoute),
                icon: const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: AppColors.text2,
                  size: AppSpacing.iconMd,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _HeroAction(
                  label: 'Danh mục',
                  icon: Icons.wallet_outlined,
                  primary: true,
                  onTap: () => context.go(snapshot.portfolioRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Gửi',
                  icon: Icons.arrow_downward_rounded,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroAction(
                  label: 'Rút',
                  icon: Icons.arrow_upward_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroAction extends StatelessWidget {
  const _HeroAction({
    required this.label,
    required this.icon,
    this.primary = false,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final bool primary;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primary ? AppColors.primary : AppColors.surface2,
      borderRadius: AppRadii.mdRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: primary ? AppColors.navCenterIcon : AppColors.text1,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: primary ? AppColors.navCenterIcon : AppColors.text1,
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

class _InsightList extends StatelessWidget {
  const _InsightList({required this.insights});

  final List<SavingsInsightDraft> insights;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final insight in insights) ...[
          VitCard(
            key: _insightKey(insight.route),
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            onTap: insight.route == null
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    context.go(insight.route!);
                  },
            child: Row(
              children: [
                _RoundIcon(tone: insight.tone),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        insight.title,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      Text(
                        insight.subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: AppColors.text3,
                  size: AppSpacing.iconMd,
                ),
              ],
            ),
          ),
          if (insight != insights.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }

  Key? _insightKey(String? route) {
    return switch (route) {
      '/earn/savings/dca' => SavingsPage.dcaInsightKey,
      '/earn/savings/export' => SavingsPage.exportInsightKey,
      '/earn/savings/backtest' => SavingsPage.backtestInsightKey,
      '/earn/savings/autopilot' => SavingsPage.autopilotInsightKey,
      '/earn/savings/ladder' => SavingsPage.ladderInsightKey,
      '/earn/savings/whatif' => SavingsPage.whatIfInsightKey,
      '/earn/savings/smart-suggestions' =>
        SavingsPage.smartSuggestionsInsightKey,
      _ => null,
    };
  }
}

class _ToolboxButton extends StatelessWidget {
  const _ToolboxButton({required this.guideRoute, required this.exportRoute});

  final String guideRoute;
  final String exportRoute;

  @override
  Widget build(BuildContext context) {
    assert(exportRoute.isNotEmpty);
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      child: InkWell(
        key: SavingsPage.guideButtonKey,
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(guideRoute);
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.menu_book_outlined,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Công cụ nâng cao',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(width: AppSpacing.x2),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
          ],
        ),
      ),
    );
  }
}

class _SavingsTabs extends StatelessWidget {
  const _SavingsTabs({
    required this.activeTab,
    required this.positionCount,
    required this.onChanged,
  });

  final _SavingsTab activeTab;
  final int positionCount;
  final ValueChanged<_SavingsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      variant: VitTabBarVariant.segment,
      activeKey: activeTab.name,
      onChanged: (key) => onChanged(_SavingsTab.values.byName(key)),
      tabs: [
        VitTabItem(
          key: _SavingsTab.products.name,
          label: 'Sản phẩm',
          icon: Icons.inventory_2_outlined,
        ),
        VitTabItem(
          key: _SavingsTab.my.name,
          label: 'Đăng ký ($positionCount)',
          icon: Icons.business_center_outlined,
        ),
      ],
    );
  }
}

class _SavingsFilters extends StatelessWidget {
  const _SavingsFilters({required this.activeFilter, required this.onChanged});

  final _SavingsFilter activeFilter;
  final ValueChanged<_SavingsFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (final filter in _SavingsFilter.values) ...[
          _SavingsFilterChip(
            key: SavingsPage.filterKey(filter.name),
            filter: filter,
            selected: filter == activeFilter,
            onTap: () => onChanged(filter),
          ),
          if (filter != _SavingsFilter.values.last)
            const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _SavingsFilterChip extends StatelessWidget {
  const _SavingsFilterChip({
    super.key,
    required this.filter,
    required this.selected,
    required this.onTap,
  });

  final _SavingsFilter filter;
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
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _filterIcon(filter),
                color: selected ? AppColors.primary : AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x1),
              Text(
                _filterLabel(filter),
                style: AppTextStyles.caption.copyWith(
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

class _SavingsProductList extends StatelessWidget {
  const _SavingsProductList({
    required this.products,
    required this.detailRoute,
  });

  final List<SavingsProductDraft> products;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final product in products) ...[
          _SavingsProductCard(product: product, detailRoute: detailRoute),
          if (product != products.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _SavingsProductCard extends StatelessWidget {
  const _SavingsProductCard({required this.product, required this.detailRoute});

  final SavingsProductDraft product;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final accent = _productAccent(product);

    return VitCard(
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
                            label: 'MỚI',
                            color: AppColors.primary,
                            background: AppColors.primary12,
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        Icon(
                          product.type == SavingsProductType.flexible
                              ? Icons.lock_open_rounded
                              : Icons.lock_outline_rounded,
                          color: product.type == SavingsProductType.flexible
                              ? AppColors.buy
                              : AppColors.warn,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Expanded(
                          child: Text(
                            _productSubtitle(product),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        _RiskPill(label: _riskLabel(product.riskLevel)),
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
                  if (product.maxApy != null)
                    Text(
                      product.maxApy!,
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
                  'Đã ký: ${product.totalSubscribed}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                'Còn: ${product.remainingQuota}',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          _ProgressBar(
            progress: product.progress,
            color: product.progress > 0.85 ? AppColors.sell : accent,
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              TextButton.icon(
                key: product.id == 'sav001'
                    ? SavingsPage.productDetailButtonKey
                    : null,
                onPressed: () => context.go(detailRoute),
                icon: const Icon(Icons.chevron_right_rounded),
                label: const Text('Chi tiết'),
              ),
              const Spacer(),
              VitCtaButton(
                fullWidth: false,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                onPressed: () => HapticFeedback.selectionClick(),
                child: const Text('Đăng ký'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingsPositions extends StatelessWidget {
  const _SavingsPositions({required this.positions});

  final List<SavingsPositionDraft> positions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final position in positions) ...[
          VitCard(
            radius: VitCardRadius.lg,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                _AssetBadge(
                  asset: position.asset,
                  color: _riskColor(position.riskLevel),
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
                        '${position.amount} - ${position.apy} APY',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  position.earned,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
          ),
          if (position != positions.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon({required this.tone});

  final EarnRiskLevel tone;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(tone);
    final icon = switch (tone) {
      EarnRiskLevel.low => Icons.repeat_rounded,
      EarnRiskLevel.medium => Icons.schedule_rounded,
      EarnRiskLevel.high => Icons.auto_awesome_rounded,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: _riskTint(tone),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _RiskPill extends StatelessWidget {
  const _RiskPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.buy10,
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
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
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
        color: AppColors.surface2,
        border: Border.all(color: color.withValues(alpha: 0.4)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: SizedBox(
        width: AppSpacing.x7,
        height: AppSpacing.x7,
        child: Center(
          child: Text(
            asset.length > 3 ? asset.substring(0, 3) : asset,
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

List<SavingsProductDraft> _filteredProducts(
  SavingsController controller,
  _SavingsFilter filter,
) {
  return switch (filter) {
    _SavingsFilter.all => controller.productsByType(null),
    _SavingsFilter.flexible => controller.productsByType(
      SavingsProductType.flexible,
    ),
    _SavingsFilter.locked => controller.productsByType(
      SavingsProductType.locked,
    ),
  };
}

String _filterLabel(_SavingsFilter filter) {
  return switch (filter) {
    _SavingsFilter.all => 'Tất cả',
    _SavingsFilter.flexible => 'Linh hoạt',
    _SavingsFilter.locked => 'Cố định',
  };
}

IconData _filterIcon(_SavingsFilter filter) {
  return switch (filter) {
    _SavingsFilter.all => Icons.bolt_rounded,
    _SavingsFilter.flexible => Icons.lock_open_rounded,
    _SavingsFilter.locked => Icons.lock_outline_rounded,
  };
}

String _productSubtitle(SavingsProductDraft product) {
  final duration = product.type == SavingsProductType.flexible
      ? 'Linh hoạt'
      : '${product.lockDays} ngày';
  return '$duration - ${product.participants}';
}

Color _productAccent(SavingsProductDraft product) {
  if (product.asset == 'BTC') return AppColors.warn;
  if (product.asset == 'ETH') return AppColors.primary;
  if (product.asset == 'SOL') return AppColors.primarySoft;
  return product.type == SavingsProductType.flexible
      ? AppColors.buy
      : AppColors.sell;
}

Color _riskColor(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => AppColors.buy,
    EarnRiskLevel.medium => AppColors.warn,
    EarnRiskLevel.high => AppColors.sell,
  };
}

Color _riskTint(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => AppColors.buy10,
    EarnRiskLevel.medium => AppColors.warn10,
    EarnRiskLevel.high => AppColors.primary12,
  };
}

String _riskLabel(EarnRiskLevel riskLevel) {
  return switch (riskLevel) {
    EarnRiskLevel.low => 'Thấp',
    EarnRiskLevel.medium => 'Trung bình',
    EarnRiskLevel.high => 'Cao',
  };
}
