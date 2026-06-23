part of 'savings_auto_rebalance_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.strategy,
    required this.active,
    required this.onTap,
  });

  final SavingsRebalanceStrategyDraft strategy;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _riskColor(strategy.riskLevel);

    return VitCard(
      key: SavingsAutoRebalancePage.strategyKey(strategy.id),
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX3,
      borderColor: active ? color.withValues(alpha: .42) : null,
      onTap: onTap,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: _savingsRebalanceIconBox,
                child: Material(
                  color: color.withValues(alpha: .14),
                  borderRadius: AppRadii.mdRadius,
                  child: Icon(_riskIcon(strategy.riskLevel), color: color),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        _TonePill(
                          label: _riskLabel(strategy.riskLevel),
                          color: color,
                        ),
                        if (active) ...[
                          const SizedBox(width: AppSpacing.x2),
                          Icon(
                            Icons.check_circle_rounded,
                            color: color,
                            size: _savingsRebalanceSelectedIcon,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${strategy.expectedApy.toStringAsFixed(2)}%',
                    style: _captionMedium.copyWith(color: color),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          if (active) ...[
            const SizedBox(height: AppSpacing.x3),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: Row(
                children: [
                  for (final entry in strategy.allocations.entries)
                    Expanded(
                      flex: entry.value.round().clamp(1, 100).toInt(),
                      child: ColoredBox(
                        color: _assetColorName(entry.key),
                        child: const SizedBox(
                          height: _savingsRebalanceTrackHeight,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StrategyComparison extends StatelessWidget {
  const _StrategyComparison({required this.strategies});

  final List<SavingsRebalanceStrategyDraft> strategies;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: _savingsRebalanceCardPadding,
      child: VitPageContent(
        padding: VitContentPadding.none,
        density: VitDensity.compact,
        children: [
          const _SectionTitle(
            icon: Icons.info_outline_rounded,
            iconColor: AppColors.primary,
            label: 'So sánh chiến lược',
          ),
          for (final row in [
            ('APY', [for (final item in strategies) '${item.expectedApy}%']),
            (
              'Rủi ro',
              [for (final item in strategies) _riskLabel(item.riskLevel)],
            ),
            (
              'Stablecoin',
              [
                for (final item in strategies)
                  '${item.allocations['USDT']?.toStringAsFixed(0)}%',
              ],
            ),
            (
              'BTC',
              [
                for (final item in strategies)
                  '${item.allocations['BTC']?.toStringAsFixed(0)}%',
              ],
            ),
          ])
            _CompareRow(label: row.$1, values: row.$2),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  const _HistoryList({required this.history});

  final List<SavingsRebalanceHistoryDraft> history;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: '${history.length} lần tái cân bằng',
      accentColor: AppColors.primary,
      density: VitDensity.compact,
      children: [for (final event in history) _HistoryCard(event: event)],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.event});

  final SavingsRebalanceHistoryDraft event;

  @override
  Widget build(BuildContext context) {
    final color = _historyColor(event.status);

    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX3,
      child: Row(
        children: [
          SizedBox.square(
            dimension: _savingsRebalanceIconBox,
            child: Material(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.mdRadius,
              child: Icon(
                _historyIcon(event.status),
                color: color,
                size: _savingsRebalanceIcon,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      event.strategy,
                      style: _captionMedium.copyWith(color: AppColors.text1),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _TonePill(label: _historyLabel(event.status), color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${event.date} · ${event.actions} thao tác · ${_formatUsd(event.totalMoved)}',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '${event.driftBefore.toStringAsFixed(1)}% → ${event.driftAfter.toStringAsFixed(1)}%',
            style: _captionMedium.copyWith(color: AppColors.text2),
          ),
        ],
      ),
    );
  }
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({
    required this.settings,
    required this.autoEnabled,
    required this.onAutoChanged,
  });

  final SavingsRebalanceSettingsDraft settings;
  final bool autoEnabled;
  final ValueChanged<bool> onAutoChanged;

  @override
  Widget build(BuildContext context) {
    return VitPageContent(
      padding: VitContentPadding.none,
      density: VitDensity.compact,
      children: [
        _AutoStatusCard(
          autoEnabled: autoEnabled,
          settings: settings,
          onChanged: onAutoChanged,
        ),
        VitCard(
          radius: VitCardRadius.lg,
          padding: _savingsRebalanceCardPadding,
          child: Column(
            children: [
              _SettingsRow(
                icon: Icons.calendar_today_rounded,
                label: 'Tần suất',
                value: settings.frequencyLabel,
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.tune_rounded,
                label: 'Ngưỡng rebalance',
                value: '${settings.driftThreshold.toStringAsFixed(0)}%',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.lock_outline_rounded,
                label: 'Bỏ qua vị thế khóa',
                value: settings.skipLocked ? 'Bật' : 'Tắt',
              ),
              const Divider(color: AppColors.divider),
              _SettingsRow(
                icon: Icons.payments_outlined,
                label: 'Lệnh tối thiểu',
                value: _formatUsd(settings.minTradeSize),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewSheet extends StatelessWidget {
  const _PreviewSheet({
    required this.snapshot,
    required this.strategy,
    required this.drift,
    required this.onClose,
  });

  final SavingsAutoRebalanceSnapshot snapshot;
  final SavingsRebalanceStrategyDraft strategy;
  final double drift;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final actions = _rebalanceActions(snapshot, strategy);
    final totalMove = actions.fold<double>(0, (sum, item) => sum + item.amount);

    return ColoredBox(
      color: AppColors.dynamicIslandBg.withValues(alpha: .55),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: VitCard(
          key: SavingsAutoRebalancePage.previewSheetKey,
          radius: VitCardRadius.lg,
          padding: _savingsRebalanceCardPadding,
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Xem trước tái cân bằng',
                        style: _baseBold.copyWith(color: AppColors.text1),
                      ),
                    ),
                    VitIconButton(
                      icon: Icons.close_rounded,
                      tooltip: 'Đóng',
                      onPressed: onClose,
                      variant: VitIconButtonVariant.transparent,
                      size: VitIconButtonSize.md,
                    ),
                  ],
                ),
                _PreviewRow(label: 'Chiến lược', value: strategy.name),
                _PreviewRow(
                  label: 'Drift hiện tại',
                  value: '${drift.toStringAsFixed(1)}%',
                  valueColor: _driftColor(drift),
                ),
                _PreviewRow(
                  label: 'Tổng di chuyển ước tính',
                  value: _formatUsd(totalMove / 2),
                ),
                _PreviewRow(label: 'Số thao tác', value: '${actions.length}'),
                const SizedBox(height: AppSpacing.x3),
                for (final action in actions.take(3))
                  Padding(
                    padding: AppSpacing.earnBottomPaddingX2,
                    child: Row(
                      children: [
                        Icon(
                          action.increase
                              ? Icons.arrow_upward_rounded
                              : Icons.arrow_downward_rounded,
                          color: action.increase
                              ? AppColors.buy
                              : AppColors.sell,
                          size: _savingsRebalanceInlineIcon,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            '${action.increase ? 'Tăng' : 'Giảm'} ${action.asset}',
                            style: _captionMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        Text(
                          _formatUsd(action.amount),
                          style: _captionMedium.copyWith(
                            color: action.increase
                                ? AppColors.buy
                                : AppColors.sell,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: AppSpacing.x2),
                VitCtaButton(
                  onPressed: onClose,
                  variant: VitCtaButtonVariant.warning,
                  child: const Text('Xác nhận tái cân bằng'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.iconColor,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: _savingsRebalanceInlineIcon),
        const SizedBox(width: AppSpacing.x2),
        Text(label, style: _captionMedium.copyWith(color: AppColors.text1)),
      ],
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color color;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: AppSpacing.earnPaddingX3,
      child: Column(
        children: [
          Icon(icon, color: color, size: _savingsRebalanceInlineIcon),
          const SizedBox(height: AppSpacing.x2),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: _smBold.copyWith(color: AppColors.text1)),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _TonePill extends StatelessWidget {
  const _TonePill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: .12),
      borderRadius: AppRadii.xsRadius,
      child: Padding(
        padding: AppSpacing.earnSmallPillPadding,
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: _savingsRebalanceLegendDot,
          child: Material(color: color, shape: const CircleBorder()),
        ),
        const SizedBox(width: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _AxisText extends StatelessWidget {
  const _AxisText(this.text, {this.align = TextAlign.left});

  final String text;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
    );
  }
}
