import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/trade_repository.dart';

const _confirmationBlue = Color(0xFF3B82F6);
const _confirmationGreen = Color(0xFF10B981);
const _confirmationRed = Color(0xFFEF4444);

class CopyConfirmationPage extends ConsumerStatefulWidget {
  const CopyConfirmationPage({
    super.key,
    required this.providerId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc073_copy_confirmation_content');
  static const submitKey = Key('sc073_copy_confirmation_submit');

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
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getCopyConfirmation(
      providerId: widget.providerId,
    );

    if (snapshot.isNotFound) {
      return const VitPageLayout(
        variant: VitPageVariant.flush,
        semanticLabel: 'SC-073 CopyConfirmationPage blank',
        child: SizedBox.expand(),
      );
    }

    final allRequiredAccepted = snapshot.consentItems
        .where((item) => item.required)
        .every((item) => _acceptedConsentIds.contains(item.id));
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
                          ? () => _submit(context, repository, snapshot)
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
    TradeRepository repository,
    TradeCopyConfirmationSnapshot snapshot,
  ) async {
    setState(() => _submitting = true);
    final result = repository.submitCopyConfirmation(
      TradeCopyConfirmationRequest(
        providerId: snapshot.providerId,
        configuration: snapshot.configuration,
        acceptedConsentIds: _acceptedConsentIds.toList(growable: false),
      ),
    );
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
                    color: const Color(0xFFFCA5A5),
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
            backgroundColor: _confirmationBlue.withValues(alpha: .16),
            child: Text(
              provider.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _confirmationBlue,
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
      accentColor: _confirmationBlue,
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
              color: const Color(0xFFFCA5A5),
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
      borderColor: checked ? _confirmationBlue : null,
      padding: const EdgeInsets.all(12),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            checked
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: checked ? _confirmationBlue : AppColors.text3,
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
      borderColor: _confirmationBlue,
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.schedule_rounded,
            color: _confirmationBlue,
            size: 18,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Sau khi xác nhận, bạn có $hours giờ cooling-off để review lại quyết định trước khi copy chính thức kích hoạt.',
              style: AppTextStyles.caption.copyWith(
                color: _confirmationBlue,
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
                  backgroundColor: _confirmationBlue.withValues(alpha: .16),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _confirmationBlue,
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
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w700,
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
