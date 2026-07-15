import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/theme/trade_core_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_core/presentation/widgets/vit_trade_analytics_hero.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Hero for entity-detail / flow-step trade pages: a primary stat paired
/// with either a secondary KPI column (e.g. copy-trading AUM + copiers) or a
/// leading icon and a risk/status badge (e.g. leverage + risk level), plus an
/// optional footnote — pairs with [VitTradeDetailScaffold].
///
/// Also covers the richer "entity profile" shape (e.g. a copy-trading
/// trader profile) via the optional [avatar]/[identityTitle]/[tags]
/// identity row, [stats] metric grid, [progressValue] progress bar, and
/// [ctaLabel] CTA button — all independently optional so the primary/
/// secondary-stat call sites keep rendering unchanged.
class VitTradeDetailHero extends StatelessWidget {
  const VitTradeDetailHero({
    super.key,
    this.primaryLabel,
    this.primaryValue,
    this.primaryColor,
    this.leadingIcon,
    this.secondaryLabel,
    this.secondaryValue,
    this.secondaryColor,
    this.badgeLabel,
    this.badgeColor,
    this.footnote,
    this.borderColor,
    this.avatar,
    this.identityTitle,
    this.identityTrailing,
    this.tags,
    this.stats,
    this.progressValue,
    this.progressColor,
    this.progressLeadingLabel,
    this.progressTrailingLabel,
    this.ctaKey,
    this.ctaLabel,
    this.ctaLeading,
    this.ctaVariant = VitCtaButtonVariant.primary,
    this.onCtaPressed,
  });

  final String? primaryLabel;
  final String? primaryValue;
  final Color? primaryColor;

  /// Icon shown beside [primaryLabel] in single-stat mode only (ignored when
  /// [secondaryLabel]/[secondaryValue] are set).
  final IconData? leadingIcon;

  /// When set together with [secondaryValue], renders a 2-column KPI strip
  /// instead of the single centered stat.
  final String? secondaryLabel;
  final String? secondaryValue;
  final Color? secondaryColor;

  /// Risk/status badge shown below the primary stat in single-stat mode.
  final String? badgeLabel;
  final Color? badgeColor;

  final String? footnote;

  /// Overrides the computed border color for every mode below. Falls back
  /// to the existing badge-derived border when unset.
  final Color? borderColor;

  /// Leading avatar for the entity-profile identity row (e.g.
  /// [VitAssetAvatar]). Renders nothing when both this and [identityTitle]
  /// are null.
  final Widget? avatar;

  /// Entity name/title shown beside [avatar].
  final String? identityTitle;

  /// Optional trailing indicator next to [identityTitle] (e.g. a "following"
  /// star icon).
  final Widget? identityTrailing;

  /// Pre-built tag/pill widgets (e.g. [VitAccentPill]) rendered in a
  /// [Wrap] under [identityTitle].
  final List<Widget>? tags;

  /// A metric grid rendered as an [Expanded] row, reusing the same stat
  /// shape as [VitTradeAnalyticsHero].
  final List<VitTradeAnalyticsStat>? stats;

  /// 0..1 fraction for the progress bar. Renders nothing when null.
  final double? progressValue;
  final Color? progressColor;
  final String? progressLeadingLabel;
  final String? progressTrailingLabel;

  final Key? ctaKey;
  final String? ctaLabel;
  final Widget? ctaLeading;
  final VitCtaButtonVariant ctaVariant;
  final VoidCallback? onCtaPressed;

  bool get _hasPrimaryStat => primaryLabel != null && primaryValue != null;

  bool get _hasSecondaryStat =>
      _hasPrimaryStat && secondaryLabel != null && secondaryValue != null;

  bool get _hasIdentity => avatar != null || identityTitle != null;

  bool get _hasTags => tags != null && tags!.isNotEmpty;

  bool get _hasStats => stats != null && stats!.isNotEmpty;

  bool get _hasProgress => progressValue != null;

  bool get _hasCta => ctaLabel != null;

  bool get _isRichProfile =>
      _hasIdentity || _hasTags || _hasStats || _hasProgress || _hasCta;

  @override
  Widget build(BuildContext context) {
    final hasSecondaryStat = _hasSecondaryStat;
    final stretch = hasSecondaryStat || _isRichProfile;

    final children = <Widget>[];
    void addSection(Widget child, {double gap = AppSpacing.x3}) {
      if (children.isNotEmpty) {
        children.add(SizedBox(height: gap));
      }
      children.add(child);
    }

    if (_hasIdentity) {
      addSection(
        _DetailHeroIdentity(
          avatar: avatar,
          title: identityTitle,
          trailing: identityTrailing,
          tags: _hasTags ? tags! : null,
        ),
      );
    }

    if (_hasPrimaryStat) {
      addSection(
        hasSecondaryStat
            ? Row(
                children: [
                  Expanded(
                    child: _DetailHeroStat(
                      label: primaryLabel!,
                      value: primaryValue!,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(
                    width: 1,
                    height: AppSpacing.x6,
                    child: ColoredBox(color: AppColors.border),
                  ),
                  Expanded(
                    child: Padding(
                      padding:
                          TradeCoreSpacingTokens.tradeBotHeroSecondaryPadding,
                      child: _DetailHeroStat(
                        label: secondaryLabel!,
                        value: secondaryValue!,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leadingIcon != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          leadingIcon,
                          color: primaryColor,
                          size: AppSpacing.iconMd,
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        Text(primaryLabel!, style: AppTextStyles.caption),
                      ],
                    )
                  else
                    Text(
                      primaryLabel!,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
                  Text(
                    primaryValue!,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.jumbo.copyWith(
                      color: primaryColor ?? AppColors.text1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ],
              ),
        gap: AppSpacing.pageRhythmCompactInnerGap,
      );
    }

    if (_hasStats) {
      addSection(
        Row(
          children: [
            for (var i = 0; i < stats!.length; i++) ...[
              Expanded(
                child: VitTradeAnalyticsStatChip(
                  stat: stats![i],
                  alignment: VitTradeAnalyticsStatChipAlignment.start,
                ),
              ),
              if (i != stats!.length - 1) const SizedBox(width: AppSpacing.x2),
            ],
          ],
        ),
        gap: AppSpacing.pageRhythmCompactInnerGap,
      );
    }

    if (badgeLabel != null) {
      addSection(
        VitAccentPill(
          label: badgeLabel!,
          accentColor: badgeColor ?? AppColors.text1,
          size: VitStatusPillSize.md,
        ),
      );
    }

    if (_hasProgress) {
      addSection(
        _DetailHeroProgress(
          value: progressValue!,
          color: progressColor ?? AppColors.primary,
          leadingLabel: progressLeadingLabel,
          trailingLabel: progressTrailingLabel,
        ),
        gap: AppSpacing.pageRhythmCompactInnerGap,
      );
    }

    if (footnote != null) {
      addSection(
        Text(
          footnote!,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3.withValues(alpha: .70),
          ),
        ),
        gap: AppSpacing.pageRhythmCompactInnerGap,
      );
    }

    if (_hasCta) {
      addSection(
        VitCtaButton(
          key: ctaKey,
          onPressed: onCtaPressed,
          variant: ctaVariant,
          leading: ctaLeading,
          child: Text(ctaLabel!),
        ),
        gap: AppSpacing.pageRhythmCompactInnerGap,
      );
    }

    return VitCard(
      padding: AppSpacing.cardPaddingCompact,
      radius: hasSecondaryStat ? VitCardRadius.standard : VitCardRadius.large,
      borderColor:
          borderColor ??
          (hasSecondaryStat ? null : badgeColor?.withValues(alpha: .32)),
      child: Column(
        crossAxisAlignment: stretch
            ? CrossAxisAlignment.stretch
            : CrossAxisAlignment.center,
        children: children,
      ),
    );
  }
}

class _DetailHeroStat extends StatelessWidget {
  const _DetailHeroStat({required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

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
          style: AppTextStyles.heroNumber.copyWith(
            color: color ?? AppColors.text1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _DetailHeroIdentity extends StatelessWidget {
  const _DetailHeroIdentity({
    required this.avatar,
    required this.title,
    required this.trailing,
    required this.tags,
  });

  final Widget? avatar;
  final String? title;
  final Widget? trailing;
  final List<Widget>? tags;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatar != null) ...[avatar!, const SizedBox(width: AppSpacing.x2)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    ?trailing,
                  ],
                ),
              if (tags != null) ...[
                const SizedBox(height: AppSpacing.x1),
                Wrap(
                  spacing: AppSpacing.x1,
                  runSpacing: AppSpacing.x1,
                  children: tags!,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailHeroProgress extends StatelessWidget {
  const _DetailHeroProgress({
    required this.value,
    required this.color,
    this.leadingLabel,
    this.trailingLabel,
  });

  final double value;
  final Color color;
  final String? leadingLabel;
  final String? trailingLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (leadingLabel != null || trailingLabel != null) ...[
          Row(
            children: [
              if (leadingLabel != null)
                Flexible(
                  child: Text(
                    leadingLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
              const SizedBox(width: AppSpacing.x2),
              if (trailingLabel != null)
                Flexible(
                  child: Text(
                    trailingLabel!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmCompactInnerGap),
        ],
        ClipRRect(
          borderRadius: AppRadii.pillRadius,
          child: LinearProgressIndicator(
            minHeight: TradeCoreSpacingTokens.traderProfileProgressHeight,
            value: value.clamp(0, 1),
            backgroundColor: AppColors.text1.withValues(alpha: .10),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
