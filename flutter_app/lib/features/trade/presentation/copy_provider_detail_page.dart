import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _providerBlue = Color(0xFF3B82F6);
const _providerGreen = Color(0xFF10B981);
const _providerRed = Color(0xFFEF4444);
const _providerPanel = Color(0xFF1B2132);

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
    final snapshot = ref
        .watch(tradeRepositoryProvider)
        .getCopyProviderDetail(providerId: providerId);
    final provider = snapshot.provider;

    if (provider == null) {
      return _ProviderNotFound(
        message: snapshot.notFoundMessage,
        onBack: () => context.go(backPath ?? AppRoutePaths.tradeCopyTrading),
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
        child: Column(
          children: [
            VitHeader(
              title: provider.name,
              showBack: true,
              onBack: () =>
                  context.go(backPath ?? AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _RiskWarning(),
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
                        backgroundColor: _providerBlue,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.chevron_right_rounded, size: 18),
                      label: Text(
                        'Đánh giá rủi ro',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: Colors.white,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VitHeader(
              title: 'Provider Not Found',
              showBack: true,
              onBack: onBack,
            ),
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
        color: const Color(0xFF231814),
        border: Border.all(color: const Color(0xFF92400E)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Hiệu suất quá khứ không đảm bảo lợi nhuận tương lai. Bạn có thể mất toàn bộ vốn đầu tư.',
              style: AppTextStyles.caption.copyWith(
                color: const Color(0xFFF59E0B),
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
            backgroundColor: _providerBlue.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.sectionTitle.copyWith(
                color: _providerBlue,
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
      ('Sharpe', provider.sharpeRatio.toStringAsFixed(2), _providerBlue),
      ('Win Rate', '${provider.winRate.toStringAsFixed(1)}%', _providerGreen),
      ('Copiers', '${provider.copiers}/${provider.maxCopiers}', _providerBlue),
      (
        'AUM',
        '\$${(provider.aum / 1000000).toStringAsFixed(1)}M',
        const Color(0xFFF59E0B),
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
              borderRadius: BorderRadius.circular(14),
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
    TradeCopyRiskLevel.medium => const Color(0xFFF59E0B),
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
