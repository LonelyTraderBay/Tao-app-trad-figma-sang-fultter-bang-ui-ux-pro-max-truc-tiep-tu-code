import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/referral_repository.dart';

class ReferralRewardsPage extends ConsumerStatefulWidget {
  const ReferralRewardsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc287_referral_rewards_content');
  static const heroKey = Key('sc287_referral_rewards_hero');
  static const chartKey = Key('sc287_referral_rewards_chart');
  static const tabsKey = Key('sc287_referral_rewards_tabs');
  static const sortKey = Key('sc287_referral_rewards_sort');
  static const ledgerKey = Key('sc287_referral_rewards_ledger');
  static const exportKey = Key('sc287_export_report');
  static const disputeHistoryKey = Key('sc287_dispute_history');

  static Key tabKey(ReferralRewardFilter filter) =>
      Key('sc287_tab_${filter.name}');
  static Key sortOptionKey(ReferralRewardSort sort) =>
      Key('sc287_sort_${sort.name}');
  static Key recordKey(String id) => Key('sc287_record_$id');
  static Key reportKey(String id) => Key('sc287_report_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ReferralRewardsPage> createState() =>
      _ReferralRewardsPageState();
}

class _ReferralRewardsPageState extends ConsumerState<ReferralRewardsPage> {
  ReferralRewardFilter _filter = ReferralRewardFilter.all;
  ReferralRewardSort _sort = ReferralRewardSort.date;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(referralRepositoryProvider)
        .getRewards(filter: _filter, sort: _sort);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-287 ReferralRewardsPage',
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
                  key: ReferralRewardsPage.contentKey,
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
                      _RewardHero(
                        snapshot: snapshot,
                        onExport: () => _showExportSheet(context, snapshot),
                        onDisputes: () =>
                            _showDisputeHistorySheet(context, snapshot),
                      ),
                      const SizedBox(height: AppSpacing.x5),
                      _SectionTitle(
                        title: 'Hoa hồng theo tháng',
                        trailing:
                            '+${_formatUsd(snapshot.thisMonthCommission)} tháng này',
                      ),
                      const SizedBox(height: AppSpacing.x3),
                      _RewardChart(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _RewardTabs(
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
                      _RewardLedger(
                        snapshot: snapshot,
                        onReport: (record) =>
                            _showReportSheet(context, snapshot, record),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      const _DisputeInfo(),
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

  void _showExportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Xuất báo cáo hoa hồng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  '${snapshot.records.length} bản ghi · ${_formatUsd(snapshot.totalCommission)} tổng',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x4),
                Wrap(
                  spacing: AppSpacing.x3,
                  runSpacing: AppSpacing.x3,
                  children: [
                    for (final range in snapshot.exportRanges)
                      _TinyPill(label: range.label),
                  ],
                ),
                const SizedBox(height: AppSpacing.x5),
                VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Tải xuống CSV'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReportSheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
    ReferralRewardRecordDraft record,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Báo lỗi hoa hồng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                _SheetRecord(record: record),
                const SizedBox(height: AppSpacing.x4),
                for (final type in snapshot.disputeTypes) ...[
                  _DisputeTypeRow(type: type),
                  const SizedBox(height: AppSpacing.x2),
                ],
                const SizedBox(height: AppSpacing.x4),
                VitCtaButton(
                  onPressed: () => Navigator.of(context).pop(),
                  variant: VitCtaButtonVariant.warning,
                  leading: const Icon(Icons.send_rounded),
                  child: const Text('Gửi báo lỗi'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDisputeHistorySheet(
    BuildContext context,
    ReferralRewardsSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
      ),
      builder: (context) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.contentPad,
              AppSpacing.x5,
              AppSpacing.contentPad,
              AppSpacing.x6,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Lịch sử báo lỗi',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x4),
                for (final dispute in snapshot.disputes)
                  _DisputeHistoryCard(dispute: dispute),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RewardHero extends StatelessWidget {
  const _RewardHero({
    required this.snapshot,
    required this.onExport,
    required this.onDisputes,
  });

  final ReferralRewardsSnapshot snapshot;
  final VoidCallback onExport;
  final VoidCallback onDisputes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Tổng phần thưởng',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              _TierPill(snapshot: snapshot),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            _formatUsd(snapshot.totalCommission),
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.portfolioTextDim,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            'USDT · Đã cộng vào ví',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.medium,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '+${_formatUsd(snapshot.pendingCommission)} đang chờ xử lý',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroStat(
                  icon: Icons.card_giftcard_rounded,
                  title: 'Thưởng KYC',
                  amount: snapshot.kycBonusTotal,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroStat(
                  icon: Icons.trending_up_rounded,
                  title: 'Hoa hồng GD',
                  amount: snapshot.tradeCommissionTotal,
                  color: AppModuleAccents.trade,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.exportKey,
                  onPressed: onExport,
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.inputHeight,
                  leading: const Icon(Icons.download_rounded),
                  child: const Text('Xuất báo cáo'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  key: ReferralRewardsPage.disputeHistoryKey,
                  onPressed: onDisputes,
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.inputHeight,
                  leading: const Icon(Icons.shield_outlined),
                  child: const Text('Lịch sử báo lỗi'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TierPill extends StatelessWidget {
  const _TierPill({required this.snapshot});

  final ReferralRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.portfolioBtnGhost,
        border: Border.all(color: AppColors.portfolioBtnGhostBorder),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.workspace_premium_rounded,
              color: AppColors.primarySoft,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              '${snapshot.tierName} (${snapshot.tierNameEn})',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.portfolioTextDim,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
    required this.icon,
    required this.title,
    required this.amount,
    required this.color,
  });

  final IconData icon;
  final String title;
  final double amount;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.portfolioBtnGhostBorder,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: AppSpacing.iconSm),
              const SizedBox(width: AppSpacing.x2),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            _formatUsd(amount),
            style: AppTextStyles.body.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.trailing});

  final String title;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.x1,
          height: AppSpacing.x5,
          decoration: const BoxDecoration(
            color: AppColors.buy,
            borderRadius: AppRadii.xsRadius,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
        ),
        Text(
          trailing,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _RewardChart extends StatelessWidget {
  const _RewardChart({required this.snapshot});

  final ReferralRewardsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.chartKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x4,
        AppSpacing.x3,
      ),
      child: SizedBox(
        height: 140,
        child: CustomPaint(
          painter: _ReferralRewardChartPainter(snapshot.chartPoints),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (final point in snapshot.chartPoints)
                  Text(
                    point.month,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardTabs extends StatelessWidget {
  const _RewardTabs({
    required this.filters,
    required this.active,
    required this.onChanged,
  });

  final List<ReferralRewardFilterDraft> filters;
  final ReferralRewardFilter active;
  final ValueChanged<ReferralRewardFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.tabsKey,
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          for (final filter in filters)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(1.5),
                child: _FilterButton(
                  filter: filter,
                  active: filter.filter == active,
                  onTap: () => onChanged(filter.filter),
                ),
              ),
            ),
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

  final ReferralRewardFilterDraft filter;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: ReferralRewardsPage.tabKey(filter.filter),
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: AppSpacing.inputHeight - AppSpacing.x3,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadii.mdRadius,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
          child: Text(
            filter.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? Colors.white : AppColors.text3,
              fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            ),
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

  final List<ReferralRewardSortDraft> options;
  final ReferralRewardSort active;
  final ValueChanged<ReferralRewardSort> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: ReferralRewardsPage.sortKey,
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

  final ReferralRewardSortDraft option;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: ReferralRewardsPage.sortOptionKey(option.sort),
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        height: AppSpacing.buttonCompact - AppSpacing.x1,
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

class _RewardLedger extends StatelessWidget {
  const _RewardLedger({required this.snapshot, required this.onReport});

  final ReferralRewardsSnapshot snapshot;
  final ValueChanged<ReferralRewardRecordDraft> onReport;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: ReferralRewardsPage.ledgerKey,
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              AppSpacing.x3,
              AppSpacing.x4,
              AppSpacing.x3,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Lịch sử thưởng',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                    ),
                  ),
                ),
                if (snapshot.pendingCount > 0) ...[
                  _PendingPill(count: snapshot.pendingCount),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  '${snapshot.completedCount} hoàn tất',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          if (snapshot.records.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.x6),
              child: VitEmptyState(
                title: 'Chưa có giao dịch',
                message: 'Thử thay đổi bộ lọc phần thưởng',
                icon: Icons.card_giftcard_rounded,
              ),
            )
          else
            for (var i = 0; i < snapshot.records.length; i++) ...[
              _RewardRecordRow(
                record: snapshot.records[i],
                onReport: () => onReport(snapshot.records[i]),
              ),
              if (i < snapshot.records.length - 1)
                const Divider(height: 1, color: AppColors.divider),
            ],
        ],
      ),
    );
  }
}

class _PendingPill extends StatelessWidget {
  const _PendingPill({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              '$count đang chờ',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RewardRecordRow extends StatelessWidget {
  const _RewardRecordRow({required this.record, required this.onReport});

  final ReferralRewardRecordDraft record;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final pending = record.status == ReferralRewardStatus.pending;
    final typeColor = switch (record.type) {
      ReferralRewardType.kycBonus => AppModuleAccents.neutral,
      ReferralRewardType.tradeCommission => AppColors.buy,
    };
    final amountColor = pending ? AppColors.warn : typeColor;

    return Opacity(
      opacity: pending ? 0.74 : 1,
      child: Padding(
        key: ReferralRewardsPage.recordKey(record.id),
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x4,
          AppSpacing.x3,
          AppSpacing.x4,
          AppSpacing.x3,
        ),
        child: Row(
          children: [
            _RecordIcon(type: record.type),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          record.friendName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (pending) ...[
                        const SizedBox(width: AppSpacing.x2),
                        _StatusPill(label: 'Đang chờ'),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${record.action} ${record.date}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${pending ? '~' : '+'}${_formatUsd(record.amount)}',
                  style: AppTextStyles.body.copyWith(
                    color: amountColor,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
                Text(
                  record.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
            if (!pending) ...[
              const SizedBox(width: AppSpacing.x2),
              IconButton(
                key: ReferralRewardsPage.reportKey(record.id),
                onPressed: onReport,
                icon: const Icon(Icons.warning_amber_rounded),
                color: AppColors.warn,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.warn08,
                  side: const BorderSide(color: AppColors.warn15),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RecordIcon extends StatelessWidget {
  const _RecordIcon({required this.type});

  final ReferralRewardType type;

  @override
  Widget build(BuildContext context) {
    final isKyc = type == ReferralRewardType.kycBonus;
    return Container(
      width: AppSpacing.iconLg + AppSpacing.x3,
      height: AppSpacing.iconLg + AppSpacing.x3,
      decoration: BoxDecoration(
        color: isKyc ? AppColors.primary12 : AppColors.buy10,
        borderRadius: AppRadii.xlRadius,
      ),
      alignment: Alignment.center,
      child: Icon(
        isKyc ? Icons.workspace_premium_rounded : Icons.trending_up_rounded,
        color: isKyc ? AppColors.primary : AppColors.buy,
        size: AppSpacing.iconMd,
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _DisputeInfo extends StatelessWidget {
  const _DisputeInfo();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.iconLg + AppSpacing.x2,
            height: AppSpacing.iconLg + AppSpacing.x2,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.mdRadius,
            ),
            alignment: Alignment.center,
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              color: AppColors.primary,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoa hồng không chính xác?',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Bấm vào biểu tượng cảnh báo bên cạnh mỗi giao dịch để báo lỗi. Đội ngũ hỗ trợ sẽ xử lý trong 24-48 giờ.',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetRecord extends StatelessWidget {
  const _SheetRecord({required this.record});

  final ReferralRewardRecordDraft record;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          _RecordIcon(type: record.type),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.friendName,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  '${record.action} · ${record.date}',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Text(
            '+${_formatUsd(record.amount)}',
            style: AppTextStyles.body.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _DisputeTypeRow extends StatelessWidget {
  const _DisputeTypeRow({required this.type});

  final ReferralDisputeTypeDraft type;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            type.label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            type.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DisputeHistoryCard extends StatelessWidget {
  const _DisputeHistoryCard({required this.dispute});

  final ReferralDisputeDraft dispute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                dispute.id,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
              const SizedBox(width: AppSpacing.x2),
              Flexible(child: _StatusPill(label: dispute.statusLabel)),
              const SizedBox(width: AppSpacing.x2),
              Text(
                dispute.createdDate,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            dispute.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          if (dispute.resolution != null) ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              dispute.resolution!,
              style: AppTextStyles.caption.copyWith(color: AppColors.text1),
            ),
          ],
        ],
      ),
    );
  }
}

class _TinyPill extends StatelessWidget {
  const _TinyPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface2,
        border: Border.all(color: AppColors.borderSolid),
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _ReferralRewardChartPainter extends CustomPainter {
  const _ReferralRewardChartPainter(this.points);

  final List<ReferralChartPointDraft> points;

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;
    final chartHeight = size.height - 30;
    final chart = Rect.fromLTWH(0, 0, size.width, chartHeight);
    final maxValue = points.map((point) => point.commission).reduce(math.max);
    final minValue = points.map((point) => point.commission).reduce(math.min);
    final valueRange = math.max(1, maxValue - minValue);
    final step = chart.width / (points.length - 1);
    final offsets = <Offset>[];

    for (var i = 0; i < points.length; i++) {
      final normalized = (points[i].commission - minValue) / valueRange;
      offsets.add(
        Offset(
          chart.left + step * i,
          chart.bottom - normalized * (chart.height * .54) - chart.height * .18,
        ),
      );
    }

    final line = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (var i = 1; i < offsets.length; i++) {
      final previous = offsets[i - 1];
      final current = offsets[i];
      final controlX = (previous.dx + current.dx) / 2;
      line.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fill = Path.from(line)
      ..lineTo(offsets.last.dx, chart.bottom)
      ..lineTo(offsets.first.dx, chart.bottom)
      ..close();
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [AppColors.buy20, AppColors.buy10.withValues(alpha: 0)],
      ).createShader(chart);
    final linePaint = Paint()
      ..color = AppColors.buy
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(fill, fillPaint);
    canvas.drawPath(line, linePaint);
  }

  @override
  bool shouldRepaint(covariant _ReferralRewardChartPainter oldDelegate) {
    return oldDelegate.points != points;
  }
}

String _formatUsd(double value) {
  return '\$${value.toStringAsFixed(2)}';
}
