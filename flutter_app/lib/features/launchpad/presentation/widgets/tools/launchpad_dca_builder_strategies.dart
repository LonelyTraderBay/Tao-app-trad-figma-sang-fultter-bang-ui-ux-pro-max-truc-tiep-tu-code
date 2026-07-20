import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:vit_trade_flutter/app/theme/accent_tone_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/launchpad/domain/entities/launchpad_entities.dart';
import 'package:vit_trade_flutter/features/launchpad/presentation/widgets/tools/launchpad_dca_builder_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/launchpad_spacing_tokens.dart';

class LaunchpadDcaStrategiesSection extends StatelessWidget {
  const LaunchpadDcaStrategiesSection({
    super.key,
    required this.sectionKey,
    required this.strategyKey,
    required this.strategies,
  });

  final Key sectionKey;
  final Key Function(String id) strategyKey;
  final List<LaunchpadDcaStrategyDraft> strategies;

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: sectionKey,
      child: VitPageSection(
        label: 'Cac chien luoc',
        accentColor: AppColors.primary,
        children: [
          for (final strategy in strategies)
            _StrategyCard(
              cardKey: strategyKey(strategy.id),
              strategy: strategy,
            ),
        ],
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String message) {
  unawaited(HapticFeedback.selectionClick());
  unawaited(showVitNoticeSheet(
    context: context,
    title: 'Sắp ra mắt',
    message: message,
  ));
}

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.cardKey, required this.strategy});

  final Key cardKey;
  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final isActive = strategy.status == LaunchpadDcaStrategyStatus.active;
    return VitCard(
      key: cardKey,
      padding: LaunchpadSpacingTokens.launchpadPaddingX4,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TrendIcon(accent: strategy.accent.resolve()),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strategy.token,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Wrap(
                      spacing: AppSpacing.x2,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          launchpadDcaFrequencyLabel(strategy.frequency),
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                        _StatusPill(status: strategy.status),
                      ],
                    ),
                  ],
                ),
              ),
              _MiniIconButton(
                icon: isActive ? Icons.pause_rounded : Icons.play_arrow_rounded,
                color: isActive ? AppColors.text3 : AppColors.buy,
                onTap: () => _showComingSoon(
                  context,
                  'Tạm dừng/tiếp tục chiến lược sẽ sớm ra mắt',
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _MiniIconButton(
                icon: Icons.settings_outlined,
                color: AppColors.text3,
                onTap: () => _showComingSoon(
                  context,
                  'Cài đặt chiến lược sẽ sớm ra mắt',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _StrategyMetricsGrid(strategy: strategy),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _PnlBand(strategy: strategy),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          const Divider(
            height: AppSpacing.dividerHairline,
            color: AppColors.border,
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                color: AppColors.text3,
                size: LaunchpadSpacingTokens.launchpadIconXs,
              ),
              const SizedBox(width: AppSpacing.x1),
              Expanded(
                child: Text(
                  'Next: ${strategy.nextBuy}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${strategy.executedOrders} orders - \$${strategy.amount.toStringAsFixed(0)}/order',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendIcon extends StatelessWidget {
  const _TrendIcon({required this.accent});

  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: LaunchpadSpacingTokens.launchpadBox40,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: accent.withValues(alpha: .12),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
        ),
        child: Icon(
          Icons.trending_up_rounded,
          color: accent,
          size: LaunchpadSpacingTokens.launchpadIcon3xl,
        ),
      ),
    );
  }
}

class _MiniIconButton extends StatelessWidget {
  const _MiniIconButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitIconButton(
      icon: icon,
      tooltip: 'Thao tac chien luoc',
      onPressed: onTap,
      variant: color == AppColors.sell
          ? VitIconButtonVariant.danger
          : VitIconButtonVariant.primary,
      size: VitIconButtonSize.sm,
    );
  }
}

class _StrategyMetricsGrid extends StatelessWidget {
  const _StrategyMetricsGrid({required this.strategy});

  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: LaunchpadSpacingTokens.launchpadGridColumns,
      mainAxisSpacing: AppSpacing.x3,
      crossAxisSpacing: AppSpacing.x3,
      childAspectRatio: LaunchpadSpacingTokens.launchpadGridAspectAction,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      children: [
        _MetricBlock(
          label: 'Invested',
          value: launchpadDcaFormatMoney(strategy.totalInvested),
        ),
        _MetricBlock(
          label: 'Current Value',
          value: launchpadDcaFormatMoney(strategy.currentValue),
          valueColor: strategy.pnl >= 0 ? AppColors.buy : AppColors.sell,
        ),
        _MetricBlock(
          label: 'Tokens',
          value:
              '${strategy.totalTokens.toStringAsFixed(2)} ${strategy.symbol}',
        ),
        _MetricBlock(
          label: 'Avg Price',
          value: launchpadDcaFormatPrice(strategy.avgPrice),
        ),
      ],
    );
  }
}

class _MetricBlock extends StatelessWidget {
  const _MetricBlock({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: valueColor,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PnlBand extends StatelessWidget {
  const _PnlBand({required this.strategy});

  final LaunchpadDcaStrategyDraft strategy;

  @override
  Widget build(BuildContext context) {
    final color = strategy.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: color.withValues(alpha: .10),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
      ),
      child: Padding(
        padding: LaunchpadSpacingTokens.launchpadPillPadding,
        child: Row(
          children: [
            Expanded(
              child: Text(
                'P/L',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${strategy.pnl >= 0 ? '+' : ''}${strategy.pnlPercent.toStringAsFixed(2)}% (${strategy.pnl >= 0 ? r'$' : r'-$'}${strategy.pnl.abs().toStringAsFixed(2)})',
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final LaunchpadDcaStrategyStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      LaunchpadDcaStrategyStatus.active => AppColors.buy,
      LaunchpadDcaStrategyStatus.paused => AppColors.warn,
      LaunchpadDcaStrategyStatus.completed => AppColors.text3,
    };
    return VitAccentPill(
      label: status.name.toUpperCase(),
      accentColor: color,
      backgroundAlpha: .12,
      radiusOverride: AppRadii.xsRadius,
    );
  }
}
