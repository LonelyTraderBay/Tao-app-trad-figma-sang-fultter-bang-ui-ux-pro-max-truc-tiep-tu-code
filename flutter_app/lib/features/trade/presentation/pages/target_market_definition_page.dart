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
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _targetBackground = AppColors.bg;
const _targetPanel = AppColors.surface;
const _targetBorder = AppColors.borderSolid;
const _targetPrimary = AppColors.primary;
const _targetGreen = AppColors.buy;
const _targetRed = AppColors.sell;

class TargetMarketDefinitionPage extends ConsumerWidget {
  const TargetMarketDefinitionPage({
    super.key,
    this.productId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc101_target_market_content');
  static Key dimensionKey(String id) => Key('sc101_dimension_$id');

  final String? productId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getTargetMarketDefinition(productId: productId ?? 'prod-1');
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 118
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-101 TargetMarketDefinitionPage',
      child: Material(
        color: _targetBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Target Market Definition',
              subtitle: snapshot.product.name,
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyProductGovernance),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryCard(snapshot: snapshot),
                    const SizedBox(height: 23),
                    const _SectionLabel('Target Market Criteria'),
                    const SizedBox(height: 9),
                    for (final dimension in snapshot.dimensions) ...[
                      _DimensionCard(dimension: dimension),
                      if (dimension != snapshot.dimensions.last)
                        const SizedBox(height: 12),
                    ],
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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.snapshot});

  final TradeTargetMarketDefinitionSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 17),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _targetPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.gps_fixed_rounded,
              color: _targetPrimary,
              size: 22,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  snapshot.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.base.copyWith(
                    color: AppColors.text1,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'High-risk product requiring advanced knowledge and '
                  'significant capital.',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1.35,
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

class _DimensionCard extends StatelessWidget {
  const _DimensionCard({required this.dimension});

  final TradeTargetMarketDimension dimension;

  @override
  Widget build(BuildContext context) {
    return _Card(
      key: TargetMarketDefinitionPage.dimensionKey(dimension.id),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 19),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dimension.category,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 12),
          _CriteriaGroup(
            label: 'Suitable for:',
            color: _targetGreen,
            icon: Icons.check_circle_outline,
            values: dimension.suitableFor,
          ),
          const SizedBox(height: 10),
          _CriteriaGroup(
            label: 'Not suitable for:',
            color: _targetRed,
            icon: Icons.info_outline,
            values: dimension.notSuitableFor,
          ),
        ],
      ),
    );
  }
}

class _CriteriaGroup extends StatelessWidget {
  const _CriteriaGroup({
    required this.label,
    required this.color,
    required this.icon,
    required this.values,
  });

  final String label;
  final Color color;
  final IconData icon;
  final List<String> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontSize: 10,
            height: 1,
          ),
        ),
        const SizedBox(height: 7),
        for (final value in values) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: color, size: 12),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 11,
                    height: 1.28,
                  ),
                ),
              ),
            ],
          ),
          if (value != values.last) const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _targetPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _targetPanel,
        border: Border.all(color: _targetBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}
