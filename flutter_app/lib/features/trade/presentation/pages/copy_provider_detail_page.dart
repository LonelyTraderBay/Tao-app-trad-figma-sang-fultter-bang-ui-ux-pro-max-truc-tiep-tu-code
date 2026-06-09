import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/core/navigation/back_navigation.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _providerPrimary = AppColors.primary;
const _providerGreen = AppColors.buy;
const _providerRed = AppColors.sell;
const _providerPanel = AppColors.surface2;

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
        (mode.usesVisualQaFrame ? 104 : 28);

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
                  padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _RiskWarning(),
                      const SizedBox(height: 12),
                      const VitCard(
                        variant: VitCardVariant.inner,
                        padding: EdgeInsets.all(12),
                        child: VitHighRiskStatePanel(
                          state: VitHighRiskUiState.riskReview,
                          title: 'Provider detail review required',
                          message:
                              'Performance, max drawdown, copier limit, risk score, fees and suitability assessment are reviewed before copying.',
                          contractId: 'copy-provider-detail-review',
                        ),
                      ),
                      const SizedBox(height: 14),
                      _ProviderCard(provider: provider),
                      const SizedBox(height: 14),
                      _MetricGrid(provider: provider),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        key: assessmentKey,
                        onPressed: () => context.go(
                          AppRoutePaths.tradeCopyProviderAssessment(providerId),
                        ),
                        style: FilledButton.styleFrom(
                          backgroundColor: _providerPrimary,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: AppRadii.inputRadius,
                          ),
                        ),
                        icon: const Icon(Icons.chevron_right_rounded, size: 18),
                        label: Text(
                          'Đánh giá rủi ro',
                          style: AppTextStyles.baseMedium.copyWith(
                            color: AppColors.onAccent,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Copy Trading có rủi ro cao.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 10,
                          height: 1.45,
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
                  padding: const EdgeInsets.only(top: 64),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.warning_amber_rounded,
                        color: AppColors.text3,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        style: AppTextStyles.base.copyWith(
                          color: AppColors.text2,
                          fontSize: 14,
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorderDark),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.caution,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hiệu suất quá khứ không đảm bảo lợi nhuận tương lai. Bạn có thể mất toàn bộ vốn đầu tư.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.caution,
                fontSize: 10,
                height: 1.4,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: _providerPrimary.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.sectionTitle.copyWith(
                color: _providerPrimary,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in provider.tags)
                      _Pill(label: tag, color: AppColors.text2),
                    _Pill(
                      label: _riskLabel(provider.riskLevel),
                      color: _riskColor(provider.riskLevel),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${provider.totalTrades} trades · ${provider.avgHoldingTime} avg hold',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
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
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: 1.22,
      children: [
        for (final metric in metrics)
          Container(
            decoration: BoxDecoration(
              color: _providerPanel,
              borderRadius: AppRadii.inputRadius,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  metric.$2,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: metric.$3,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  metric.$1,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                  ),
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
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
    TradeCopyRiskLevel.low => 'Rủi ro thấp',
    TradeCopyRiskLevel.medium => 'Rủi ro trung bình',
    TradeCopyRiskLevel.high => 'Rủi ro cao',
  };
}
