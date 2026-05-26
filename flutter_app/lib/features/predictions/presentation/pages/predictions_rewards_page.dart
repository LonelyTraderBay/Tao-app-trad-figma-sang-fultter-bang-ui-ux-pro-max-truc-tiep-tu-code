import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/predictions/data/predictions_repository.dart';

const _predictionPrimary = AppColors.primary;

class PredictionsRewardsPage extends ConsumerStatefulWidget {
  const PredictionsRewardsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc032_predictions_rewards_content');
  static const allFilterKey = Key('sc032_filter_all');
  static const liveCryptoFilterKey = Key('sc032_filter_live_crypto');
  static const favoritesFilterKey = Key('sc032_filter_favorites');
  static const riskExplainerKey = Key('sc032_risk_explainer');
  static const arenaBridgeKey = Key('sc032_arena_bridge');

  static Key rewardKey(String id) => Key('sc032_reward_$id');
  static Key favoriteKey(String id) => Key('sc032_favorite_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<PredictionsRewardsPage> createState() =>
      _PredictionsRewardsPageState();
}

class _PredictionsRewardsPageState
    extends ConsumerState<PredictionsRewardsPage> {
  String _category = 'All';
  bool _favoritesOnly = false;
  late final Set<String> _favorites;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockPredictionsRepository().getRewards();
    _favorites = snapshot.rewards
        .where((reward) => reward.isFavorite)
        .map((reward) => reward.id)
        .toSet();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(predictionsRepositoryProvider).getRewards();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);
    final rewards = snapshot.rewards.where((reward) {
      final categoryMatch = _category == 'All' || reward.category == _category;
      final favoriteMatch = !_favoritesOnly || _favorites.contains(reward.id);
      return categoryMatch && favoriteMatch;
    }).toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-032 PredictionsRewardsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Daily Rewards',
              subtitle: 'Phần thưởng · Prediction',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.marketsPredictionEvent('pred-1')),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: PredictionsRewardsPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 16,
                    children: [
                      _RewardsHero(snapshot: snapshot),
                      const _HowItWorksNote(),
                      _CategoryFilters(
                        categories: ['All', ...snapshot.categories],
                        activeCategory: _category,
                        favoritesOnly: _favoritesOnly,
                        onCategoryChanged: (value) => setState(() {
                          _category = value;
                        }),
                        onFavoritesToggle: () => setState(() {
                          _favoritesOnly = !_favoritesOnly;
                        }),
                      ),
                      _RewardsTable(
                        snapshot: snapshot,
                        rewards: rewards,
                        favorites: _favorites,
                        onFavoriteToggle: (id) => setState(() {
                          if (!_favorites.add(id)) _favorites.remove(id);
                        }),
                      ),
                      _RiskLink(onTap: () => _showRiskSheet(context)),
                      _ArenaRooms(snapshot: snapshot),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRiskSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reward không phải lợi nhuận đảm bảo',
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Daily rewards phụ thuộc điều kiện spread, min shares, thời '
                'gian giữ lệnh và thanh khoản thị trường.',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RewardsHero extends StatelessWidget {
  const _RewardsHero({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.surface, AppColors.surface2, AppColors.warningBg],
        ),
        border: Border.all(color: AppColors.accent20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.warn10,
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.card_giftcard_rounded,
                  color: AppColors.warn,
                  size: 23,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Daily Rewards',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Earn rewards by placing competitive limit orders',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              const Icon(
                Icons.help_outline_rounded,
                color: AppColors.portfolioTextMuted,
                size: 13,
              ),
              const SizedBox(width: 7),
              Text(
                'Total daily pool:',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(width: 7),
              Text(
                '\$${snapshot.totalDailyPool.toStringAsFixed(0)}',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.warn,
                  fontSize: 16,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HowItWorksNote extends StatelessWidget {
  const _HowItWorksNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
      decoration: BoxDecoration(
        color: _predictionPrimary.withValues(alpha: .07),
        border: Border.all(color: _predictionPrimary.withValues(alpha: .18)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _predictionPrimary,
            size: 15,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              const TextSpan(
                children: [
                  TextSpan(text: 'How it works:'),
                  TextSpan(
                    text: ' Place a ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'limit order'),
                  TextSpan(
                    text: ' (not market order) within the ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'Max Spread'),
                  TextSpan(
                    text: ' and hold at least ',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                  TextSpan(text: 'Min Shares'),
                  TextSpan(
                    text:
                        '. Rewards are distributed daily in USDT at 00:00 UTC.',
                    style: TextStyle(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                height: 1.45,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryFilters extends StatelessWidget {
  const _CategoryFilters({
    required this.categories,
    required this.activeCategory,
    required this.favoritesOnly,
    required this.onCategoryChanged,
    required this.onFavoritesToggle,
  });

  final List<String> categories;
  final String activeCategory;
  final bool favoritesOnly;
  final ValueChanged<String> onCategoryChanged;
  final VoidCallback onFavoritesToggle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 31,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          if (index == categories.length) {
            return _FilterChip(
              key: PredictionsRewardsPage.favoritesFilterKey,
              label: 'Favs',
              active: favoritesOnly,
              icon: Icons.favorite_rounded,
              activeColor: AppColors.sell,
              onTap: onFavoritesToggle,
            );
          }
          final category = categories[index];
          return _FilterChip(
            key: category == 'All'
                ? PredictionsRewardsPage.allFilterKey
                : category == 'Live Crypto'
                ? PredictionsRewardsPage.liveCryptoFilterKey
                : Key('sc032_filter_$category'),
            label: category,
            active: activeCategory == category,
            onTap: () => onCategoryChanged(category),
          );
        },
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemCount: categories.length + 1,
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
    this.icon,
    this.activeColor = _predictionPrimary,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 31,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? activeColor.withValues(alpha: .13)
              : AppColors.surface2,
          border: Border.all(
            color: active
                ? activeColor.withValues(alpha: .35)
                : Colors.transparent,
          ),
          borderRadius: AppRadii.smRadius,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: active ? activeColor : AppColors.text3,
                size: 11,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: AppTextStyles.micro.copyWith(
                color: active ? activeColor : AppColors.text3,
                fontSize: 11,
                fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardsTable extends StatelessWidget {
  const _RewardsTable({
    required this.snapshot,
    required this.rewards,
    required this.favorites,
    required this.onFavoriteToggle,
  });

  final PredictionRewardsSnapshot snapshot;
  final List<PredictionRewardOpportunityDraft> rewards;
  final Set<String> favorites;
  final ValueChanged<String> onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    if (rewards.isEmpty) {
      return const VitEmptyState(
        title: 'No rewards found',
        message: 'Try adjusting your filters',
        icon: Icons.card_giftcard_rounded,
      );
    }

    return Column(
      children: [
        const _TableHeader(),
        for (final reward in rewards)
          _RewardRow(
            key: PredictionsRewardsPage.rewardKey(reward.id),
            reward: reward,
            event: snapshot.eventFor(reward.eventId),
            favorite: favorites.contains(reward.id),
            onFavoriteToggle: () => onFavoriteToggle(reward.id),
          ),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(child: _HeaderText('MARKET')),
          const SizedBox(width: 6),
          const SizedBox(
            width: 54,
            child: Center(child: _HeaderText('SPREAD')),
          ),
          const SizedBox(width: 48, child: Center(child: _HeaderText('MIN'))),
          const SizedBox(
            width: 58,
            child: Align(
              alignment: Alignment.centerRight,
              child: _HeaderText('REWARD'),
            ),
          ),
          const SizedBox(width: 14),
        ],
      ),
    );
  }
}

class _HeaderText extends StatelessWidget {
  const _HeaderText(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.micro.copyWith(
        color: AppColors.text3,
        fontSize: 10,
        fontWeight: AppTextStyles.bold,
      ),
    );
  }
}

class _RewardRow extends StatelessWidget {
  const _RewardRow({
    super.key,
    required this.reward,
    required this.event,
    required this.favorite,
    required this.onFavoriteToggle,
  });

  final PredictionRewardOpportunityDraft reward;
  final PredictionEventDraft event;
  final bool favorite;
  final VoidCallback onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    final changeColor = reward.priceChange24h >= 0
        ? AppColors.buy
        : AppColors.sell;

    return InkWell(
      onTap: () => context.go(AppRoutePaths.marketsPredictionEvent(event.id)),
      child: Container(
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.divider)),
        ),
        child: Row(
          children: [
            InkWell(
              key: PredictionsRewardsPage.favoriteKey(reward.id),
              onTap: onFavoriteToggle,
              borderRadius: AppRadii.mdRadius,
              child: SizedBox(
                width: 20,
                child: Icon(
                  favorite ? Icons.star_rounded : Icons.star_border_rounded,
                  color: favorite ? AppColors.warn : AppColors.text3,
                  size: 15,
                ),
              ),
            ),
            const SizedBox(width: 7),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 12,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Flexible(
                        child: _TinyBadge(
                          label: reward.category,
                          color: _predictionPrimary,
                          background: _predictionPrimary.withValues(alpha: .14),
                        ),
                      ),
                      const SizedBox(width: 7),
                      Icon(
                        reward.priceChange24h >= 0
                            ? Icons.arrow_outward_rounded
                            : Icons.south_east_rounded,
                        color: changeColor,
                        size: 11,
                      ),
                      Text(
                        _formatPercent(reward.priceChange24h),
                        style: AppTextStyles.micro.copyWith(
                          color: changeColor,
                          fontSize: 10,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Flexible(
                        child: Text(
                          '${reward.earningsPct.toStringAsFixed(reward.earningsPct == reward.earningsPct.round() ? 0 : 1)}% APY',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 54,
              child: Text(
                '${(reward.maxSpread * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width: 48,
              child: Text(
                '${reward.minShares}',
                textAlign: TextAlign.center,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            SizedBox(
              width: 58,
              child: Text(
                '\$${reward.dailyReward.toStringAsFixed(0)}',
                textAlign: TextAlign.right,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskLink extends StatelessWidget {
  const _RiskLink({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: PredictionsRewardsPage.riskExplainerKey,
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shield_outlined, color: AppColors.warn, size: 13),
            const SizedBox(width: 7),
            Flexible(
              child: Text(
                'Reward không phải lợi nhuận đảm bảo — tìm hiểu thêm',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.warn,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.warn,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }
}

class _ArenaRooms extends StatelessWidget {
  const _ArenaRooms({required this.snapshot});

  final PredictionRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final room = snapshot.arenaRooms.first;
    return VitPageSection(
      label: 'Room Arena cùng chủ đề',
      accentColor: AppColors.warn,
      children: [
        VitCard(
          key: PredictionsRewardsPage.arenaBridgeKey,
          onTap: () => context.go(AppRoutePaths.arena),
          borderColor: AppColors.warningBorder,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warn,
                    size: 10,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'ARENA POINTS ONLY',
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.warn,
                      fontSize: 9,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.warn10,
                      borderRadius: AppRadii.mdRadius,
                    ),
                    child: const Icon(
                      Icons.sports_esports_rounded,
                      color: AppColors.warn,
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          room.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                room.slots,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.micro.copyWith(
                                  color: AppColors.text3,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${room.points} pts',
                              style: AppTextStyles.micro.copyWith(
                                color: AppColors.warn,
                                fontSize: 10,
                                fontWeight: AppTextStyles.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            _TinyBadge(
                              label: room.badge,
                              color: AppColors.warn,
                              background: AppColors.warn10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.text3,
                    size: 17,
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'Room social points-only, không liên quan wallet hay vị thế Prediction.',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _TinyBadge extends StatelessWidget {
  const _TinyBadge({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          height: 1.1,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

String _formatPercent(double value) {
  final sign = value >= 0 ? '+' : '';
  return '$sign${value.toStringAsFixed(1)}%';
}
