import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _copyBlue = Color(0xFF3B82F6);
const _copyPanel = Color(0xFF111723);
const _copySurface = Color(0xFF1C2231);
const _copyPurple = Color(0xFF6366F1);

class CopyTradingV2Page extends ConsumerStatefulWidget {
  const CopyTradingV2Page({super.key, this.shellRenderMode});

  static const contentKey = Key('sc064_copy_trading_v2_scroll_content');
  static Key variantKey(String id) => Key('sc064_variant_$id');
  static Key sortKey(String option) => Key('sc064_sort_$option');
  static Key traderKey(String id) => Key('sc064_trader_$id');
  static Key detailKey(String id) => Key('sc064_detail_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyTradingV2Page> createState() => _CopyTradingV2PageState();
}

class _CopyTradingV2PageState extends ConsumerState<CopyTradingV2Page> {
  String _sortBy = 'Top ROI';
  String _heroVariant = 'clean';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getCopyTradingV2();
    final copyTrading = snapshot.copyTrading;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 112 : 28);
    final traders = _sortedTraders(copyTrading.traders).take(3).toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-064 CopyTradingPageV2',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Copy Trading v2',
              subtitle: 'With Variant Switcher',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CopyTradingV2Page.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _VariantSwitcher(
                      variants: snapshot.heroVariants,
                      selected: _heroVariant,
                      onChanged: (value) =>
                          setState(() => _heroVariant = value),
                    ),
                    const SizedBox(height: 24),
                    _HeroCard(snapshot: copyTrading, variant: _heroVariant),
                    const SizedBox(height: 24),
                    _RiskWarningCard(
                      title: copyTrading.riskWarningTitle,
                      message: copyTrading.riskWarningText,
                    ),
                    const SizedBox(height: 24),
                    _SortChips(
                      options: copyTrading.sortOptions,
                      selected: _sortBy,
                      onChanged: (value) => setState(() => _sortBy = value),
                    ),
                    const SizedBox(height: 20),
                    for (final trader in traders) ...[
                      _TraderCard(
                        trader: trader,
                        onOpen: () => context.go(
                          AppRoutePaths.tradeCopyProvider(
                            trader.id,
                            backPath: AppRoutePaths.tradeCopyTradingV2,
                          ),
                        ),
                      ),
                      if (trader != traders.last) const SizedBox(height: 20),
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

  List<TradeCopyTrader> _sortedTraders(List<TradeCopyTrader> traders) {
    final sorted = [...traders];
    if (_sortBy == 'Ổn định nhất') {
      sorted.sort((a, b) => b.sharpeRatio.compareTo(a.sharpeRatio));
    } else if (_sortBy == 'Nhiều copier') {
      sorted.sort((a, b) => b.copiers.compareTo(a.copiers));
    } else if (_sortBy == 'AUM cao') {
      sorted.sort((a, b) => b.aum.compareTo(a.aum));
    } else {
      sorted.sort((a, b) => b.totalPnlPct.compareTo(a.totalPnlPct));
    }
    return sorted;
  }
}

class _VariantSwitcher extends StatelessWidget {
  const _VariantSwitcher({
    required this.variants,
    required this.selected,
    required this.onChanged,
  });

  final List<String> variants;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 56),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _copySurface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.palette_outlined, color: _copyBlue, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Card Style:',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          for (final variant in variants) ...[
            _VariantButton(
              key: CopyTradingV2Page.variantKey(variant),
              label: _titleCase(variant),
              active: selected == variant,
              onTap: () => onChanged(variant),
            ),
            if (variant != variants.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _VariantButton extends StatelessWidget {
  const _VariantButton({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 30,
        constraints: const BoxConstraints(minWidth: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: active ? _copyBlue : Colors.transparent,
          border: Border.all(color: active ? _copyBlue : AppColors.cardBorder),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot, required this.variant});

  final TradeCopyTradingSnapshot snapshot;
  final String variant;

  @override
  Widget build(BuildContext context) {
    if (variant == 'bold') return _BoldHero(snapshot: snapshot);
    return _GlassHero(snapshot: snapshot);
  }
}

class _GlassHero extends StatelessWidget {
  const _GlassHero({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 278,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x191A1B4B), Color(0x262F2461)],
        ),
        border: Border.all(color: Color(0x2A8B5CF6)),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -52,
            right: -40,
            child: Container(
              width: 160,
              height: 160,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x338B5CF6), Color(0x00000000)],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _CopyIconBox(),
              const SizedBox(height: 20),
              Text(
                'Copy Trading',
                style: AppTextStyles.sectionTitle.copyWith(
                  fontSize: 21,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'Sao chép giao dịch từ trader chuyên nghiệp',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1.3,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.groups_2_outlined,
                      label: 'TRADERS',
                      value: '${snapshot.traders.length}',
                      color: _copyPurple,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.person_add_alt_1_outlined,
                      label: 'COPIERS',
                      value: _formatCompactNumber(snapshot.totalCopiers),
                      color: AppColors.buy,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _GlassStatCard(
                      icon: Icons.trending_up_rounded,
                      label: 'AUM',
                      value: _formatCompact(snapshot.totalAum, prefix: r'$'),
                      color: AppColors.warn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BoldHero extends StatelessWidget {
  const _BoldHero({required this.snapshot});

  final TradeCopyTradingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 248,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFEC4899)],
        ),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: .20),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.copy_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 7),
                Text(
                  'COPY TRADING',
                  style: AppTextStyles.micro.copyWith(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Sao chép trader hàng đầu',
            style: AppTextStyles.sectionTitle.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tự động · Minh bạch · Kiểm soát rủi ro',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white.withValues(alpha: .90),
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _BoldStatCard(
                  label: 'TRADERS',
                  value: '${snapshot.traders.length}',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BoldStatCard(
                  label: 'COPIERS',
                  value: _formatCompactNumber(snapshot.totalCopiers),
                  color: _copyBlue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _BoldStatCard(
                  label: 'AUM',
                  value: _formatCompact(snapshot.totalAum, prefix: r'$'),
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CopyIconBox extends StatelessWidget {
  const _CopyIconBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x338B5CF6), Color(0x338B5CF6)],
        ),
        border: Border.all(color: const Color(0x26FFFFFF)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.copy_rounded, color: _copyBlue, size: 23),
    );
  }
}

class _GlassStatCard extends StatelessWidget {
  const _GlassStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .05),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .16),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 15),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 17,
                fontWeight: AppTextStyles.bold,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BoldStatCard extends StatelessWidget {
  const _BoldStatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .88),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: Colors.white.withValues(alpha: .80),
              fontSize: 9,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 72),
      padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
      decoration: BoxDecoration(
        color: AppColors.warningBg,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warningText,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  message,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.warningText.withValues(alpha: .90),
                    fontSize: 10,
                    height: 1.4,
                    fontWeight: AppTextStyles.medium,
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

class _SortChips extends StatelessWidget {
  const _SortChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final option in options) ...[
            _SortChip(
              key: CopyTradingV2Page.sortKey(option),
              label: option,
              active: selected == option,
              onTap: () => onChanged(option),
            ),
            if (option != options.last) const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: _sortChipWidth(label),
        height: 32,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: active ? _copyBlue : _copySurface,
          borderRadius: BorderRadius.circular(999),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : AppColors.text2,
              fontSize: 12,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _TraderCard extends StatelessWidget {
  const _TraderCard({required this.trader, required this.onOpen});

  final TradeCopyTrader trader;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final tier = _tierFor(trader.copiers);
    return Container(
      key: CopyTradingV2Page.traderKey(trader.id),
      height: 137,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: _copyPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AvatarBadge(trader: trader, tier: tier),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 1),
                  child: Column(
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
                                fontSize: 15,
                                fontWeight: AppTextStyles.bold,
                                height: 1.2,
                              ),
                            ),
                          ),
                          if (trader.isFollowing) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.star_rounded,
                              color: AppColors.warn,
                              size: 13,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          _MiniBadge(label: tier.label, color: tier.color),
                          for (final tag in trader.tags.take(2))
                            _MiniBadge(label: tag, color: AppColors.text2),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _RoiBlock(trader: trader),
            ],
          ),
          const Spacer(),
          _DetailsButton(traderId: trader.id, onOpen: onOpen),
        ],
      ),
    );
  }
}

class _AvatarBadge extends StatelessWidget {
  const _AvatarBadge({required this.trader, required this.tier});

  final TradeCopyTrader trader;
  final _TierStyle tier;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 52,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _copyBlue.withValues(alpha: .13),
              shape: BoxShape.circle,
              border: Border.all(
                color: _copyBlue.withValues(alpha: .27),
                width: 2,
              ),
            ),
            child: Text(
              trader.avatar,
              style: AppTextStyles.baseMedium.copyWith(
                color: _copyBlue,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Positioned(
            right: -1,
            bottom: 2,
            child: Container(
              width: 20,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: tier.color, width: 1.5),
              ),
              child: Icon(tier.icon, color: tier.color, size: 11),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoiBlock extends StatelessWidget {
  const _RoiBlock({required this.trader});

  final TradeCopyTrader trader;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 106),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '+${trader.totalPnlPct.toStringAsFixed(1)}%',
              style: AppTextStyles.sectionTitle.copyWith(
                color: AppColors.buy,
                fontSize: 20,
                height: 1.15,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Tổng ROI',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsButton extends StatelessWidget {
  const _DetailsButton({required this.traderId, required this.onOpen});

  final String traderId;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: CopyTradingV2Page.detailKey(traderId),
      onTap: onOpen,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _copySurface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Xem chi tiết',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text1,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

final class _TierStyle {
  const _TierStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_TierStyle _tierFor(int copiers) {
  if (copiers > 3000) {
    return const _TierStyle(
      label: 'Pro',
      color: AppColors.warn,
      icon: Icons.star_outline_rounded,
    );
  }
  if (copiers > 1000) {
    return const _TierStyle(
      label: 'Verified',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
    );
  }
  return const _TierStyle(
    label: 'Basic',
    color: AppColors.text3,
    icon: Icons.info_outline_rounded,
  );
}

String _titleCase(String value) {
  if (value.isEmpty) return value;
  return value.substring(0, 1).toUpperCase() + value.substring(1);
}

double _sortChipWidth(String label) {
  if (label == 'Top ROI') return 78;
  if (label == 'AUM cao') return 82;
  if (label == 'Nhiều copier') return 108;
  return 106;
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000) {
    return '$prefix${(value / 1000000).toStringAsFixed(1)}M';
  }
  if (abs >= 1000) {
    return '$prefix${(value / 1000).toStringAsFixed(0)}K';
  }
  return '$prefix${value.toStringAsFixed(0)}';
}

String _formatCompactNumber(int value) {
  if (value >= 1000) return '${(value / 1000).toStringAsFixed(0)}K';
  return '$value';
}
