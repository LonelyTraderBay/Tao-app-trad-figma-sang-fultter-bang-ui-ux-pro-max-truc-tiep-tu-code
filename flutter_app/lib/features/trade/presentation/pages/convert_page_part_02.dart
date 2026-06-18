part of 'convert_page.dart';

class _SwapButton extends StatelessWidget {
  const _SwapButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ConvertPage.swapKey,
      onTap: onTap,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      width: AppSpacing.buttonStandard - AppSpacing.rowGapRegular,
      height: AppSpacing.buttonStandard - AppSpacing.rowGapRegular,
      alignment: Alignment.center,
      borderColor: _tradePrimary.withValues(alpha: .45),
      child: const Icon(
        Icons.swap_vert_rounded,
        color: _tradePrimary,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

class _ToolRow extends StatelessWidget {
  const _ToolRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.inputHeight - AppSpacing.rowPy,
      child: Row(
        children: const [
          Expanded(
            child: _ToolChip(
              id: 'chart',
              label: 'Chart',
              icon: Icons.bar_chart_rounded,
            ),
          ),
          SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: _ToolChip(
              id: 'depth',
              label: 'Depth',
              icon: Icons.layers_outlined,
            ),
          ),
          SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: _ToolChip(
              id: 'info',
              label: 'Info',
              icon: Icons.info_outline_rounded,
            ),
          ),
          SizedBox(width: AppSpacing.rowGap),
          Expanded(
            child: _ToolChip(
              id: 'alert',
              label: 'Alert',
              icon: Icons.notifications_none_rounded,
              badge: true,
            ),
          ),
          SizedBox(width: AppSpacing.rowGap),
          _SettingsChip(),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  const _ToolChip({
    required this.id,
    required this.label,
    required this.icon,
    this.badge = false,
  });

  final String id;
  final String label;
  final IconData icon;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ConvertPage.toolKey(id),
      onTap: () {},
      radius: VitCardRadius.lg,
      variant: VitCardVariant.inner,
      height: AppSpacing.inputHeight - AppSpacing.rowPy,
      alignment: Alignment.center,
      borderColor: _tradePrimary.withValues(alpha: .14),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: AppSpacing.iconSm, color: AppColors.text3),
                const SizedBox(width: AppSpacing.x2),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (badge)
            Positioned(
              top: -3,
              right: AppSpacing.x2,
              child: VitCard(
                width: 16,
                height: 16,
                variant: VitCardVariant.ghost,
                radius: VitCardRadius.lg,
                alignment: Alignment.center,
                borderColor: AppColors.sell,
                child: Text(
                  '1',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SettingsChip extends StatelessWidget {
  const _SettingsChip();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ConvertPage.toolKey('settings'),
      onTap: () {},
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      width: AppSpacing.inputHeight - AppSpacing.rowPy,
      height: AppSpacing.inputHeight - AppSpacing.rowPy,
      alignment: Alignment.center,
      borderColor: _tradePrimary.withValues(alpha: .14),
      child: const Icon(
        Icons.settings_outlined,
        color: AppColors.text3,
        size: AppSpacing.iconSm,
      ),
    );
  }
}

class _PairMiniCard extends StatelessWidget {
  const _PairMiniCard({required this.fromSymbol, required this.toSymbol});

  final String fromSymbol;
  final String toSymbol;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.buttonStandard,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x4,
        right: AppSpacing.x4,
      ),
      child: Row(
        children: [
          Text(
            '$fromSymbol/$toSymbol · 24h',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.show_chart_rounded,
            color: AppColors.buy,
            size: AppSpacing.iconSm,
          ),
          const Spacer(),
          SizedBox(
            width: AppSpacing.convertPairSparklineWidth,
            height: AppSpacing.convertPairSparklineHeight,
            child: const VitSparkline(
              values: [3.2, 3.8, 3.5, 4.4, 4.0, 4.8, 4.6, 5.2],
              color: AppColors.buy,
              showFill: false,
              strokeWidth: 1.7,
            ),
          ),
          const SizedBox(width: AppSpacing.rowGap),
          Text(
            '+0.62%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SlippageCard extends StatelessWidget {
  const _SlippageCard({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<double> options;
  final double active;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      height: AppSpacing.convertSlippageCardHeight,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.x4,
        top: AppSpacing.x4,
        right: AppSpacing.x4,
        bottom: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Slippage tolerance',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.rowGap),
              Text(
                'Tùy chỉnh',
                style: AppTextStyles.micro.copyWith(
                  color: _tradePrimary,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final option in options) ...[
                _SlippageChip(
                  key: ConvertPage.slippageKey(option.toString()),
                  label: '${option.toStringAsFixed(option % 1 == 0 ? 0 : 1)}%',
                  active: option == active,
                  onTap: () => onChanged(option),
                ),
                const SizedBox(width: AppSpacing.rowGap),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _SlippageChip extends StatelessWidget {
  const _SlippageChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      onPressed: onTap,
      fullWidth: false,
      height: AppSpacing.buttonCompact,
      variant: active ? VitCtaButtonVariant.primary : VitCtaButtonVariant.ghost,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.rowPy,
        right: AppSpacing.rowPy,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: active ? AppColors.onAccent : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
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
    return VitHighRiskStatePanel(
      state: quote.canSubmit
          ? VitHighRiskUiState.riskReview
          : VitHighRiskUiState.empty,
      title: quote.canSubmit
          ? 'Preview convert quote'
          : 'Enter amount to preview',
      message:
          'Confirm $fromSymbol/$toSymbol rate, fee, ${slippage.toStringAsFixed(1)}% slippage limit, network risk, and next-step receipt before submitting.',
      contractId: 'SC-056 Convert preview',
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
      height: AppSpacing.inputHeight,
      leading: Icon(
        receipt == null
            ? Icons.swap_vert_rounded
            : Icons.check_circle_outline_rounded,
      ),
      child: Text(label),
    );
  }
}

class _HistoryHeader extends StatelessWidget {
  const _HistoryHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Giao dịch gần đây',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.rowGapRegular),
        const Icon(
          Icons.download_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          'Xuất',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(width: AppSpacing.rowGapRegular),
        Text(
          'Xem tất cả',
          style: AppTextStyles.micro.copyWith(
            color: _tradePrimary,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(width: AppSpacing.dividerHairline),
        const Icon(
          Icons.chevron_right_rounded,
          color: _tradePrimary,
          size: AppSpacing.iconMd,
        ),
      ],
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
