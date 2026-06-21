import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

import '../widgets/trade_body_review_widgets.dart';

const _providerPrimary = AppColors.primary;
const _providerGreen = AppColors.buy;
const _providerRed = AppColors.sell;

class CopyProviderDetailPage extends ConsumerWidget {
  const CopyProviderDetailPage({
    super.key,
    required this.providerId,
    this.backPath,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc070_copy_provider_detail_content');
  static const assessmentKey = Key('sc070_copy_provider_assessment');
  static const notFoundKey = Key('sc070_copy_provider_not_found');

  final String providerId;
  final String? backPath;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(tradeCopyProviderDetailProvider(providerId));
    final provider = snapshot.provider;
    final resolvedBackPath = resolveSafeBackPath(
      candidate: backPath,
      fallbackPath: AppRoutePaths.tradeCopyTrading,
      allowedPrefixes: const [AppRoutePaths.trade],
    );

    if (provider == null) {
      return _ProviderNotFound(
        message: snapshot.notFoundMessage,
        onBack: () => goBackOrFallback(context, fallbackPath: resolvedBackPath),
      );
    }

    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x5 : AppSpacing.x4);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-070 CopyProviderDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: provider.name,
            showBack: true,
            onBack: () =>
                goBackOrFallback(context, fallbackPath: resolvedBackPath),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: contentKey,
                  padding: EdgeInsetsDirectional.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.compact,
                    gap: VitContentGap.tight,
                    children: [
                      const _RiskWarning(),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: AppSpacing.cardPaddingCompact,
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Provider detail review required',
                          message:
                              'Performance, max drawdown, copier limit, risk score, fees and suitability assessment are reviewed before copying.',
                          contractId: 'copy-provider-detail-review',
                        ),
                      ),
                      _ProviderCard(provider: provider),
                      _MetricGrid(provider: provider),
                      VitCtaButton(
                        key: assessmentKey,
                        onPressed: () => context.go(
                          AppRoutePaths.tradeCopyProviderAssessment(providerId),
                        ),
                        height: VitDensity.compact.controlHeight,
                        trailing: const Icon(Icons.chevron_right_rounded),
                        child: Text(
                          'ÄÃ¡nh giÃ¡ rá»§i ro',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.onAccent,
                            fontWeight: AppTextStyles.extraBold,
                          ),
                        ),
                      ),
                      Text(
                        'Hiá»‡u suáº¥t quÃ¡ khá»© khÃ´ng Ä‘áº£m báº£o káº¿t quáº£ tÆ°Æ¡ng lai. Copy Trading cÃ³ rá»§i ro cao.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height:
                              AppSpacing.copyProviderDetailDisclaimerLineHeight,
                        ),
                      ),
                      const TradeBodyReviewSection(
                        title: 'Provider detail body review',
                        message: 'Copy provider detail body reviewed',
                        detail:
                            'Risk warning, provider profile, metrics, assessment CTA, not-found, and review states stay visible.',
                        primary:
                            'Risk warning and review panel remain above provider performance data.',
                        secondary:
                            'Assessment CTA stays after provider metrics and before follow-up review.',
                        tertiary:
                            'Not-found state remains routed through the same safe back behavior.',
                      ),
                    ],
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

class _ProviderNotFound extends StatelessWidget {
  const _ProviderNotFound({required this.message, required this.onBack});

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-070 CopyProviderDetailPage not found',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Provider Not Found',
            showBack: true,
            onBack: onBack,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  key: CopyProviderDetailPage.notFoundKey,
                  padding: AppSpacing.copyProviderDetailNotFoundPadding,
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.walletTokenHeroIcon,
                      ),
                      const SizedBox(height: AppSpacing.cardGap),
                      Text(
                        message,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text2,
                        ),
                      ),
                    ],
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

class _RiskWarning extends StatelessWidget {
  const _RiskWarning();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.warningBorderDark,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.caution,
            size: AppSpacing.ctaLoadingIcon,
          ),
          const SizedBox(width: AppSpacing.walletAssetPillGap),
          Expanded(
            child: Text(
              'Hiá»‡u suáº¥t quÃ¡ khá»© khÃ´ng Ä‘áº£m báº£o lá»£i nhuáº­n tÆ°Æ¡ng lai. Báº¡n cÃ³ thá»ƒ máº¥t toÃ n bá»™ vá»‘n Ä‘áº§u tÆ°.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.caution,
                height: AppSpacing.copyProviderDetailRiskLineHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: VitDensity.compact.cardPadding,
      child: Row(
        children: [
          VitAssetAvatar(
            label: provider.avatar,
            accentColor: _providerPrimary,
            size: AppSpacing.x7,
            radius: AppRadii.avatarRadius,
            border: true,
          ),
          const SizedBox(width: AppSpacing.cardGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.formFieldLabelGap),
                Wrap(
                  spacing: AppSpacing.formFieldLabelGap,
                  runSpacing: AppSpacing.formFieldLabelGap,
                  children: [
                    for (final tag in provider.tags)
                      _Pill(label: tag, color: AppColors.text2),
                    _Pill(
                      label: _riskLabel(provider.riskLevel),
                      color: _riskColor(provider.riskLevel),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  '${provider.totalTrades} trades Â· ${provider.avgHoldingTime} avg hold',
                  style: AppTextStyles.captionSm.copyWith(
                    color: AppColors.text3,
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

class _MetricGrid extends StatelessWidget {
  const _MetricGrid({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('ROI', '+${provider.totalPnlPct.toStringAsFixed(1)}%', _providerGreen),
      ('Max DD', '${provider.maxDrawdown.toStringAsFixed(1)}%', _providerRed),
      ('Sharpe', provider.sharpeRatio.toStringAsFixed(2), _providerPrimary),
      ('Win Rate', '${provider.winRate.toStringAsFixed(1)}%', _providerGreen),
      (
        'Copiers',
        '${provider.copiers}/${provider.maxCopiers}',
        _providerPrimary,
      ),
      (
        'AUM',
        '\$${(provider.aum / 1000000).toStringAsFixed(1)}M',
        AppColors.caution,
      ),
    ];

    return GridView.count(
      crossAxisCount: AppSpacing.copyProviderDetailMetricColumns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: AppSpacing.x3,
      mainAxisSpacing: AppSpacing.x3,
      childAspectRatio: AppSpacing.copyProviderDetailMetricAspectRatio,
      children: [
        for (final metric in metrics)
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.sm,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.$2,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: metric.$3,
                    fontWeight: AppTextStyles.extraBold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  metric.$1,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(label: label, accentColor: color);
  }
}

Color _riskColor(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => _providerGreen,
    TradeCopyRiskLevel.medium => AppColors.caution,
    TradeCopyRiskLevel.high => _providerRed,
  };
}

String _riskLabel(TradeCopyRiskLevel level) {
  return switch (level) {
    TradeCopyRiskLevel.low => 'Rá»§i ro tháº¥p',
    TradeCopyRiskLevel.medium => 'Rá»§i ro trung bÃ¬nh',
    TradeCopyRiskLevel.high => 'Rá»§i ro cao',
  };
}
