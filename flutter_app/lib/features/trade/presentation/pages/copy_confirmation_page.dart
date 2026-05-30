import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _confirmationPrimary = AppColors.primary;
const _confirmationGreen = AppColors.buy;
const _confirmationRed = AppColors.sell;

class CopyConfirmationPage extends ConsumerStatefulWidget {
  const CopyConfirmationPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc073_copy_confirmation_content');
  static const submitKey = Key('sc073_copy_confirmation_submit');
  static const suitabilityKey = Key('sc073_copy_confirmation_suitability');

  static Key consentKey(String id) =>
      Key('sc073_copy_confirmation_consent_$id');

  final String providerId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyConfirmationPage> createState() =>
      _CopyConfirmationPageState();
}

class _CopyConfirmationPageState extends ConsumerState<CopyConfirmationPage> {
  final Set<String> _acceptedConsentIds = <String>{};
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(
      tradeCopyConfirmationControllerProvider((
        providerId: widget.providerId,
        acceptedConsentIds: _acceptedConsentIds.toList(growable: false),
      )),
    );
    final snapshot = controller.state.snapshot;

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-073 CopyConfirmationPage blank',
        child: SizedBox.expand(),
      );
    }

    final allRequiredAccepted = controller.allRequiredAccepted;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 84 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-073 CopyConfirmationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Xác nhận Copy',
              showBack: true,
              onBack: () => context.go(
                AppRoutePaths.tradeCopyProviderConfiguration(widget.providerId),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyConfirmationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 16, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CriticalWarning(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _ProviderSummary(provider: snapshot.provider!),
                    const SizedBox(height: 16),
                    _SuitabilityReviewCard(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _ConfigurationSummary(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _FeeBreakdown(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _ScenarioSection(scenarios: snapshot.scenarios),
                    const SizedBox(height: 16),
                    _MaxLossCard(snapshot: snapshot),
                    const SizedBox(height: 16),
                    _ConsentSection(
                      items: snapshot.consentItems,
                      acceptedIds: _acceptedConsentIds,
                      onToggle: _toggleConsent,
                    ),
                    const SizedBox(height: 16),
                    _CoolingOffCard(hours: snapshot.coolingOffHours),
                    const SizedBox(height: 16),
                    _NextStepsCard(snapshot: snapshot),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                bottom: bottomChrome + MediaQuery.paddingOf(context).bottom,
              ),
              child: VitStickyFooter(
                child: Column(
                  children: [
                    VitCtaButton(
                      key: CopyConfirmationPage.submitKey,
                      onPressed: allRequiredAccepted && !_submitting
                          ? () => _submit(context, controller)
                          : null,
                      loading: _submitting,
                      variant: VitCtaButtonVariant.danger,
                      leading: const Icon(Icons.shield_outlined),
                      child: const Text('Xác nhận & Bắt đầu Copy'),
                    ),
                    if (!allRequiredAccepted) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Bạn cần đồng ý với tất cả điều khoản để tiếp tục',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
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

  void _toggleConsent(String id) {
    setState(() {
      if (_acceptedConsentIds.contains(id)) {
        _acceptedConsentIds.remove(id);
      } else {
        _acceptedConsentIds.add(id);
      }
    });
  }

  Future<void> _submit(
    BuildContext context,
    TradeCopyConfirmationController controller,
  ) async {
    setState(() => _submitting = true);
    final result = controller.submit();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!context.mounted) return;
    if (result.status == 'pending_cooling_off') {
      context.go(result.activeCopiesPath);
    } else {
      setState(() => _submitting = false);
    }
  }
}

class _CriticalWarning extends StatelessWidget {
  const _CriticalWarning({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationRed,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _confirmationRed,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo rủi ro quan trọng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _confirmationRed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Copy Trading có rủi ro cao. Bạn có thể mất toàn bộ số tiền \$${snapshot.configuration.copyCapital.toStringAsFixed(0)} đã cam kết.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sellSoft,
                    fontSize: 12,
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

class _ProviderSummary extends StatelessWidget {
  const _ProviderSummary({required this.provider});

  final TradeCopyTrader provider;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: _confirmationPrimary.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _confirmationPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bạn sắp copy',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.name,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ROI +${provider.totalPnlPct.toStringAsFixed(1)}% · Max DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
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

class _ConfigurationSummary extends StatelessWidget {
  const _ConfigurationSummary({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final config = snapshot.configuration;
    return VitPageSection(
      label: 'Cấu hình',
      accentColor: _confirmationPrimary,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Số vốn copy',
                value: '\$${config.copyCapital.toStringAsFixed(0)}',
              ),
              _SummaryRow(
                label: 'Chế độ copy',
                value: _copyModeLabel(config.copyMode),
              ),
              _SummaryRow(
                label: 'Stop-Loss',
                value: config.useCustomStopLoss
                    ? '-${config.customStopLoss.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              _SummaryRow(
                label: 'Take-Profit',
                value: config.useCustomTakeProfit
                    ? '+${config.customTakeProfit.toStringAsFixed(0)}%'
                    : 'Theo provider',
              ),
              _SummaryRow(
                label: 'Trailing Stop',
                value: config.useTrailingStop
                    ? '${config.trailingStopPercent.toStringAsFixed(0)}%'
                    : 'Không',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SuitabilityReviewCard extends StatelessWidget {
  const _SuitabilityReviewCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final provider = snapshot.provider!;
    final config = snapshot.configuration;
    return VitPageSection(
      key: CopyConfirmationPage.suitabilityKey,
      label: 'Suitability & limits review',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryRow(
                label: 'Risk suitability',
                value:
                    '${_riskLabel(provider.riskLevel)} risk · DD ${provider.maxDrawdown.toStringAsFixed(1)}%',
                valueColor: AppColors.warn,
              ),
              _SummaryRow(
                label: 'Copy amount review',
                value: '\$${config.copyCapital.toStringAsFixed(0)} at risk',
                valueColor: _confirmationRed,
              ),
              const _SummaryRow(
                label: 'Provider limit',
                value: 'Max 20% portfolio per provider',
              ),
              const SizedBox(height: 6),
              Text(
                'Confirm this amount fits your risk tolerance, provider drawdown, and portfolio limit before cooling-off starts.',
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
    );
  }
}

class _FeeBreakdown extends StatelessWidget {
  const _FeeBreakdown({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final fee = snapshot.feePreview;
    return VitPageSection(
      label: 'Chi phí & Phí',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Platform fee (0.1%)',
                value: '\$${fee.platformFee.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Trading fees ước tính',
                value: '\$${fee.estimatedTradingFees.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Performance fee',
                value: fee.performanceFeeNote,
              ),
              const Divider(color: AppColors.divider, height: 22),
              _SummaryRow(
                label: 'Tổng phí cố định tháng đầu',
                value: '\$${fee.totalFixedFees.toStringAsFixed(2)}',
                valueColor: _confirmationRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ScenarioSection extends StatelessWidget {
  const _ScenarioSection({required this.scenarios});

  final List<TradeCopyScenarioProjection> scenarios;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Kịch bản dự kiến (30 ngày)',
      accentColor: _confirmationGreen,
      children: [
        for (final scenario in scenarios) _ScenarioCard(scenario: scenario),
      ],
    );
  }
}

class _ScenarioCard extends StatelessWidget {
  const _ScenarioCard({required this.scenario});

  final TradeCopyScenarioProjection scenario;

  @override
  Widget build(BuildContext context) {
    final color = switch (scenario.id) {
      'optimistic' => _confirmationGreen,
      'realistic' => AppColors.warn,
      _ => _confirmationRed,
    };
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _SummaryRow(
            label:
                '${scenario.title} (${scenario.returnPct.toStringAsFixed(0)}%)',
            value:
                '${scenario.netPnl >= 0 ? '+' : ''}\$${scenario.netPnl.toStringAsFixed(0)}',
            valueColor: color,
          ),
          _SummaryRow(
            label: 'Net return',
            value:
                '${scenario.netReturnPct >= 0 ? '+' : ''}${scenario.netReturnPct.toStringAsFixed(1)}%',
            valueColor: color,
          ),
        ],
      ),
    );
  }
}

class _MaxLossCard extends StatelessWidget {
  const _MaxLossCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationRed,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kịch bản mất vốn tối đa',
            style: AppTextStyles.caption.copyWith(
              color: _confirmationRed,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Bạn có thể mất tối đa \$${snapshot.maxLossAmount.toStringAsFixed(0)} nếu provider gặp drawdown nghiêm trọng.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.sellSoft,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _ConsentSection extends StatelessWidget {
  const _ConsentSection({
    required this.items,
    required this.acceptedIds,
    required this.onToggle,
  });

  final List<TradeCopyConsentItem> items;
  final Set<String> acceptedIds;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Xác nhận & Đồng ý',
      accentColor: _confirmationRed,
      children: [
        for (final item in items)
          _ConsentTile(
            item: item,
            checked: acceptedIds.contains(item.id),
            onTap: () => onToggle(item.id),
          ),
      ],
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    required this.item,
    required this.checked,
    required this.onTap,
  });

  final TradeCopyConsentItem item;
  final bool checked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyConfirmationPage.consentKey(item.id),
      variant: checked ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: checked ? _confirmationPrimary : null,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: checked ? _confirmationPrimary : AppColors.text3,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              item.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoolingOffCard extends StatelessWidget {
  const _CoolingOffCard({required this.hours});

  final int hours;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      borderColor: _confirmationPrimary,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _confirmationPrimary,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sau khi xác nhận, bạn có $hours giờ cooling-off để review lại quyết định trước khi copy chính thức kích hoạt.',
              style: AppTextStyles.caption.copyWith(
                color: _confirmationPrimary,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextStepsCard extends StatelessWidget {
  const _NextStepsCard({required this.snapshot});

  final TradeCopyConfirmationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final steps = [
      'Khóa vốn \$${snapshot.configuration.copyCapital.toStringAsFixed(0)} trong tài khoản copy',
      '${snapshot.coolingOffHours}h cooling-off period',
      'Copy tự động bắt đầu sao chép lệnh của provider',
      'Theo dõi real-time P/L và dừng copy bất cứ lúc nào',
    ];
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Điều gì xảy ra tiếp theo?',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < steps.length; index++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: _confirmationPrimary.withValues(alpha: .16),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _confirmationPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    steps[index],
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (index != steps.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              softWrap: true,
              style: AppTextStyles.caption.copyWith(
                color: valueColor,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String _copyModeLabel(TradeCopyConfigurationMode mode) {
  return switch (mode) {
    TradeCopyConfigurationMode.mirror => 'Mirror Copy',
    TradeCopyConfigurationMode.fixed => 'Fixed 50%',
    TradeCopyConfigurationMode.smart => 'Smart Copy',
  };
}

String _riskLabel(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => 'Low',
    TradeCopyRiskLevel.medium => 'Medium',
    TradeCopyRiskLevel.high => 'High',
  };
}
