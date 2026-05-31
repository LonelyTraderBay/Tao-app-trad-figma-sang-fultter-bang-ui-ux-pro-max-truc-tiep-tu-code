import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/dca/domain/entities/dca_entities.dart';
import 'package:vit_trade_flutter/features/dca/presentation/widgets/dca_backtester_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DcaBacktesterSetup extends StatelessWidget {
  const DcaBacktesterSetup({
    super.key,
    required this.snapshot,
    required this.asset,
    required this.frequency,
    required this.strategy,
    required this.runKey,
    required this.strategyKey,
    required this.onAssetChanged,
    required this.onFrequencyChanged,
    required this.onStrategyChanged,
    required this.onRun,
  });

  final DcaBacktesterSnapshot snapshot;
  final String asset;
  final DcaBacktestFrequency frequency;
  final DcaBacktestStrategy strategy;
  final Key runKey;
  final Key Function(DcaBacktestStrategy strategy) strategyKey;
  final ValueChanged<String> onAssetChanged;
  final ValueChanged<DcaBacktestFrequency> onFrequencyChanged;
  final ValueChanged<DcaBacktestStrategy> onStrategyChanged;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AssetCard(
          assets: snapshot.assets,
          selected: asset,
          onChanged: onAssetChanged,
        ),
        const SizedBox(height: AppSpacing.x5),
        _DateRangeCard(
          startDate: snapshot.startDate,
          endDate: snapshot.endDate,
        ),
        const SizedBox(height: AppSpacing.x5),
        _InvestmentCard(
          amountUsd: snapshot.investmentAmountUsd,
          frequencies: snapshot.frequencies,
          selected: frequency,
          onChanged: onFrequencyChanged,
        ),
        const SizedBox(height: AppSpacing.x5),
        const DcaSectionLabel(label: 'Chiến lược'),
        const SizedBox(height: AppSpacing.x5),
        _StrategyCards(
          strategies: snapshot.strategies,
          selected: strategy,
          strategyKey: strategyKey,
          onChanged: onStrategyChanged,
        ),
        if (strategy == DcaBacktestStrategy.buyDips) ...[
          const SizedBox(height: AppSpacing.x5),
          const _DipThresholdCard(),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCtaButton(
          key: runKey,
          onPressed: onRun,
          leading: const Icon(
            Icons.play_arrow_rounded,
            color: AppColors.onAccent,
            size: AppSpacing.iconMd,
          ),
          child: const Text('Run Backtest'),
        ),
        const SizedBox(height: AppSpacing.x5),
        const _BacktestDisclaimer(),
      ],
    );
  }
}

class _AssetCard extends StatelessWidget {
  const _AssetCard({
    required this.assets,
    required this.selected,
    required this.onChanged,
  });

  final List<String> assets;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DcaCardTitle('Chọn tài sản'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final asset in assets) ...[
                Expanded(
                  child: DcaSelectionButton(
                    label: asset,
                    selected: asset == selected,
                    onTap: () => onChanged(asset),
                  ),
                ),
                if (asset != assets.last) const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _DateRangeCard extends StatelessWidget {
  const _DateRangeCard({required this.startDate, required this.endDate});

  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DcaCardTitle('Khung thời gian'),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: DcaReadOnlyField(
                  label: 'Start Date',
                  value: startDate,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: DcaReadOnlyField(
                  label: 'End Date',
                  value: endDate,
                  icon: Icons.calendar_today_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InvestmentCard extends StatelessWidget {
  const _InvestmentCard({
    required this.amountUsd,
    required this.frequencies,
    required this.selected,
    required this.onChanged,
  });

  final int amountUsd;
  final List<DcaBacktestFrequencyOption> frequencies;
  final DcaBacktestFrequency selected;
  final ValueChanged<DcaBacktestFrequency> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DcaReadOnlyField(
            label: 'Investment Amount per Period (USD)',
            value: amountUsd.toString(),
          ),
          const SizedBox(height: AppSpacing.x5),
          Text(
            'Frequency',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - AppSpacing.x3) / 2;
              return Wrap(
                spacing: AppSpacing.x3,
                runSpacing: AppSpacing.x3,
                children: [
                  for (final frequency in frequencies)
                    SizedBox(
                      width: width,
                      child: DcaSelectionButton(
                        label: frequency.label,
                        selected: frequency.frequency == selected,
                        onTap: () => onChanged(frequency.frequency),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StrategyCards extends StatelessWidget {
  const _StrategyCards({
    required this.strategies,
    required this.selected,
    required this.strategyKey,
    required this.onChanged,
  });

  final List<DcaBacktestStrategyOption> strategies;
  final DcaBacktestStrategy selected;
  final Key Function(DcaBacktestStrategy strategy) strategyKey;
  final ValueChanged<DcaBacktestStrategy> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final strategy in strategies) ...[
          _StrategyCard(
            cardKey: strategyKey(strategy.strategy),
            option: strategy,
            selected: strategy.strategy == selected,
            onTap: () => onChanged(strategy.strategy),
          ),
          if (strategy != strategies.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({
    required this.cardKey,
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final Key cardKey;
  final DcaBacktestStrategyOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: cardKey,
      variant: VitCardVariant.ghost,
      width: double.infinity,
      borderColor: selected ? AppColors.primary : AppColors.cardBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            option.title,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            option.subtitle,
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DipThresholdCard extends StatelessWidget {
  const _DipThresholdCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: const DcaReadOnlyField(label: 'Dip Threshold (%)', value: '5'),
    );
  }
}

class _BacktestDisclaimer extends StatelessWidget {
  const _BacktestDisclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.warn15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                'Backtest dựa trên dữ liệu lịch sử. Hiệu suất quá khứ không đảm bảo kết quả tương lai. Chỉ mang tính tham khảo.',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
