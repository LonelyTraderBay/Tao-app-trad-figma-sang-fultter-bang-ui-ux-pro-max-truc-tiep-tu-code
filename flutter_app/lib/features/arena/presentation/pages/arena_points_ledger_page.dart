import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/arena/data/arena_repository.dart';

class ArenaPointsLedgerPage extends ConsumerStatefulWidget {
  const ArenaPointsLedgerPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc201_ledger_content');
  static const searchKey = Key('sc201_ledger_search');
  static const communityRulesKey = Key('sc201_community_rules');

  static Key filterKey(String id) => Key('sc201_filter_$id');

  static Key entryKey(String id) => Key('sc201_entry_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ArenaPointsLedgerPage> createState() =>
      _ArenaPointsLedgerPageState();
}

class _ArenaPointsLedgerPageState extends ConsumerState<ArenaPointsLedgerPage> {
  String _activeFilter = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(arenaRepositoryProvider).getArenaPointsLedger();
    final entries = _filteredEntries(snapshot.entries);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-201 ArenaPointsLedgerPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sử Arena Points',
              subtitle: 'Sổ điểm · Open Arena',
              showBack: true,
              onBack: () => _close(context),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: ArenaPointsLedgerPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    children: [
                      _BalanceSummary(summary: snapshot.summary),
                      VitSearchBar(
                        key: ArenaPointsLedgerPage.searchKey,
                        placeholder: 'Tìm theo tên challenge, lý do...',
                        onChanged: (value) {
                          setState(() => _searchQuery = value);
                        },
                      ),
                      _FilterRail(
                        filters: snapshot.filters,
                        activeFilter: _activeFilter,
                        onChanged: (id) {
                          HapticFeedback.selectionClick();
                          setState(() => _activeFilter = id);
                        },
                      ),
                      Text(
                        '${entries.length} bản ghi',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                      if (entries.isEmpty)
                        VitEmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: snapshot.emptyTitle,
                          message: snapshot.emptySubtitle,
                        )
                      else
                        _LedgerList(entries: entries),
                      _AuditNotice(disclaimer: snapshot.disclaimer),
                      _CommunityRulesButton(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          context.go(AppRoutePaths.arenaSafety);
                        },
                      ),
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

  List<ArenaPointsLedgerEntryDraft> _filteredEntries(
    List<ArenaPointsLedgerEntryDraft> entries,
  ) {
    final query = _searchQuery.trim().toLowerCase();
    return entries
        .where((entry) {
          if (_activeFilter != 'all' && entry.typeId != _activeFilter) {
            return false;
          }
          if (query.isEmpty) return true;
          final haystack = [
            entry.title,
            entry.reasonCode,
            entry.linkedChallengeName,
            entry.linkedModeName,
          ].whereType<String>().join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);
  }

  static void _close(BuildContext context) {
    HapticFeedback.selectionClick();
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.arena);
  }
}

class _BalanceSummary extends StatelessWidget {
  const _BalanceSummary({required this.summary});

  final ArenaPointsLedgerSummaryDraft summary;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số dư hiện tại',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${formatArenaPoints(summary.currentBalance)} pts',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          _BalanceDelta(
            value: '+${formatArenaPoints(summary.pointsEarned)}',
            label: 'Đã nhận',
            color: AppColors.buy,
          ),
          const SizedBox(width: AppSpacing.x4),
          _BalanceDelta(
            value: '-${formatArenaPoints(summary.pointsSpent)}',
            label: 'Đã dùng',
            color: AppColors.sell,
          ),
        ],
      ),
    );
  }
}

class _BalanceDelta extends StatelessWidget {
  const _BalanceDelta({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ],
    );
  }
}

class _FilterRail extends StatelessWidget {
  const _FilterRail({
    required this.filters,
    required this.activeFilter,
    required this.onChanged,
  });

  final List<ArenaPointsLedgerFilterDraft> filters;
  final String activeFilter;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final filter in filters) ...[
            _FilterButton(
              filter: filter,
              active: filter.id == activeFilter,
              onTap: () => onChanged(filter.id),
            ),
            if (filter != filters.last) const SizedBox(width: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.filter,
    required this.active,
    required this.onTap,
  });

  final ArenaPointsLedgerFilterDraft filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaPointsLedgerPage.filterKey(filter.id),
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          constraints: const BoxConstraints(
            minHeight: AppSpacing.buttonCompact,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x3,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.primary12 : AppColors.surface2,
            border: Border.all(
              color: active ? AppColors.primary30 : AppColors.borderSolid,
            ),
            borderRadius: AppRadii.smRadius,
          ),
          child: Text(
            filter.label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text2,
              fontWeight: AppTextStyles.medium,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _LedgerList extends StatelessWidget {
  const _LedgerList({required this.entries});

  final List<ArenaPointsLedgerEntryDraft> entries;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (var i = 0; i < entries.length; i++) ...[
            _LedgerRow(entry: entries[i]),
            if (i < entries.length - 1)
              const Divider(height: 1, color: AppColors.divider),
          ],
        ],
      ),
    );
  }
}

class _LedgerRow extends StatelessWidget {
  const _LedgerRow({required this.entry});

  final ArenaPointsLedgerEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final color = _entryColor(entry.typeId);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ArenaPointsLedgerPage.entryKey(entry.id),
        onTap: () {
          HapticFeedback.selectionClick();
          context.go(AppRoutePaths.arenaLedgerEntry(entry.id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.rowPy,
          ),
          child: Row(
            children: [
              _LedgerIcon(typeId: entry.typeId, color: color),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Row(
                      children: [
                        _TypeBadge(label: entry.typeLabel, color: color),
                        const SizedBox(width: AppSpacing.x2),
                        Flexible(
                          child: Text(
                            entry.time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _amountLabel(entry.amount),
                    style: AppTextStyles.caption.copyWith(
                      color: _amountColor(entry.amount),
                      fontWeight: AppTextStyles.bold,
                      height: 1,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: 9,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        formatArenaPoints(entry.balanceAfter),
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          height: 1,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LedgerIcon extends StatelessWidget {
  const _LedgerIcon({required this.typeId, required this.color});

  final String typeId;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _entryTint(typeId),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(_entryIcon(typeId), color: color, size: 17),
    );
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _AuditNotice extends StatelessWidget {
  const _AuditNotice({required this.disclaimer});

  final String disclaimer;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.accent, size: 16),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              disclaimer,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommunityRulesButton extends StatelessWidget {
  const _CommunityRulesButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ArenaPointsLedgerPage.communityRulesKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      onTap: onTap,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x3,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book_outlined,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Text(
            'Quy tắc cộng đồng',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _entryColor(String typeId) {
  return switch (typeId) {
    'earned' => AppColors.buy,
    'spent' => AppColors.sell,
    'entry' => AppColors.warn,
    'settlement' => AppColors.accent,
    'refund' => AppColors.primary,
    'adjustment' => AppColors.text3,
    _ => AppColors.text2,
  };
}

Color _entryTint(String typeId) {
  return switch (typeId) {
    'earned' => AppColors.buy10,
    'spent' => AppColors.sell10,
    'entry' => AppColors.warn10,
    'settlement' => AppColors.accent12,
    'refund' => AppColors.primary12,
    _ => AppColors.surface3,
  };
}

Color _amountColor(int amount) {
  if (amount > 0) return AppColors.buy;
  if (amount < 0) return AppColors.sell;
  return AppColors.text3;
}

IconData _entryIcon(String typeId) {
  return switch (typeId) {
    'earned' => Icons.trending_up_rounded,
    'spent' => Icons.trending_down_rounded,
    'entry' => Icons.sync_alt_rounded,
    'settlement' => Icons.shield_outlined,
    'refund' => Icons.history_rounded,
    'adjustment' => Icons.tune_rounded,
    _ => Icons.receipt_long_outlined,
  };
}

String _amountLabel(int amount) {
  if (amount > 0) return '+${formatArenaPoints(amount)}';
  if (amount < 0) return formatArenaPoints(amount.abs());
  return '0';
}
