import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _hubBackground = AppColors.bg;
const _hubPanel = AppColors.surface;
const _hubHero = AppColors.surface;
const _hubHeroBorder = AppColors.primary20;
const _hubBorder = AppColors.borderSolid;
const _hubPrimary = AppColors.primary;
const _hubGreen = Color(0xFF10B981);
const _hubPurple = Color(0xFF8B5CF6);

class MarginTradingHubPage extends ConsumerWidget {
  const MarginTradingHubPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc090_margin_trading_hub_content');
  static Key menuKey(String id) => Key('sc090_margin_hub_menu_$id');
  static Key featureKey(String phase) => Key('sc090_margin_hub_feature_$phase');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRepositoryProvider).getMarginTradingHub();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-090 MarginTradingHubPage',
      child: Material(
        color: _hubBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Margin Trading Hub',
              subtitle: 'Enterprise Features',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeMargin),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HeroCard(stats: snapshot.stats),
                    const SizedBox(height: 16),
                    _NavigationCard(items: snapshot.menuItems),
                    const SizedBox(height: 14),
                    for (final feature in snapshot.features) ...[
                      _FeatureCard(feature: feature),
                      const SizedBox(height: 14),
                    ],
                    _ComplianceCard(compliance: snapshot.compliance),
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

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.stats});

  final List<TradeMarginHubStat> stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(25, 29, 25, 25),
      decoration: BoxDecoration(
        color: _hubHero,
        border: Border.all(color: _hubHeroBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .10),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Margin Trading Suite',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: AppTextStyles.bold,
                        height: 1.16,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      'Professional-grade trading voi enterprise compliance',
                      style: AppTextStyles.body.copyWith(
                        color: Colors.white.withValues(alpha: .72),
                        fontSize: 14,
                        fontWeight: AppTextStyles.medium,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          Row(
            children: [
              for (final stat in stats) ...[
                Expanded(child: _HeroStat(stat: stat)),
                if (stat != stats.last) const SizedBox(width: 10),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.stat});

  final TradeMarginHubStat stat;

  @override
  Widget build(BuildContext context) {
    final color = Color(stat.colorHex);
    return Container(
      height: 85,
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            stat.value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontSize: 18,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            stat.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: Colors.white.withValues(alpha: .62),
              fontSize: 10,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  const _NavigationCard({required this.items});

  final List<TradeMarginHubMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return _HubCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bar_chart_rounded, color: _hubPrimary, size: 22),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Margin Trading Suite',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontSize: 22,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Enterprise-level margin trading voi day du regulatory compliance, advanced controls va market intelligence.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text3,
              fontSize: 14,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 17),
          for (final item in items) ...[
            _MenuItem(item: item),
            if (item != items.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 16),
          const _ComplianceInfoBanner(),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({required this.item});

  final TradeMarginHubMenuItem item;

  @override
  Widget build(BuildContext context) {
    final color = Color(item.colorHex);
    return InkWell(
      key: MarginTradingHubPage.menuKey(item.id),
      borderRadius: AppRadii.cardRadius,
      onTap: () => context.go(item.targetPath),
      child: Container(
        constraints: const BoxConstraints(minHeight: 92),
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        decoration: BoxDecoration(
          color: _hubPanel,
          border: Border.all(color: color.withValues(alpha: .28)),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .10),
                borderRadius: AppRadii.cardRadius,
              ),
              child: Icon(_menuIcon(item.id), color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontSize: 14,
                            fontWeight: AppTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 7),
                      _PhaseBadge(label: item.badge, color: color),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    item.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 23,
            ),
          ],
        ),
      ),
    );
  }
}

class _ComplianceInfoBanner extends StatelessWidget {
  const _ComplianceInfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: _hubPurple.withValues(alpha: .10),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: _hubPurple, size: 16),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Fully Compliant',
                  style: AppTextStyles.caption.copyWith(
                    color: _hubPurple,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Dap ung MiFID II, ESMA, FCA, MAS regulations. Bao gom appropriateness test, leverage limits, cost disclosure.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final TradeMarginHubFeature feature;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return _HubCard(
      key: MarginTradingHubPage.featureKey(feature.phase),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _featureIcon(feature.phase),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      feature.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _PhaseBadge(label: feature.phase, color: color),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          for (final item in feature.items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.check_circle_outline_rounded,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
            if (item != feature.items.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ComplianceCard extends StatelessWidget {
  const _ComplianceCard({required this.compliance});

  final TradeMarginHubCompliance compliance;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _hubGreen.withValues(alpha: .08),
        border: Border.all(color: _hubGreen.withValues(alpha: .24), width: 1.5),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.shield_outlined, color: _hubGreen, size: 42),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      compliance.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: _hubGreen,
                        fontSize: 16,
                        fontWeight: AppTextStyles.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      compliance.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            itemCount: compliance.regulations.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 36,
              crossAxisSpacing: 10,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _hubGreen.withValues(alpha: .16),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: Text(
                  '${compliance.regulations[index]} v',
                  style: AppTextStyles.caption.copyWith(
                    color: _hubGreen,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HubCard extends StatelessWidget {
  const _HubCard({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _hubPanel,
        border: Border.all(color: _hubBorder.withValues(alpha: .68)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  const _PhaseBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

IconData _menuIcon(String id) {
  return switch (id) {
    'margin' => Icons.trending_up_rounded,
    'advanced-controls' => Icons.settings_outlined,
    'market-analytics' => Icons.show_chart_rounded,
    'ai-advanced' => Icons.school_outlined,
    _ => Icons.layers_outlined,
  };
}

IconData _featureIcon(String phase) {
  return switch (phase) {
    'P0' => Icons.shield_outlined,
    'P1' => Icons.settings_outlined,
    'P2' => Icons.show_chart_rounded,
    _ => Icons.layers_outlined,
  };
}
