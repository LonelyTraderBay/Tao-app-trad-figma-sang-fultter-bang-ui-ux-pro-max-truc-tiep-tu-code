import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
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

class LaunchpadStakingPage extends ConsumerStatefulWidget {
  const LaunchpadStakingPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc298_launchpad_staking_content');
  static const heroKey = Key('sc298_launchpad_staking_hero');
  static const tabsKey = Key('sc298_launchpad_staking_tabs');
  static const batchClaimKey = Key('sc298_launchpad_staking_batch_claim');
  static const calculatorKey = Key('sc298_launchpad_staking_calculator');
  static const disclaimerKey = Key('sc298_launchpad_staking_disclaimer');

  static Key tabKey(String id) => Key('sc298_launchpad_staking_tab_$id');
  static Key poolKey(String id) => Key('sc298_launchpad_staking_pool_$id');
  static Key positionKey(String id) =>
      Key('sc298_launchpad_staking_position_$id');
  static Key claimKey(String id) => Key('sc298_launchpad_staking_claim_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadStakingPage> createState() =>
      _LaunchpadStakingPageState();
}

class _LaunchpadStakingPageState extends ConsumerState<LaunchpadStakingPage> {
  var _activeTab = _StakingTab.pools;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getStaking();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-298 LaunchpadStakingPage',
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
            _StakingTabs(
              activeTab: _activeTab,
              onChanged: (tab) => setState(() => _activeTab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadStakingPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      _StakingHero(snapshot: snapshot),
                      switch (_activeTab) {
                        _StakingTab.pools => _PoolsTab(snapshot: snapshot),
                        _StakingTab.positions => _PositionsTab(
                          snapshot: snapshot,
                        ),
                        _StakingTab.calculator => _ApyCalculator(
                          pools: snapshot.pools,
                        ),
                      },
                      const _RiskDisclosure(),
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

class _StakingTabs extends StatelessWidget {
  const _StakingTabs({required this.activeTab, required this.onChanged});

  final _StakingTab activeTab;
  final ValueChanged<_StakingTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        key: LaunchpadStakingPage.tabsKey,
        children: [
          for (final tab in _StakingTab.values)
            Expanded(
              child: InkWell(
                key: LaunchpadStakingPage.tabKey(tab.id),
                onTap: () => onChanged(tab),
                child: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.x4),
                  child: Column(
                    children: [
                      Text(
                        tab.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: tab == activeTab
                              ? AppColors.primary
                              : AppColors.text3,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: 2,
                        width: tab == activeTab ? 116 : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.xsRadius,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StakingHero extends StatelessWidget {
  const _StakingHero({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.buy15,
                  border: Border.all(color: AppColors.buy20),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.currency_exchange_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng giá trị stake',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      _formatUsd(snapshot.totalStaked),
                      style: AppTextStyles.heroNumber.copyWith(
                        color: AppColors.text1,
                        fontSize: 24,
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
                child: _HeroMetric(
                  label: 'Pools hoạt động',
                  value: '${snapshot.activePoolCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Phần thưởng chờ',
                  value: _formatToken(snapshot.totalPendingRewards),
                  valueColor: AppColors.warn,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Vị trí',
                  value: '${snapshot.positions.length}',
                  valueColor: AppColors.text1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PoolsTab extends StatelessWidget {
  const _PoolsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final pool in snapshot.pools) ...[
          _PoolCard(pool: pool, detailRoute: snapshot.detailRoute),
          if (pool != snapshot.pools.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _PoolCard extends StatelessWidget {
  const _PoolCard({required this.pool, required this.detailRoute});

  final LaunchpoolPoolDraft pool;
  final String detailRoute;

  @override
  Widget build(BuildContext context) {
    final currentTier = _currentTier(pool.tiers, pool.userStaked);
    return VitCard(
      key: LaunchpadStakingPage.poolKey(pool.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      onTap: () => context.go(detailRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: pool.projectLogo,
                color: pool.accent,
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            pool.projectName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        const VitStatusPill(
                          label: 'Launchpool',
                          status: VitStatusPillStatus.success,
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    Text(
                      'Stake ${pool.stakeToken} · Earn ${pool.rewardToken}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
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
                    '${_formatApy(pool.effectiveApy)}%',
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: pool.accent,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'APY',
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Tổng stake',
                  value: pool.totalStakedDisplay,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Lock',
                  value: '${pool.lockPeriodDays} ngày',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(label: 'Chain', value: pool.chain),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          _CapacityBar(pool: pool),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (final tier in pool.tiers) ...[
                Expanded(
                  child: _TierChip(
                    tier: tier,
                    selected: currentTier?.label == tier.label,
                  ),
                ),
                if (tier != pool.tiers.last)
                  const SizedBox(width: AppSpacing.x2),
              ],
            ],
          ),
          if (pool.userStaked > 0) ...[
            const SizedBox(height: AppSpacing.x4),
            _UserStakeSummary(pool: pool),
          ],
          const SizedBox(height: AppSpacing.x4),
          _TimelineStatus(status: pool.status),
          const SizedBox(height: AppSpacing.x4),
          _PoolAction(pool: pool),
        ],
      ),
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.snapshot});

  final LaunchpadStakingSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.positions.isEmpty) {
      return VitCard(
        padding: const EdgeInsets.all(AppSpacing.x6),
        child: Column(
          children: [
            const Icon(
              Icons.currency_exchange_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Chưa có vị trí nào',
              style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Bắt đầu stake vào pool để nhận phần thưởng token mới.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        VitCard(
          key: LaunchpadStakingPage.batchClaimKey,
          radius: VitCardRadius.lg,
          borderColor: AppColors.buy20,
          padding: const EdgeInsets.all(AppSpacing.x4),
          onTap: () => context.go(snapshot.batchClaimRoute),
          child: Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.buy15,
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.bolt_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Batch Claim',
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      'Nhận phần thưởng từ tất cả vị trí cùng lúc',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final position in snapshot.positions) ...[
          _PositionCard(
            position: position,
            claimReceiptRoute: snapshot.claimReceiptRoute,
          ),
          if (position != snapshot.positions.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _PositionCard extends StatelessWidget {
  const _PositionCard({
    required this.position,
    required this.claimReceiptRoute,
  });

  final LaunchpadStakePositionDraft position;
  final String claimReceiptRoute;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.positionKey(position.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _LogoBadge(
                label: position.projectSymbol.length > 2
                    ? position.projectSymbol.substring(0, 2)
                    : position.projectSymbol,
                color: position.accent,
                size: AppSpacing.x7,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      position.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Stake ${position.stakeToken} · Earn ${position.rewardToken}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const VitStatusPill(
                label: 'Đang stake',
                status: VitStatusPillStatus.success,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Số lượng stake',
                  value: _formatUsd(position.stakedAmount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'APY',
                  value: '${_formatApy(position.apy)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Phần thưởng chờ',
                  value:
                      '${_formatToken(position.pendingRewards)} ${position.rewardToken}',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Đã nhận',
                  value:
                      '${_formatToken(position.claimedRewards)} ${position.rewardToken}',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warn15,
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Row(
              children: [
                const Icon(
                  Icons.lock_clock_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.iconSm,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Khóa đến: ${position.lockUntil}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: VitCtaButton(
                  key: LaunchpadStakingPage.claimKey(position.id),
                  variant: VitCtaButtonVariant.secondary,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.redeem_rounded),
                  onPressed: () => context.go(claimReceiptRoute),
                  child: const Text('Nhận thưởng'),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: VitCtaButton(
                  variant: VitCtaButtonVariant.ghost,
                  height: AppSpacing.buttonCompact,
                  leading: const Icon(Icons.lock_open_rounded),
                  onPressed: HapticFeedback.selectionClick,
                  child: const Text('Unstake'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ApyCalculator extends StatefulWidget {
  const _ApyCalculator({required this.pools});

  final List<LaunchpoolPoolDraft> pools;

  @override
  State<_ApyCalculator> createState() => _ApyCalculatorState();
}

class _ApyCalculatorState extends State<_ApyCalculator> {
  late String _poolId = widget.pools
      .firstWhere((pool) => pool.status == LaunchpoolPoolStatus.active)
      .id;
  var _amount = 1000.0;
  var _days = 30;

  @override
  Widget build(BuildContext context) {
    final pool = widget.pools.firstWhere(
      (candidate) => candidate.id == _poolId,
    );
    final tierBonus = _currentTier(pool.tiers, _amount)?.apyBonus ?? 0;
    final apy = pool.baseApy + tierBonus;
    final rewards = (_amount * apy / 100) / 365 * _days / pool.rewardTokenPrice;
    final nextTier = _nextTier(pool.tiers, _amount);

    return VitCard(
      key: LaunchpadStakingPage.calculatorKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.calculate_outlined,
                color: AppColors.primary,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Tính toán phần thưởng',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitTabBar(
            tabs: [
              for (final candidate in widget.pools.where(
                (pool) => pool.status == LaunchpoolPoolStatus.active,
              ))
                VitTabItem(key: candidate.id, label: candidate.projectSymbol),
            ],
            activeKey: _poolId,
            onChanged: (id) => setState(() => _poolId = id),
            variant: VitTabBarVariant.segment,
          ),
          const SizedBox(height: AppSpacing.x5),
          _StepperField(
            label: 'Số tiền stake',
            value: _formatUsd(_amount),
            onMinus: () => setState(
              () => _amount = (_amount - 500).clamp(100, 20000).toDouble(),
            ),
            onPlus: () => setState(
              () => _amount = (_amount + 500).clamp(100, 20000).toDouble(),
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          _StepperField(
            label: 'Thời gian',
            value: '$_days ngày',
            onMinus: () =>
                setState(() => _days = (_days - 7).clamp(7, 90).toInt()),
            onPlus: () =>
                setState(() => _days = (_days + 7).clamp(7, 90).toInt()),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: pool.accent.withValues(alpha: .24),
            padding: const EdgeInsets.all(AppSpacing.x4),
            child: Column(
              children: [
                _ResultRow(label: 'APY hiệu lực', value: '${_formatApy(apy)}%'),
                const SizedBox(height: AppSpacing.x3),
                _ResultRow(
                  label: 'Phần thưởng ước tính',
                  value: '${_formatToken(rewards)} ${pool.rewardToken}',
                  valueColor: AppColors.warn,
                ),
                if (nextTier != null) ...[
                  const SizedBox(height: AppSpacing.x3),
                  Text(
                    'Stake thêm ${_formatUsd(nextTier.minStake - _amount)} để lên ${nextTier.label} (+${_formatApy(nextTier.apyBonus)}%).',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskDisclosure extends StatelessWidget {
  const _RiskDisclosure();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadStakingPage.disclaimerKey,
      variant: VitCardVariant.inner,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.iconSm,
          ),
          const SizedBox(width: AppSpacing.x3),
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
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: FontWeight.w800,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _LogoBadge extends StatelessWidget {
  const _LogoBadge({
    required this.label,
    required this.color,
    required this.size,
  });

  final String label;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        border: Border.all(color: color.withValues(alpha: .34), width: 1.5),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x3,
      ),
      child: Column(
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              maxLines: 1,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CapacityBar extends StatelessWidget {
  const _CapacityBar({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    final percentage = (pool.fillRatio * 100).clamp(0, 100).toDouble();
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Pool capacity',
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
            const Spacer(),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: LinearProgressIndicator(
            minHeight: AppSpacing.x2,
            value: percentage / 100,
            backgroundColor: AppColors.surface3,
            valueColor: AlwaysStoppedAnimation<Color>(pool.accent),
          ),
        ),
      ],
    );
  }
}

class _TierChip extends StatelessWidget {
  const _TierChip({required this.tier, required this.selected});

  final LaunchpadStakingTierDraft tier;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x3,
      ),
      decoration: BoxDecoration(
        color: selected
            ? tier.accent.withValues(alpha: .12)
            : AppColors.surface2,
        border: Border.all(
          color: selected
              ? tier.accent.withValues(alpha: .34)
              : AppColors.cardBorder,
        ),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              tier.label,
              style: AppTextStyles.micro.copyWith(
                color: tier.accent,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            '+${_formatApy(tier.apyBonus)}%',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 9,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _UserStakeSummary extends StatelessWidget {
  const _UserStakeSummary({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: pool.accent.withValues(alpha: .18),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _SummaryText(
              label: 'Bạn đang stake',
              value: _formatUsd(pool.userStaked),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _SummaryText(
              label: 'Phần thưởng chờ',
              value: '${_formatToken(pool.userRewards)} ${pool.rewardToken}',
              alignEnd: true,
              valueColor: AppColors.warn,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryText extends StatelessWidget {
  const _SummaryText({
    required this.label,
    required this.value,
    this.alignEnd = false,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineStatus extends StatelessWidget {
  const _TimelineStatus({required this.status});

  final LaunchpoolPoolStatus status;

  @override
  Widget build(BuildContext context) {
    final text = switch (status) {
      LaunchpoolPoolStatus.upcoming => 'Đã kết thúc',
      LaunchpoolPoolStatus.active => 'Đã kết thúc',
      LaunchpoolPoolStatus.ended => 'Đã kết thúc',
    };
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.buy,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PoolAction extends StatelessWidget {
  const _PoolAction({required this.pool});

  final LaunchpoolPoolDraft pool;

  @override
  Widget build(BuildContext context) {
    if (pool.status == LaunchpoolPoolStatus.upcoming) {
      return VitCard(
        variant: VitCardVariant.inner,
        borderColor: AppColors.warningBorder,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x2),
            Text(
              'Sắp mở',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.warn,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      );
    }

    if (pool.status == LaunchpoolPoolStatus.ended) {
      return const VitCtaButton(
        onPressed: null,
        leading: Icon(Icons.lock_outline_rounded),
        child: Text('Đã kết thúc'),
      );
    }

    return VitCtaButton(
      variant: VitCtaButtonVariant.primary,
      leading: const Icon(Icons.currency_exchange_rounded),
      onPressed: HapticFeedback.selectionClick,
      child: Text(pool.userStaked > 0 ? 'Stake thêm' : 'Bắt đầu stake'),
    );
  }
}

class _StepperField extends StatelessWidget {
  const _StepperField({
    required this.label,
    required this.value,
    required this.onMinus,
    required this.onPlus,
  });

  final String label;
  final String value;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  value,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ),
          _RoundIconButton(icon: Icons.remove_rounded, onTap: onMinus),
          const SizedBox(width: AppSpacing.x2),
          _RoundIconButton(icon: Icons.add_rounded, onTap: onPlus),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface3,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.smRadius,
        child: SizedBox(
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          child: Icon(icon, color: AppColors.text1, size: AppSpacing.iconSm),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}

enum _StakingTab {
  pools('pools', 'Pools'),
  positions('positions', 'Vị trí của tôi'),
  calculator('calculator', 'Tính APY');

  const _StakingTab(this.id, this.label);

  final String id;
  final String label;
}

LaunchpadStakingTierDraft? _currentTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  LaunchpadStakingTierDraft? selected;
  for (final tier in tiers) {
    if (amount >= tier.minStake) selected = tier;
  }
  return selected;
}

LaunchpadStakingTierDraft? _nextTier(
  List<LaunchpadStakingTierDraft> tiers,
  double amount,
) {
  for (final tier in tiers) {
    if (amount < tier.minStake) return tier;
  }
  return null;
}

String _formatUsd(double value) => '\$${_comma(value.round())}';

String _formatToken(double value) => _comma(value.round());

String _formatApy(double value) {
  final rounded = value.toStringAsFixed(
    value.truncateToDouble() == value ? 0 : 1,
  );
  return rounded;
}

String _comma(int value) {
  final sign = value < 0 ? '-' : '';
  final text = value.abs().toString();
  final buffer = StringBuffer(sign);
  for (var index = 0; index < text.length; index++) {
    final fromEnd = text.length - index;
    buffer.write(text[index]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
