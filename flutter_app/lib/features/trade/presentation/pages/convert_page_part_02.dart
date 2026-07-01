part of 'convert_page.dart';

class _ConvertToolGrid extends StatelessWidget {
  const _ConvertToolGrid({
    required this.alertBadgeCount,
    required this.onChart,
    required this.onDepth,
    required this.onInfo,
    required this.onAlert,
  });

  final int alertBadgeCount;
  final VoidCallback onChart;
  final VoidCallback onDepth;
  final VoidCallback onInfo;
  final VoidCallback onAlert;

  @override
  Widget build(BuildContext context) {
    final tools =
        <
          ({
            String id,
            String label,
            IconData icon,
            Color accentColor,
            String? badgeLabel,
            VoidCallback onTap,
          })
        >[
          (
            id: 'chart',
            label: 'Chart',
            icon: Icons.bar_chart_rounded,
            accentColor: AppModuleAccents.trade,
            badgeLabel: null,
            onTap: onChart,
          ),
          (
            id: 'depth',
            label: 'Depth',
            icon: Icons.layers_outlined,
            accentColor: AppAssetColors.cyanChain,
            badgeLabel: null,
            onTap: onDepth,
          ),
          (
            id: 'info',
            label: 'Info',
            icon: Icons.info_outline_rounded,
            accentColor: AppModuleAccents.trade,
            badgeLabel: null,
            onTap: onInfo,
          ),
          (
            id: 'alert',
            label: 'Alert',
            icon: Icons.notifications_none_rounded,
            accentColor: AppColors.warn,
            badgeLabel: alertBadgeCount > 0 ? '$alertBadgeCount' : null,
            onTap: onAlert,
          ),
        ];

    return VitActionTileGrid(
      density: VitDensity.compact,
      crossAxisCount: 4,
      childAspectRatio: 1.15,
      itemCount: tools.length,
      itemBuilder: (context, index, tileDensity) {
        final tool = tools[index];
        return VitServiceTile(
          key: ConvertPage.toolKey(tool.id),
          density: tileDensity,
          icon: tool.icon,
          label: tool.label,
          accentColor: tool.accentColor,
          badgeLabel: tool.badgeLabel,
          onTap: tool.onTap,
        );
      },
    );
  }
}

class _SlippageRow extends StatelessWidget {
  const _SlippageRow({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<double> options;
  final double active;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitSectionHeader(title: 'Độ trượt giá', density: VitDensity.compact),
        const SizedBox(height: AppSpacing.x3),
        VitSegmentedChoice.withPrimaryAccent<double>(
          selected: active,
          onChanged: onChanged,
          height: AppSpacing.convertChipHeight,
          options: [
            for (final option in options)
              VitSegmentedChoiceOption<double>(
                key: ConvertPage.slippageKey(option.toString()),
                value: option,
                label: '${option.toStringAsFixed(option % 1 == 0 ? 0 : 1)}%',
              ),
          ],
        ),
      ],
    );
  }
}

class _ConvertRiskReviewPanel extends StatelessWidget {
  const _ConvertRiskReviewPanel({
    required this.quote,
    required this.fromSymbol,
    required this.toSymbol,
    required this.slippage,
  });

  final TradeConvertQuote quote;
  final String fromSymbol;
  final String toSymbol;
  final double slippage;

  @override
  Widget build(BuildContext context) {
    return VitFinancialSafetySummary(
      title: 'Xem lại báo giá',
      contractId: 'SC-056 Convert preview',
      density: VitDensity.compact,
      footer: quote.canSubmit
          ? 'Xác nhận tỷ giá, phí, giới hạn trượt giá và đường nhận biên lai trước khi gửi.'
          : 'Nhập số lượng để mở xem lại báo giá trước khi gửi.',
      items: [
        VitFinancialSafetyItem(
          label: 'Tỷ giá',
          value: quote.quoteLabel,
          leading: const Icon(Icons.sync_alt_rounded),
        ),
        VitFinancialSafetyItem(
          label: 'Dự kiến nhận',
          value:
              '${formatConvertQuoteAmount(quote.toAmount, toSymbol)} $toSymbol',
          leading: const Icon(Icons.account_balance_wallet_outlined),
          valueColor: quote.canSubmit ? AppColors.buy : AppColors.text3,
        ),
        VitFinancialSafetyItem(
          label: 'Phí',
          value: '\$${quote.feeUsd.toStringAsFixed(quote.feeUsd < 1 ? 4 : 2)}',
          leading: const Icon(Icons.receipt_long_outlined),
          valueColor: AppColors.text2,
        ),
        VitFinancialSafetyItem(
          label: 'Giới hạn trượt',
          value: '${slippage.toStringAsFixed(1)}%',
          leading: const Icon(Icons.speed_outlined),
          valueColor: AppColors.text2,
        ),
        VitFinancialSafetyItem(
          label: 'Kiểm tra rủi ro',
          value: quote.canSubmit ? 'Sẵn sàng gửi' : 'Cần nhập số lượng',
          leading: const Icon(Icons.verified_user_outlined),
          valueColor: quote.canSubmit ? AppColors.warn : AppColors.text3,
        ),
      ],
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.enabled,
    required this.receipt,
    required this.onPressed,
  });

  final bool enabled;
  final TradeConvertReceipt? receipt;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final label = receipt == null
        ? (enabled ? 'Chuyển đổi ngay' : 'Nhập số lượng')
        : 'Đã gửi ${receipt!.convertId}';
    return VitCtaButton(
      key: ConvertPage.submitKey,
      onPressed: enabled ? onPressed : null,
      variant: receipt == null
          ? VitCtaButtonVariant.primary
          : VitCtaButtonVariant.success,
      height: AppSpacing.convertSubmitHeight,
      leading: Icon(
        receipt == null
            ? Icons.swap_vert_rounded
            : Icons.check_circle_outline_rounded,
      ),
      child: Text(label),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.records});

  final List<TradeConvertHistoryRecord> records;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.zeroInsets,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < records.length; i++)
            ConvertHistoryRow(
              record: records[i],
              showDivider: i != records.length - 1,
            ),
        ],
      ),
    );
  }
}
