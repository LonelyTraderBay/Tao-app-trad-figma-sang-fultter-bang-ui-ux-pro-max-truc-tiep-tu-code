import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/referral_repository.dart';

class ReferralHistoryPage extends ConsumerStatefulWidget {
  const ReferralHistoryPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc286_referral_history_content');
  static const statsKey = Key('sc286_referral_history_stats');
  static const searchKey = Key('sc286_referral_history_search');
  static const filtersKey = Key('sc286_referral_history_filters');
  static const sortKey = Key('sc286_referral_history_sort');
  static const emptyKey = Key('sc286_referral_history_empty');

  static Key filterKey(ReferralFriendFilter filter) =>
      Key('sc286_filter_${filter.name}');
  static Key sortOptionKey(ReferralHistorySort sort) =>
      Key('sc286_sort_${sort.name}');
  static Key friendKey(String id) => Key('sc286_friend_$id');
  static Key remindKey(String id) => Key('sc286_remind_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralHistoryPage> createState() =>
      _ReferralHistoryPageState();
}

class _ReferralHistoryPageState extends ConsumerState<ReferralHistoryPage> {
  final TextEditingController _searchController = TextEditingController();
  ReferralFriendFilter _filter = ReferralFriendFilter.all;
  ReferralHistorySort _sort = ReferralHistorySort.date;
  String? _remindedFriend;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(referralRepositoryProvider)
        .getHistory(
          filter: _filter,
          sort: _sort,
          query: _searchController.text,
        );
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-286 ReferralHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ReferralHistoryPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _StatsRow(stats: snapshot.stats),
                      const SizedBox(height: AppSpacing.x4),
                      VitSearchBar(
                        key: ReferralHistoryPage.searchKey,
                        controller: _searchController,
                        placeholder: snapshot.searchHint,
                        variant: VitSearchBarVariant.compact,
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _FilterRail(
                        filters: snapshot.filters,
                        active: snapshot.filter,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _filter = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _SortRail(
                        options: snapshot.sortOptions,
                        active: snapshot.sort,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _sort = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      if (snapshot.friends.isEmpty)
                        const VitEmptyState(
                          key: ReferralHistoryPage.emptyKey,
                          title: 'Không tìm thấy',
                          message: 'Thử thay đổi bộ lọc hoặc từ khóa',
                          icon: Icons.search_rounded,
                        )
                      else
                        for (final friend in snapshot.friends) ...[
                          _FriendCard(
                            friend: friend,
                            reminded: _remindedFriend == friend.id,
                            onOpen: () => context.go(friend.route),
                            onRemind: () {
                              HapticFeedback.selectionClick();
                              setState(() => _remindedFriend = friend.id);
                            },
                          ),
                          const SizedBox(height: AppSpacing.x3),
                        ],
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
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.stats});

  final ReferralStatsDraft stats;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ReferralHistoryPage.statsKey,
      children: [
        Expanded(
          child: _StatCard(
            value: stats.totalFriends,
            label: 'Tổng bạn bè',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            value: stats.kycCompleted,
            label: 'Đã KYC',
            color: AppColors.buy,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: _StatCard(
            value: stats.activeFriends,
            label: 'Hoạt động',
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.value,
    required this.label,
    required this.color,
  });

  final int value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: AppTextStyles.base.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralFilterDraft> filters;
  final ReferralFriendFilter active;
  final ValueChanged<ReferralFriendFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralHistoryPage.filtersKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final item in filters) ...[
            _FilterChip(
              item: item,
              active: item.filter == active,
              onTap: () => onChanged(item.filter),
            ),
            const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final ReferralFilterDraft item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ReferralHistoryPage.filterKey(item.filter),
      onTap: onTap,
      borderRadius: AppRadii.mdRadius,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : AppColors.surface2,
          border: Border.all(
            color: active ? AppColors.primary40 : AppColors.borderSolid,
          ),
          borderRadius: AppRadii.mdRadius,
        ),
        child: Text(
          '${item.label} (${item.count})',
          style: AppTextStyles.caption.copyWith(
            color: active ? AppColors.primary : AppColors.text2,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _SortRail extends StatelessWidget {
  const _SortRail({
    required this.options,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralSortDraft> options;
  final ReferralHistorySort active;
  final ValueChanged<ReferralHistorySort> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralHistoryPage.sortKey,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const Icon(Icons.swap_vert_rounded, color: AppColors.text3, size: 15),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Sắp xếp:',
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(width: AppSpacing.x3),
          for (final option in options) ...[
            _SortChip(
              option: option,
              active: option.sort == active,
              onTap: () => onChanged(option.sort),
            ),
            const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SortChip extends StatelessWidget {
  const _SortChip({
    required this.option,
    required this.active,
    required this.onTap,
  });

  final ReferralSortDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ReferralHistoryPage.sortOptionKey(option.sort),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: 28,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.primary12 : Colors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          option.label,
          style: AppTextStyles.micro.copyWith(
            color: active ? AppColors.primary : AppColors.text3,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.normal,
          ),
        ),
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  const _FriendCard({
    required this.friend,
    required this.reminded,
    required this.onOpen,
    required this.onRemind,
  });

  final ReferralFriendDraft friend;
  final bool reminded;
  final VoidCallback onOpen;
  final VoidCallback onRemind;

  @override
  Widget build(BuildContext context) {
    final palette = _statusPalette(friend.status);
    return VitCard(
      key: ReferralHistoryPage.friendKey(friend.id),
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Avatar(initial: friend.initial),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            friend.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        _StatusPill(
                          label: palette.label,
                          color: palette.color,
                          background: palette.background,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      'Tham gia: ${friend.joinedDate}',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    friend.totalCommission > 0
                        ? '+${_formatUsd(friend.totalCommission)}'
                        : '—',
                    style: AppTextStyles.body.copyWith(
                      color: friend.totalCommission > 0
                          ? AppColors.buy
                          : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  Text(
                    'Hoa hồng',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _FriendMetric(
                  label: 'KYC',
                  value: friend.kycCompleted ? 'Hoàn tất' : 'Đang chờ',
                  icon: friend.kycCompleted
                      ? Icons.check_circle_rounded
                      : Icons.schedule_rounded,
                  color: friend.kycCompleted ? AppColors.buy : AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'Khối lượng GD',
                  value: friend.totalVolume > 0
                      ? _formatUsd(friend.totalVolume)
                      : '—',
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _FriendMetric(
                  label: 'GD đầu tiên',
                  value: friend.firstTradeDate ?? '—',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
          if (friend.canRemindKyc) ...[
            const SizedBox(height: AppSpacing.x3),
            InkWell(
              key: ReferralHistoryPage.remindKey(friend.id),
              onTap: onRemind,
              borderRadius: AppRadii.mdRadius,
              child: Container(
                height: 44,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary08,
                  border: Border.all(color: AppColors.primary20),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      reminded ? Icons.check_rounded : Icons.send_rounded,
                      color: AppColors.primary,
                      size: 15,
                    ),
                    const SizedBox(width: AppSpacing.x3),
                    Text(
                      reminded ? 'Đã nhắc KYC' : 'Nhắc hoàn tất KYC',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        initial,
        style: AppTextStyles.baseMedium.copyWith(color: AppColors.text2),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FriendMetric extends StatelessWidget {
  const _FriendMetric({
    required this.label,
    required this.value,
    required this.color,
    this.icon,
  });

  final String label;
  final String value;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 13),
                const SizedBox(width: AppSpacing.x1),
              ],
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
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

final class _ReferralStatusPalette {
  const _ReferralStatusPalette({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

_ReferralStatusPalette _statusPalette(ReferralFriendStatus status) {
  return switch (status) {
    ReferralFriendStatus.pendingKyc => const _ReferralStatusPalette(
      label: 'Chờ KYC',
      color: AppColors.warn,
      background: AppColors.warn10,
    ),
    ReferralFriendStatus.kycDone => const _ReferralStatusPalette(
      label: 'Đã KYC',
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    ReferralFriendStatus.activeTrader => const _ReferralStatusPalette(
      label: 'Đang giao dịch',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    ReferralFriendStatus.inactive => const _ReferralStatusPalette(
      label: 'Không hoạt động',
      color: AppColors.text3,
      background: AppColors.surface2,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return '\$${buffer.toString()}.${parts.last}';
}
