import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/features/launchpad/data/launchpad_repository.dart';

class LaunchpadClaimReceiptPage extends ConsumerStatefulWidget {
  const LaunchpadClaimReceiptPage({
    super.key,
    this.positionId = 'pos001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc302_launchpad_claim_receipt_content');
  static const tabsKey = Key('sc302_launchpad_claim_receipt_tabs');
  static const heroKey = Key('sc302_launchpad_claim_receipt_hero');
  static const heroAmountKey = Key('sc302_launchpad_claim_receipt_hero_amount');
  static const claimableKey = Key('sc302_launchpad_claim_receipt_claimable');
  static const detailsKey = Key('sc302_launchpad_claim_receipt_details');
  static const vestingPreviewKey = Key(
    'sc302_launchpad_claim_receipt_vesting_preview',
  );
  static const claimSheetKey = Key('sc302_launchpad_claim_receipt_claim_sheet');

  static Key tabKey(String id) => Key('sc302_launchpad_claim_receipt_tab_$id');
  static Key vestingKey(String id) =>
      Key('sc302_launchpad_claim_receipt_vesting_$id');
  static Key historyKey(String id) =>
      Key('sc302_launchpad_claim_receipt_history_$id');

  final String positionId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadClaimReceiptPage> createState() =>
      _LaunchpadClaimReceiptPageState();
}

class _LaunchpadClaimReceiptPageState
    extends ConsumerState<LaunchpadClaimReceiptPage> {
  var _activeTab = _ClaimReceiptTab.overview;
  LaunchpadRewardVestingEntryDraft? _claimEntry;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(launchpadRepositoryProvider)
        .getClaimReceipt(widget.positionId);
    final receipt = snapshot.receipt;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-302 LaunchpadClaimReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: Stack(
          children: [
            Column(
              children: [
                VitHeader(
                  title: snapshot.title,
                  showBack: true,
                  action: VitHeaderAction.bell,
                  onBack: () => context.go(snapshot.backRoute),
                  onAction: HapticFeedback.selectionClick,
                ),
                Container(
                  key: LaunchpadClaimReceiptPage.tabsKey,
                  decoration: const BoxDecoration(
                    color: AppColors.navBg,
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.contentPad,
                  ),
                  child: VitTabBar(
                    tabs: const [
                      VitTabItem(key: 'overview', label: 'Tổng quan'),
                      VitTabItem(key: 'vesting', label: 'Vesting'),
                      VitTabItem(key: 'history', label: 'Lịch sử'),
                    ],
                    activeKey: _activeTab.id,
                    variant: VitTabBarVariant.underline,
                    onChanged: (id) =>
                        setState(() => _activeTab = _ClaimReceiptTab.byId(id)),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: LaunchpadClaimReceiptPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(bottom: bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.defaultPadding,
                      customGap: AppSpacing.x4,
                      children: [
                        _RewardHero(receipt: receipt),
                        if (_activeTab == _ClaimReceiptTab.overview) ...[
                          _ClaimableBanner(
                            receipt: receipt,
                            onClaim: () => setState(
                              () => _claimEntry = receipt.vestingSchedule
                                  .firstWhere(
                                    (entry) =>
                                        entry.status ==
                                            LaunchpadVestingEntryStatus
                                                .claimable ||
                                        entry.status ==
                                            LaunchpadVestingEntryStatus
                                                .unlocking,
                                    orElse: () => receipt.vestingSchedule.first,
                                  ),
                            ),
                          ),
                          _NextUnlockCard(receipt: receipt),
                          _ReceiptDetailsCard(receipt: receipt),
                          _VestingPreviewCard(
                            receipt: receipt,
                            onOpenAll: () => setState(
                              () => _activeTab = _ClaimReceiptTab.vesting,
                            ),
                          ),
                        ] else if (_activeTab == _ClaimReceiptTab.vesting)
                          _VestingTimelineCard(
                            receipt: receipt,
                            onClaim: (entry) =>
                                setState(() => _claimEntry = entry),
                          )
                        else
                          _ClaimHistoryCard(receipt: receipt),
                        const _RiskDisclosureTile(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_claimEntry != null)
              _ClaimSheet(
                entry: _claimEntry!,
                receipt: receipt,
                onClose: () => setState(() => _claimEntry = null),
              ),
          ],
        ),
      ),
    );
  }
}

class _RewardHero extends StatelessWidget {
  const _RewardHero({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final claimedPct = (receipt.claimedRatio * 100).round();
    final vestedPct = (receipt.vestedRatio * 100).round();

    return VitCard(
      key: LaunchpadClaimReceiptPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: receipt.accent.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _TokenAvatar(receipt: receipt),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receipt.projectName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            _formatNumber(receipt.totalEarned),
                            key: LaunchpadClaimReceiptPage.heroAmountKey,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.pageTitle.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                          child: Text(
                            receipt.rewardToken,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '~${_formatUsd(receipt.totalEarned * receipt.rewardTokenPrice)} USD',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tiến độ vest',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.portfolioTextMuted,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                '$vestedPct%',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: SizedBox(
              height: AppSpacing.x3,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  const ColoredBox(color: AppColors.surface3),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: receipt.vestedRatio.clamp(0, 1),
                    child: ColoredBox(color: receipt.accent),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: receipt.claimedRatio.clamp(0, 1),
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã nhận $claimedPct%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Text(
                'Đã vest $vestedPct%',
                style: AppTextStyles.micro.copyWith(
                  color: receipt.accent,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Đã nhận',
                  value: _formatNumber(receipt.totalClaimed),
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Chờ nhận',
                  value: _formatNumber(receipt.totalPending),
                  color: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Còn khóa',
                  value: _formatNumber(receipt.lockedAmount),
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: receipt.accent.withValues(alpha: .12),
        border: Border.all(color: receipt.accent.withValues(alpha: .38)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        receipt.projectSymbol.substring(0, 2),
        style: AppTextStyles.caption.copyWith(
          color: receipt.accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
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

class _ClaimableBanner extends StatelessWidget {
  const _ClaimableBanner({required this.receipt, required this.onClaim});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onClaim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadClaimReceiptPage.claimableKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.buy.withValues(alpha: .30),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.buy15,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Có thể nhận ngay',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                Text(
                  '${_formatNumber(receipt.claimableTotal)} ${receipt.rewardToken}',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 150,
            child: VitCtaButton(
              onPressed: onClaim,
              variant: VitCtaButtonVariant.success,
              child: const Text('Nhận'),
            ),
          ),
        ],
      ),
    );
  }
}

class _NextUnlockCard extends StatelessWidget {
  const _NextUnlockCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: AppColors.warn,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Đợt mở khóa tiếp theo',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.check_circle_outline_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                _unlockStateText(receipt.nextUnlockDate),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.buy,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReceiptDetailsCard extends StatelessWidget {
  const _ReceiptDetailsCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final rows = [
      _DetailRow('Pool', receipt.projectName),
      _DetailRow(
        'Token stake',
        '${_formatNumber(receipt.stakedAmount)} ${receipt.stakeToken}',
      ),
      _DetailRow(
        'APY',
        '${_formatNumber(receipt.poolApy)}%',
        color: AppColors.buy,
      ),
      _DetailRow('Reward token', receipt.rewardToken),
      _DetailRow('Giá token', _formatUsd(receipt.rewardTokenPrice)),
      _DetailRow(
        'Tổng earned',
        '${_formatNumber(receipt.totalEarned)} ${receipt.rewardToken}',
      ),
      _DetailRow(
        'Giá trị earned',
        _formatUsd(receipt.totalEarned * receipt.rewardTokenPrice),
      ),
      _DetailRow('Chain', receipt.chain),
      _DetailRow('Contract', _truncateAddress(receipt.contractAddress)),
    ];

    return VitCard(
      key: LaunchpadClaimReceiptPage.detailsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.receipt_long_outlined,
                color: AppColors.text2,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Chi tiết vị trí',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final row in rows) _DetailLine(row: row),
        ],
      ),
    );
  }
}

class _VestingPreviewCard extends StatelessWidget {
  const _VestingPreviewCard({required this.receipt, required this.onOpenAll});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onOpenAll;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadClaimReceiptPage.vestingPreviewKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lock_outline_rounded,
                color: AppColors.accent,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  'Lịch vesting',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              TextButton(onPressed: onOpenAll, child: const Text('Xem tất cả')),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final entry in receipt.vestingSchedule.take(4))
            _VestingMiniRow(entry: entry),
          if (receipt.vestingSchedule.length > 4)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.x2),
              child: Text(
                '+${receipt.vestingSchedule.length - 4} đợt nữa',
                textAlign: TextAlign.center,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
        ],
      ),
    );
  }
}

class _VestingTimelineCard extends StatelessWidget {
  const _VestingTimelineCard({required this.receipt, required this.onClaim});

  final LaunchpadRewardClaimReceiptDraft receipt;
  final ValueChanged<LaunchpadRewardVestingEntryDraft> onClaim;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lịch trình mở khóa',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xsRadius,
            child: Row(
              children: [
                for (final entry in receipt.vestingSchedule)
                  Expanded(
                    flex: entry.percent,
                    child: SizedBox(
                      height: AppSpacing.x3,
                      child: ColoredBox(color: _vestingColor(entry.status)),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final entry in receipt.vestingSchedule)
            _VestingTimelineRow(entry: entry, onClaim: onClaim),
        ],
      ),
    );
  }
}

class _ClaimHistoryCard extends StatelessWidget {
  const _ClaimHistoryCard({required this.receipt});

  final LaunchpadRewardClaimReceiptDraft receipt;

  @override
  Widget build(BuildContext context) {
    final totalUsd = receipt.claimHistory.fold<double>(
      0,
      (sum, entry) => sum + entry.usdValue,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Row(
            children: [
              Expanded(
                child: _SummaryTile(
                  label: 'Số lượng',
                  value: _formatNumber(receipt.totalClaimed),
                  suffix: receipt.rewardToken,
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryTile(
                  label: 'Giá trị',
                  value: _formatUsd(totalUsd),
                  suffix: 'USD',
                  color: AppColors.text1,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _SummaryTile(
                  label: 'Giao dịch',
                  value: '${receipt.claimHistory.length}',
                  suffix: 'lần',
                  color: AppColors.text1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final entry in receipt.claimHistory) _HistoryEntry(entry: entry),
      ],
    );
  }
}

class _VestingMiniRow extends StatelessWidget {
  const _VestingMiniRow({required this.entry});

  final LaunchpadRewardVestingEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    final color = _vestingColor(entry.status);
    return Container(
      key: LaunchpadClaimReceiptPage.vestingKey(entry.id),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Icon(
            _vestingIcon(entry.status),
            color: color,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  entry.unlockDate,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${_formatNumber(entry.amount)} ${entry.token}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              _StatusBadge(label: _vestingLabel(entry.status), color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _VestingTimelineRow extends StatelessWidget {
  const _VestingTimelineRow({required this.entry, required this.onClaim});

  final LaunchpadRewardVestingEntryDraft entry;
  final ValueChanged<LaunchpadRewardVestingEntryDraft> onClaim;

  @override
  Widget build(BuildContext context) {
    final claimable =
        entry.status == LaunchpadVestingEntryStatus.claimable ||
        entry.status == LaunchpadVestingEntryStatus.unlocking;
    return Padding(
      key: LaunchpadClaimReceiptPage.vestingKey(entry.id),
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: VitCard(
        variant: claimable ? VitCardVariant.inner : VitCardVariant.standard,
        radius: VitCardRadius.md,
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          children: [
            Icon(
              _vestingIcon(entry.status),
              color: _vestingColor(entry.status),
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '${entry.unlockDate} · ${entry.percent}%',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
            if (claimable)
              VitCtaButton(
                onPressed: () => onClaim(entry),
                variant: VitCtaButtonVariant.success,
                fullWidth: false,
                height: AppSpacing.buttonCompact,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x3),
                child: const Text('Nhận'),
              )
            else
              Text(
                '${_formatNumber(entry.amount)} ${entry.token}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ClaimSheet extends StatelessWidget {
  const _ClaimSheet({
    required this.entry,
    required this.receipt,
    required this.onClose,
  });

  final LaunchpadRewardVestingEntryDraft entry;
  final LaunchpadRewardClaimReceiptDraft receipt;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColoredBox(
        color: Colors.black.withValues(alpha: .72),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Material(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Padding(
              key: LaunchpadClaimReceiptPage.claimSheetKey,
              padding: EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x4,
                AppSpacing.contentPad,
                AppSpacing.x5 + MediaQuery.paddingOf(context).bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderSolid,
                        borderRadius: AppRadii.xsRadius,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Nhận phần thưởng',
                          style: AppTextStyles.sectionTitle.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: onClose,
                        icon: const Icon(
                          Icons.close_rounded,
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    '${_formatNumber(entry.amount)} ${entry.token}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.pageTitle.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  Text(
                    '~${_formatUsd(entry.amount * receipt.rewardTokenPrice)} USD',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  _DetailLine(row: _DetailRow('Đợt', entry.label)),
                  _DetailLine(row: _DetailRow('Chain', receipt.chain)),
                  _DetailLine(row: const _DetailRow('Gas ước tính', r'~$0.15')),
                  const SizedBox(height: AppSpacing.x4),
                  VitCtaButton(
                    onPressed: onClose,
                    variant: VitCtaButtonVariant.success,
                    child: Text(
                      'Xác nhận nhận ${_formatNumber(entry.amount)} ${entry.token}',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RiskDisclosureTile extends StatelessWidget {
  const _RiskDisclosureTile();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              'Lưu ý rủi ro đầu tư',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.entry});

  final LaunchpadClaimHistoryEntryDraft entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x3),
      child: VitCard(
        key: LaunchpadClaimReceiptPage.historyKey(entry.id),
        radius: VitCardRadius.md,
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    '+${_formatNumber(entry.amount)} ${entry.token}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                Text(
                  _formatUsd(entry.usdValue),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              '${entry.claimedAt} · Gas: ${entry.gasUsed} · ${entry.txHash}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryTile extends StatelessWidget {
  const _SummaryTile({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
  });

  final String label;
  final String value;
  final String suffix;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          Text(
            suffix,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
        ],
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.row});

  final _DetailRow row;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x2),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            row.value,
            textAlign: TextAlign.right,
            style: AppTextStyles.caption.copyWith(
              color: row.color ?? AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.smRadius,
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

final class _DetailRow {
  const _DetailRow(this.label, this.value, {this.color});

  final String label;
  final String value;
  final Color? color;
}

enum _ClaimReceiptTab {
  overview('overview'),
  vesting('vesting'),
  history('history');

  const _ClaimReceiptTab(this.id);

  final String id;

  static _ClaimReceiptTab byId(String id) {
    return _ClaimReceiptTab.values.firstWhere(
      (tab) => tab.id == id,
      orElse: () => _ClaimReceiptTab.overview,
    );
  }
}

IconData _vestingIcon(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => Icons.check_circle_outline_rounded,
    LaunchpadVestingEntryStatus.claimable => Icons.card_giftcard_rounded,
    LaunchpadVestingEntryStatus.unlocking => Icons.schedule_rounded,
    LaunchpadVestingEntryStatus.locked => Icons.lock_outline_rounded,
  };
}

Color _vestingColor(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => AppColors.buy,
    LaunchpadVestingEntryStatus.claimable => AppColors.primary,
    LaunchpadVestingEntryStatus.unlocking => AppColors.warn,
    LaunchpadVestingEntryStatus.locked => AppColors.text3,
  };
}

String _vestingLabel(LaunchpadVestingEntryStatus status) {
  return switch (status) {
    LaunchpadVestingEntryStatus.claimed => 'Đã nhận',
    LaunchpadVestingEntryStatus.claimable => 'Nhận ngay',
    LaunchpadVestingEntryStatus.unlocking => 'Sắp mở',
    LaunchpadVestingEntryStatus.locked => 'Khóa',
  };
}

String _unlockStateText(String nextUnlockDate) {
  final parts = nextUnlockDate.split(' ');
  if (parts.isEmpty) return 'Đã kết thúc';
  return 'Đã kết thúc';
}

String _truncateAddress(String value) {
  if (value.length <= 14) return value;
  return '${value.substring(0, 6)}...${value.substring(value.length - 4)}';
}

String _formatUsd(double value) {
  final fixed = value < 1 ? value.toStringAsFixed(2) : value.toStringAsFixed(1);
  return '\$${_withCommas(_trimTrailingZero(fixed))}';
}

String _formatNumber(double value) {
  final fixed = value % 1 == 0
      ? value.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return _withCommas(_trimTrailingZero(fixed));
}

String _trimTrailingZero(String value) {
  return value.contains('.')
      ? value.replaceFirst(RegExp(r'\.?0+$'), '')
      : value;
}

String _withCommas(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final fromEnd = whole.length - i;
    buffer.write(whole[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts.last);
  }
  return buffer.toString();
}
