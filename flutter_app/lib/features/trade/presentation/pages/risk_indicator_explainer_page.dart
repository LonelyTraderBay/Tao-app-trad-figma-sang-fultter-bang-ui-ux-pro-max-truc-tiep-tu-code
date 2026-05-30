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

const _riskBackground = AppColors.bg;
const _riskPanel = AppColors.surface;
const _riskPanel2 = AppColors.surface2;
const _riskBorder = AppColors.borderSolid;
const _riskPrimary = AppColors.primary;
const _riskGreen = AppColors.buy;
const _riskAmber = AppColors.caution;
const _riskRed = AppColors.sell;

class RiskIndicatorExplainerPage extends ConsumerWidget {
  const RiskIndicatorExplainerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc110_risk_indicator_content');
  static Key levelKey(int level) => Key('sc110_risk_level_$level');
  static Key additionalRiskKey(String title) =>
      Key('sc110_additional_${title.toLowerCase().replaceAll(' ', '_')}');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeRiskIndicatorExplainerProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-110 RiskIndicatorExplainerPage',
      child: Material(
        color: _riskBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Risk Indicator',
              subtitle: 'Summary Risk Indicator (SRI)',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: RiskIndicatorExplainerPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProductSriCard(snapshot: snapshot),
                    const SizedBox(height: 26),
                    const _SectionLabel('What is the Summary Risk Indicator?'),
                    const SizedBox(height: 10),
                    _SriExplanationCard(
                      holdingPeriodYears: snapshot.holdingPeriodYears,
                    ),
                    const SizedBox(height: 25),
                    const _SectionLabel('Understanding the 1-7 Scale'),
                    const SizedBox(height: 10),
                    for (final level in snapshot.levels) ...[
                      _RiskLevelCard(
                        level: level,
                        isProductLevel: level.level == snapshot.productSri,
                      ),
                      if (level != snapshot.levels.last)
                        const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 25),
                    const _SectionLabel('Additional Risks Not Captured by SRI'),
                    const SizedBox(height: 10),
                    _AdditionalRisksCard(risks: snapshot.additionalRisks),
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

class _ProductSriCard extends StatelessWidget {
  const _ProductSriCard({required this.snapshot});

  final TradeRiskIndicatorSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.productName,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Summary Risk Indicator',
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontSize: 16,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              for (final level in snapshot.levels) ...[
                Expanded(
                  child: _ScaleTile(
                    level: level.level,
                    color: level.level <= snapshot.productSri
                        ? _colorForTier(level.tier)
                        : _riskPanel2,
                    active: level.level <= snapshot.productSri,
                  ),
                ),
                if (level != snapshot.levels.last) const SizedBox(width: 4),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Lower Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  height: 1,
                ),
              ),
              Text(
                'Higher Risk',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 9,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const _SriWarning(),
        ],
      ),
    );
  }
}

class _ScaleTile extends StatelessWidget {
  const _ScaleTile({
    required this.level,
    required this.color,
    required this.active,
  });

  final int level;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        '$level',
        style: AppTextStyles.baseMedium.copyWith(
          color: active ? AppColors.onAccent : AppColors.text3,
          fontSize: 15,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SriWarning extends StatelessWidget {
  const _SriWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 52),
      padding: const EdgeInsets.fromLTRB(13, 11, 13, 11),
      decoration: BoxDecoration(
        color: _riskAmber.withValues(alpha: .10),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _riskAmber,
              size: 15,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text: 'SRI 6 - High Risk: ',
                    style: TextStyle(fontWeight: AppTextStyles.bold),
                  ),
                  const TextSpan(
                    text:
                        'This product has high volatility. You could lose a '
                        'significant portion of your investment.',
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: _riskAmber,
                fontSize: 10,
                fontWeight: AppTextStyles.medium,
                height: 1.28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SriExplanationCard extends StatelessWidget {
  const _SriExplanationCard({required this.holdingPeriodYears});

  final int holdingPeriodYears;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'The Summary Risk Indicator (SRI) is a guide to the level of risk '
            'of this product compared to other products. It shows how likely '
            'it is that the product will lose money because of movements in '
            'the markets or because we are not able to pay you.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 1),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.text1,
                  size: 15,
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  'The risk indicator assumes you keep the product for '
                  '$holdingPeriodYears years. The actual risk can vary '
                  'significantly if you cash in at an early stage.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.28,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskLevelCard extends StatelessWidget {
  const _RiskLevelCard({required this.level, required this.isProductLevel});

  final TradeRiskIndicatorLevel level;
  final bool isProductLevel;

  @override
  Widget build(BuildContext context) {
    final color = _colorForTier(level.tier);
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 76),
      child: _Card(
        key: RiskIndicatorExplainerPage.levelKey(level.level),
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .11),
                borderRadius: AppRadii.lgRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                '${level.level}',
                style: AppTextStyles.baseMedium.copyWith(
                  color: color,
                  fontSize: 18,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          level.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1.1,
                          ),
                        ),
                      ),
                      if (isProductLevel) ...[
                        const SizedBox(width: 9),
                        Text(
                          'THIS PRODUCT',
                          style: AppTextStyles.micro.copyWith(
                            color: _riskPrimary,
                            fontSize: 9,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    level.description,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 10,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Examples: ${level.examples.join(', ')}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdditionalRisksCard extends StatelessWidget {
  const _AdditionalRisksCard({required this.risks});

  final List<TradeRiskIndicatorAdditionalRisk> risks;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 164),
      child: _Card(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 17),
        child: Column(
          children: [
            for (final risk in risks) ...[
              _AdditionalRiskRow(risk: risk),
              if (risk != risks.last) const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _AdditionalRiskRow extends StatelessWidget {
  const _AdditionalRiskRow({required this.risk});

  final TradeRiskIndicatorAdditionalRisk risk;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: RiskIndicatorExplainerPage.additionalRiskKey(risk.title),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 1),
          child: Icon(
            Icons.warning_amber_rounded,
            color: AppColors.text1,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                risk.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                risk.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _riskPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
        Expanded(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
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
        color: _riskPanel,
        border: Border.all(color: _riskBorder.withValues(alpha: .76)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

Color _colorForTier(TradeRiskIndicatorTier tier) {
  return switch (tier) {
    TradeRiskIndicatorTier.low => _riskGreen,
    TradeRiskIndicatorTier.medium => _riskPrimary,
    TradeRiskIndicatorTier.elevated => _riskAmber,
    TradeRiskIndicatorTier.high => _riskRed,
  };
}
