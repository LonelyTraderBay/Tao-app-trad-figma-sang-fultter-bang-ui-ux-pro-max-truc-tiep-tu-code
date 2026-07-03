import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Visual skin for copy-trading provider lists (SC-063 classic vs SC-064 v2).
enum CopyTradingListSkin { classic, v2 }

/// Widget keys shared by copy-trading page libraries.
final class CopyTradingListKeys {
  const CopyTradingListKeys({
    required this.traderKey,
    required this.detailKey,
    required this.sortKey,
  });

  final Key Function(String id) traderKey;
  final Key Function(String id) detailKey;
  final Key Function(String option) sortKey;
}

List<TradeCopyTrader> sortCopyTraders(
  List<TradeCopyTrader> traders,
  String sortBy,
) {
  final sorted = [...traders];
  if (sortBy == 'Ổn định nhất') {
    sorted.sort((a, b) => b.sharpeRatio.compareTo(a.sharpeRatio));
  } else if (sortBy == 'Nhiều copier') {
    sorted.sort((a, b) => b.copiers.compareTo(a.copiers));
  } else if (sortBy == 'AUM cao') {
    sorted.sort((a, b) => b.aum.compareTo(a.aum));
  } else {
    sorted.sort((a, b) => b.totalPnlPct.compareTo(a.totalPnlPct));
  }
  return sorted;
}

class CopyTradingRiskWarningCard extends StatelessWidget {
  const CopyTradingRiskWarningCard({
    super.key,
    required this.title,
    required this.message,
    this.contractId = 'Copy trading provider risk disclosure',
    this.v2PreviewCopy = false,
  });

  final String title;
  final String message;
  final String contractId;
  final bool v2PreviewCopy;

  @override
  Widget build(BuildContext context) {
    final body = v2PreviewCopy
        ? '$message Preview, fees, allocation limit and confirmation are reviewed before copying.'
        : message;

    final panel = VitHighRiskStatePanel(
      state: VitHighRiskUiState.riskReview,
      title: title,
      message: body,
      contractId: contractId,
      density: VitDensity.compact,
    );

    if (!v2PreviewCopy) {
      return panel;
    }

    return VitCard(
      density: VitDensity.compact,
      padding: AppSpacing.zeroInsets.copyWith(
        left: AppSpacing.tradePageContentGap,
        top: AppSpacing.x2,
        right: AppSpacing.tradePageContentGap,
        bottom: AppSpacing.x2,
      ),
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      child: panel,
    );
  }
}

class CopyTradingSortChips extends StatelessWidget {
  const CopyTradingSortChips({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    required this.keys,
    this.skin = CopyTradingListSkin.classic,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return VitTabBar(
        activeKey: selected,
        onChanged: onChanged,
        tabs: [
          for (final option in options)
            VitTabItem(
              key: option,
              label: option,
              widgetKey: keys.sortKey(option),
            ),
        ],
      );
    }

    return VitPresetChipRow<String>(
      items: [
        for (final option in options)
          VitPresetChipItem(
            value: option,
            label: option,
            key: keys.sortKey(option),
            semanticLabel: 'Sap xep copy trading theo $option',
          ),
      ],
      selectedValue: selected,
      onTap: onChanged,
      height: AppSpacing.copyTradingV2SortChipHeight,
    );
  }
}

class CopyTradingTraderList extends StatelessWidget {
  const CopyTradingTraderList({
    super.key,
    required this.traders,
    required this.onOpen,
    required this.keys,
    this.skin = CopyTradingListSkin.classic,
  });

  final List<TradeCopyTrader> traders;
  final ValueChanged<TradeCopyTrader> onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      density: VitDensity.compact,
      child: Column(
        children: [
          for (var i = 0; i < traders.length; i++) ...[
            _CopyTraderCard(
              trader: traders[i],
              onOpen: () => onOpen(traders[i]),
              keys: keys,
              skin: skin,
              grouped: true,
            ),
            if (i < traders.length - 1)
              const Divider(
                height: AppSpacing.dividerHairline,
                thickness: AppSpacing.dividerHairline,
                color: AppColors.divider,
              ),
          ],
        ],
      ),
    );
  }
}

class _CopyTraderCard extends StatelessWidget {
  const _CopyTraderCard({
    required this.trader,
    required this.onOpen,
    required this.keys,
    required this.skin,
    this.grouped = false,
  });

  final TradeCopyTrader trader;
  final VoidCallback onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;
  final bool grouped;

  @override
  Widget build(BuildContext context) {
    final tier = _tierFor(trader.copiers, skin);
    final cardSpace = AppSpacing.tradePageContentGap;
    final innerSpace = AppSpacing.x2;
    final risk = skin == CopyTradingListSkin.classic
        ? _riskFor(trader.riskLevel)
        : null;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CopyAvatarBadge(trader: trader, tier: tier, skin: skin),
            SizedBox(
              width: skin == CopyTradingListSkin.classic ? innerSpace : cardSpace,
            ),
            Expanded(
              child: skin == CopyTradingListSkin.v2
                  ? Padding(
                      padding: AppSpacing.zeroInsets.copyWith(
                        top: AppSpacing.dividerHairline,
                      ),
                      child: _CopyTraderHeader(
                        trader: trader,
                        tier: tier,
                        skin: skin,
                        risk: risk,
                      ),
                    )
                  : _CopyTraderHeader(
                      trader: trader,
                      tier: tier,
                      skin: skin,
                      risk: risk,
                    ),
            ),
            SizedBox(width: innerSpace),
            _CopyRoiBlock(trader: trader, skin: skin),
          ],
        ),
        SizedBox(
          height: skin == CopyTradingListSkin.classic ? innerSpace : cardSpace,
        ),
        if (skin == CopyTradingListSkin.classic) ...[
          _CopyMetricsGrid(trader: trader),
          SizedBox(height: innerSpace),
          _CopyWeeklyChart(values: trader.weeklyPnl),
          SizedBox(height: innerSpace),
        ],
        _CopyDetailsButton(
          traderId: trader.id,
          onOpen: onOpen,
          keys: keys,
          skin: skin,
        ),
      ],
    );

    if (grouped) {
      return Padding(
        key: keys.traderKey(trader.id),
        padding: AppSpacing.cardPaddingCompact,
        child: content,
      );
    }

    if (skin == CopyTradingListSkin.v2) {
      return VitCard(
        key: keys.traderKey(trader.id),
        density: VitDensity.compact,
        padding: AppSpacing.zeroInsets.copyWith(
          left: cardSpace,
          top: cardSpace,
          right: cardSpace,
          bottom: cardSpace,
        ),
        borderColor: AppColors.cardBorder,
        child: content,
      );
    }

    return VitCard(
      key: keys.traderKey(trader.id),
      density: VitDensity.compact,
      padding: AppSpacing.cardPaddingCompact,
      borderColor: AppColors.cardBorder,
      child: content,
    );
  }
}

class _CopyTraderHeader extends StatelessWidget {
  const _CopyTraderHeader({
    required this.trader,
    required this.tier,
    required this.skin,
    required this.risk,
  });

  final TradeCopyTrader trader;
  final _CopyTierStyle tier;
  final CopyTradingListSkin skin;
  final _CopyRiskStyle? risk;

  @override
  Widget build(BuildContext context) {
    final followColor =
        skin == CopyTradingListSkin.classic ? AppColors.caution : AppColors.warn;
    final followSize = skin == CopyTradingListSkin.classic
        ? AppSpacing.tradeBotSmallIcon
        : AppSpacing.iconSm;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Flexible(
              child: Text(
                trader.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            if (trader.isFollowing) ...[
              SizedBox(
                width: skin == CopyTradingListSkin.classic
                    ? AppSpacing.x1
                    : AppSpacing.x2,
              ),
              Icon(
                Icons.star_rounded,
                color: followColor,
                size: followSize,
              ),
            ],
          ],
        ),
        SizedBox(
          height: skin == CopyTradingListSkin.classic
              ? AppSpacing.x1
              : AppSpacing.x2,
        ),
        Wrap(
          spacing: AppSpacing.x2,
          runSpacing: AppSpacing.x2,
          children: [
            VitAccentPill(label: tier.label, accentColor: tier.color),
            for (final tag in trader.tags.take(2))
              VitAccentPill(label: tag, accentColor: AppColors.text2),
            if (risk != null)
              VitAccentPill(
                label: 'Rủi ro: ${risk!.label}',
                accentColor: risk!.color,
              ),
          ],
        ),
      ],
    );
  }
}

class _CopyAvatarBadge extends StatelessWidget {
  const _CopyAvatarBadge({
    required this.trader,
    required this.tier,
    required this.skin,
  });

  final TradeCopyTrader trader;
  final _CopyTierStyle tier;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return SizedBox(
        width: AppSpacing.walletAssetLogoSize,
        height: AppSpacing.walletAssetLogoSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            VitAssetAvatar(
              label: trader.avatar,
              accentColor: AppColors.primary,
              size: AppSpacing.tradeToolIconTileMd,
              radius: AppRadii.xlRadius,
              border: true,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: VitCard(
                width: AppSpacing.ctaLoadingIcon,
                height: AppSpacing.ctaLoadingIcon,
                variant: VitCardVariant.inner,
                radius: VitCardRadius.standard,
                density: VitDensity.compact,
                padding: AppSpacing.zeroInsets,
                borderColor: tier.color,
                alignment: Alignment.center,
                child: Icon(
                  tier.icon,
                  color: tier.color,
                  size: AppSpacing.x3 + AppSpacing.x1,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return SizedBox(
      width: AppSpacing.copyTradingV2TraderAvatarStackWidth,
      height: AppSpacing.copyTradingV2TraderAvatarStackHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          VitCard(
            width: AppSpacing.copyTradingV2TraderAvatarSize,
            height: AppSpacing.copyTradingV2TraderAvatarSize,
            alignment: Alignment.center,
            radius: VitCardRadius.large,
            variant: VitCardVariant.ghost,
            borderColor: AppColors.primary.withValues(alpha: .27),
            background: ColoredBox(
              color: AppColors.primary.withValues(alpha: .13),
            ),
            clip: true,
            child: Text(
              trader.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.primary,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Positioned(
            right: -AppSpacing.dividerHairline,
            bottom: AppSpacing.hairlineStroke,
            child: VitCard(
              width: AppSpacing.copyTradingV2TraderTierBadgeSize,
              height: AppSpacing.copyTradingV2TraderTierBadgeSize,
              alignment: Alignment.center,
              radius: VitCardRadius.large,
              borderColor: tier.color,
              child: Icon(
                tier.icon,
                color: tier.color,
                size: AppSpacing.copyTradingV2TraderTierBadgeIcon,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CopyRoiBlock extends StatelessWidget {
  const _CopyRoiBlock({required this.trader, required this.skin});

  final TradeCopyTrader trader;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    final maxWidth = skin == CopyTradingListSkin.classic
        ? 116.0
        : AppSpacing.copyTradingV2RoiMaxWidth;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: skin == CopyTradingListSkin.classic
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                        style: AppTextStyles.sectionTitle.copyWith(
                          color: AppColors.buy,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        '${trader.maxDrawdown.toStringAsFixed(1)}%',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.sell,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ],
                  )
                : Text(
                    '+${trader.totalPnlPct.toStringAsFixed(1)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.buy,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
          ),
          SizedBox(
            height: skin == CopyTradingListSkin.classic
                ? AppSpacing.x1
                : AppSpacing.x2,
          ),
          Text(
            skin == CopyTradingListSkin.classic ? 'Tổng ROI  ·  Max DD' : 'Tổng ROI',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _CopyDetailsButton extends StatelessWidget {
  const _CopyDetailsButton({
    required this.traderId,
    required this.onOpen,
    required this.keys,
    required this.skin,
  });

  final String traderId;
  final VoidCallback onOpen;
  final CopyTradingListKeys keys;
  final CopyTradingListSkin skin;

  @override
  Widget build(BuildContext context) {
    if (skin == CopyTradingListSkin.classic) {
      return VitCtaButton(
        key: keys.detailKey(traderId),
        onPressed: onOpen,
        variant: VitCtaButtonVariant.secondary,
        height: AppSpacing.homeHeroActionHeight,
        trailing: const Icon(Icons.chevron_right_rounded),
        child: const Text('Xem chi tiết'),
      );
    }

    return VitCard(
      key: keys.detailKey(traderId),
      onTap: onOpen,
      height: AppSpacing.copyTradingV2DetailsButtonHeight,
      alignment: Alignment.center,
      variant: VitCardVariant.inner,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Xem chi tiết',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text1,
            size: AppSpacing.walletAssetSectionGap,
          ),
        ],
      ),
    );
  }
}

class _CopyMetricsGrid extends StatelessWidget {
  const _CopyMetricsGrid({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      ('Win Rate', '${trader.winRate.toStringAsFixed(1)}%', AppColors.buy),
      ('PnL', _formatSignedUsd(trader.totalPnl), AppColors.buy),
      ('Copiers', '${trader.copiers}', AppColors.primary),
      ('Sharpe', trader.sharpeRatio.toStringAsFixed(2), AppColors.caution),
    ];

    return Row(
      children: [
        for (var i = 0; i < metrics.length; i++) ...[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metrics[i].$1,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    metrics[i].$2,
                    style: AppTextStyles.caption.copyWith(
                      color: metrics[i].$3,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (i < metrics.length - 1) const SizedBox(width: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _CopyWeeklyChart extends StatelessWidget {
  const _CopyWeeklyChart({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'P/L 7 ngày gần nhất',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        SizedBox(
          height: AppSpacing.copyTradingWeeklyChartHeight,
          child: VitSparkline(
            values: values,
            color: values.isNotEmpty && values.last < values.first
                ? AppColors.sell
                : AppColors.buy,
            strokeWidth: AppSpacing.copyTradingWeeklyStrokeWidth,
          ),
        ),
      ],
    );
  }
}

final class _CopyTierStyle {
  const _CopyTierStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

final class _CopyRiskStyle {
  const _CopyRiskStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

_CopyTierStyle _tierFor(int copiers, CopyTradingListSkin skin) {
  if (copiers > 3000) {
    return _CopyTierStyle(
      label: skin == CopyTradingListSkin.classic ? 'Pro Trader' : 'Pro',
      color: skin == CopyTradingListSkin.classic
          ? AppColors.caution
          : AppColors.warn,
      icon: skin == CopyTradingListSkin.classic
          ? Icons.star_rounded
          : Icons.star_outline_rounded,
    );
  }
  if (copiers > 1000) {
    return _CopyTierStyle(
      label: 'Verified',
      color: AppColors.buy,
      icon: skin == CopyTradingListSkin.classic
          ? Icons.check_circle_rounded
          : Icons.check_circle_outline_rounded,
    );
  }
  return _CopyTierStyle(
    label: 'Basic',
    color: AppColors.text3,
    icon: skin == CopyTradingListSkin.classic
        ? Icons.info_rounded
        : Icons.info_outline_rounded,
  );
}

_CopyRiskStyle _riskFor(TradeCopyRiskLevel risk) {
  return switch (risk) {
    TradeCopyRiskLevel.low => const _CopyRiskStyle(
      label: 'Thấp',
      color: AppColors.buy,
    ),
    TradeCopyRiskLevel.medium => const _CopyRiskStyle(
      label: 'Trung bình',
      color: AppColors.caution,
    ),
    TradeCopyRiskLevel.high => const _CopyRiskStyle(
      label: 'Cao',
      color: AppColors.sell,
    ),
  };
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(1)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatSignedUsd(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign${_formatCompact(value.abs(), prefix: r'$')}';
}
