part of '../pages/launchpad_swap_aggregator_page.dart';

class _HistorySection extends StatelessWidget {
  const _HistorySection({required this.history});

  final List<LaunchpadSwapHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.historyKey,
      child: VitPageSection(
        label: 'Giao dich gan day',
        accentColor: AppColors.buy,
        children: [
          for (final swap in history)
            VitCard(
              padding: AppSpacing.launchpadPaddingX3,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: AppSpacing.x2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              '${swap.from} -> ${swap.to}',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            _StatusPill(status: swap.status),
                          ],
                        ),
                      ),
                      Text(
                        '${swap.amount.toStringAsFixed(0)} ${swap.from}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          swap.dex,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Text(
                        '@${swap.rate.toStringAsFixed(2)}',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          swap.timestamp,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ),
                      Text(
                        swap.txHash,
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LaunchpadSwapStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      LaunchpadSwapStatus.success => AppColors.buy,
      LaunchpadSwapStatus.pending => AppColors.primary,
      LaunchpadSwapStatus.failed => AppColors.sell,
    };
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .12),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsRadius),
      ),
      child: Padding(
        padding: AppSpacing.launchpadBadgePadding,
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: AppSpacing.launchpadLineHeightTight,
          ),
        ),
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.slippage,
    required this.autoRefresh,
    required this.onSlippageChanged,
    required this.onAutoRefreshChanged,
  });

  final String slippage;
  final bool autoRefresh;
  final ValueChanged<String> onSlippageChanged;
  final ValueChanged<bool> onAutoRefreshChanged;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: LaunchpadSwapAggregatorPage.settingsKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          VitPageSection(
            label: 'Slippage & Gas',
            accentColor: AppColors.primary,
            children: [
              VitCard(
                padding: AppSpacing.launchpadPaddingX4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slippage Tolerance (%)',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Row(
                      children: [
                        for (final value in ['0.1', '0.5', '1.0', '3.0']) ...[
                          Expanded(
                            child: _SlippageButton(
                              value: value,
                              active: slippage == value,
                              onTap: () => onSlippageChanged(value),
                            ),
                          ),
                          if (value != '3.0')
                            const SizedBox(width: AppSpacing.x2),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x4),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Auto Refresh',
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              Text(
                                'Cap nhat gia moi 10s',
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          key: LaunchpadSwapAggregatorPage.autoRefreshKey,
                          value: autoRefresh,
                          activeThumbColor: AppColors.primary,
                          onChanged: onAutoRefreshChanged,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitPageSection(
            label: 'An toan',
            accentColor: AppColors.accent,
            children: [
              DecoratedBox(
                decoration: const ShapeDecoration(
                  color: AppColors.accent08,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: AppColors.accent20),
                    borderRadius: AppRadii.cardRadius,
                  ),
                ),
                child: Padding(
                  padding: AppSpacing.launchpadPaddingX3,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline_rounded,
                        color: AppColors.accent,
                        size: AppSpacing.launchpadIconLg,
                      ),
                      const SizedBox(width: AppSpacing.x2),
                      Expanded(
                        child: Text(
                          'Luon kiem tra dia chi hop dong va chi swap tren cac DEX uy tin. Khong chia se private key.',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text2,
                            height: AppSpacing.launchpadLineHeightLong,
                          ),
                        ),
                      ),
                    ],
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

class _SlippageButton extends StatelessWidget {
  const _SlippageButton({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final String value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LaunchpadSwapAggregatorPage.slippageKey(value),
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: SizedBox(
        height: AppSpacing.launchpadBox40,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            color: active ? AppColors.primary : AppColors.bg,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.inputRadius,
            ),
          ),
          child: Center(
            child: Text(
              '$value%',
              style: AppTextStyles.caption.copyWith(
                color: active ? AppColors.onAccent : AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
