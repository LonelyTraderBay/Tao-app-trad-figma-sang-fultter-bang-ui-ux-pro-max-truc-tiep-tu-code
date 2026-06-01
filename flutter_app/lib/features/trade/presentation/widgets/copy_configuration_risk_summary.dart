part of '../pages/copy_configuration_page.dart';

class _RiskSection extends StatelessWidget {
  const _RiskSection({required this.draft, required this.onDraftChanged});

  final TradeCopyConfigurationDraft draft;
  final ValueChanged<TradeCopyConfigurationDraft> onDraftChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Giới hạn rủi ro',
      accentColor: _configurationRed,
      children: [
        _RiskToggle(
          title: 'Stop-Loss riêng',
          value: draft.useCustomStopLoss,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomStopLoss: value)),
        ),
        _RiskToggle(
          title: 'Take-Profit riêng',
          value: draft.useCustomTakeProfit,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useCustomTakeProfit: value)),
        ),
        _RiskToggle(
          title: 'Trailing Stop',
          value: draft.useTrailingStop,
          onChanged: (value) =>
              onDraftChanged(draft.copyWith(useTrailingStop: value)),
        ),
      ],
    );
  }
}

class _FeeSection extends StatelessWidget {
  const _FeeSection({required this.preview});

  final TradeCopyConfigurationPreview preview;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Dự kiến chi phí',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _SummaryRow(
                label: 'Platform fee (0.1%)',
                value: '\$${preview.feePreview.platformFee.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Trading fees ước tính',
                value:
                    '\$${preview.feePreview.estimatedTradingFees.toStringAsFixed(2)}',
              ),
              _SummaryRow(
                label: 'Performance fee',
                value: preview.feePreview.performanceFeeNote,
              ),
              const Divider(color: AppColors.divider, height: 22),
              _SummaryRow(
                label: 'Tổng phí cố định',
                value:
                    '\$${preview.feePreview.totalFixedFees.toStringAsFixed(2)}',
                valueColor: _configurationRed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ValidationList extends StatelessWidget {
  const _ValidationList({required this.items});

  final List<TradeCopyConfigurationValidation> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items) ...[
          _ValidationCard(item: item),
          if (item != items.last) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.draft});

  final TradeCopyConfigurationDraft draft;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Tóm tắt cấu hình',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          _SummaryRow(
            label: 'Số vốn copy',
            value: '\$${draft.copyCapital.toStringAsFixed(0)}',
          ),
          _SummaryRow(label: 'Chế độ', value: _modeLabel(draft.copyMode)),
          _SummaryRow(
            label: 'Stop-Loss',
            value: draft.useCustomStopLoss
                ? '-${draft.customStopLoss.toStringAsFixed(0)}%'
                : 'Theo provider',
          ),
          _SummaryRow(
            label: 'Take-Profit',
            value: draft.useCustomTakeProfit
                ? '+${draft.customTakeProfit.toStringAsFixed(0)}%'
                : 'Theo provider',
          ),
          _SummaryRow(
            label: 'Trailing Stop',
            value: draft.useTrailingStop
                ? '${draft.trailingStopPercent.toStringAsFixed(0)}%'
                : 'Không',
          ),
        ],
      ),
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final TradeCopyConfigurationMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: CopyConfigurationPage.modeKey(mode),
      variant: selected ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: selected ? _configurationPrimary : null,
      padding: const EdgeInsets.all(14),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked_rounded
                : Icons.radio_button_unchecked_rounded,
            color: selected ? _configurationPrimary : AppColors.text3,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _modeLabel(mode),
                  style: AppTextStyles.caption.copyWith(
                    color: selected ? _configurationPrimary : AppColors.text1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _modeDescription(mode),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
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
