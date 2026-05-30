import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_gradients.dart';
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
import 'package:vit_trade_flutter/app/providers/profile_controller_providers.dart';
import 'package:vit_trade_flutter/features/profile/presentation/widgets/vip_history_widgets.dart';

const _vipAccent = AppColors.primary;
const _vipGold = AppColors.warn;
const _vipSuccess = AppColors.buy;
const _vipMuted = AppColors.text3;
const _vipProfileAccent = AppModuleAccents.profile;

enum _VipTab { overview, benefits, history }

class VIPPage extends ConsumerStatefulWidget {
  const VIPPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc164_vip_content');
  static const tradeCtaKey = Key('sc164_vip_trade_cta');
  static Key tabKey(String id) => Key('sc164_vip_tab_$id');
  static Key tierRowKey(int level) => Key('sc164_vip_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<VIPPage> createState() => _VIPPageState();
}

class _VIPPageState extends ConsumerState<VIPPage> {
  _VipTab _selectedTab = _VipTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(profileControllerProvider).getVip();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 110
            : DeviceMetrics.nativeBottomChrome + 30) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-164 VIPPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: 'VIP Program',
              subtitle: 'VIP \u00B7 Profile',
              showBack: true,
              onBack: _close,
            ),
            Expanded(
              child: SingleChildScrollView(
                key: VIPPage.contentKey,
                physics: const BouncingScrollPhysics(),
                child: VitPageContent(
                  padding: VitContentPadding.relaxed,
                  customGap: AppSpacing.x5,
                  children: [
                    _VipHero(snapshot: snapshot),
                    _VipTabs(
                      active: _selectedTab,
                      onChanged: (tab) => setState(() => _selectedTab = tab),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: _tabContent(snapshot),
                    ),
                    SizedBox(height: bottomInset),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabContent(ProfileVipSnapshot snapshot) {
    return switch (_selectedTab) {
      _VipTab.overview => _OverviewTab(
        key: const ValueKey('overview'),
        snapshot: snapshot,
      ),
      _VipTab.benefits => _BenefitsTab(
        key: const ValueKey('benefits'),
        snapshot: snapshot,
        onTrade: _openTrade,
      ),
      _VipTab.history => VipHistoryTab(
        key: const ValueKey('history'),
        snapshot: snapshot,
      ),
    };
  }

  void _openTrade() {
    HapticFeedback.selectionClick();
    context.go(AppRoutePaths.tradePair('btcusdt'));
  }

  void _close() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutePaths.profile);
  }
}

class _VipHero extends StatelessWidget {
  const _VipHero({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final currentTier = snapshot.currentTier;
    return VitModuleHeroCard(
      accentColor: _vipGold,
      padding: EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: AppRadii.cardLargeRadius,
        child: SizedBox(
          height: 186,
          child: Stack(
            children: [
              Positioned(
                right: -38,
                top: -48,
                child: Container(
                  width: 118,
                  height: 118,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _vipGold.withValues(alpha: .12),
                  ),
                ),
              ),
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: AppRadii.cardLargeRadius,
                    gradient: RadialGradient(
                      center: const Alignment(.75, -.75),
                      radius: 1.2,
                      colors: [
                        _vipGold.withValues(alpha: .18),
                        AppColors.primary08,
                        AppColors.transparent,
                      ],
                      stops: const [0, .38, 1],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.contentPad),
                child: Column(
                  children: [
                    Row(
                      children: [
                        _TierIcon(tier: currentTier, large: true),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.workspace_premium_rounded,
                                    color: _vipGold,
                                    size: 16,
                                  ),
                                  const SizedBox(width: AppSpacing.x2),
                                  Flexible(
                                    child: Text(
                                      currentTier.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.sectionTitle
                                          .copyWith(
                                            color: _vipGold,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            height: 1,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.x3),
                              Text(
                                'Th\u00E0nh vi\u00EAn t\u1EEB ${snapshot.memberSince}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.portfolioTextDim,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  height: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        VitStatusPill(
                          label: currentTier.badge,
                          status: VitStatusPillStatus.orange,
                          outline: true,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: _HeroFeeBox(
                            label: 'Maker fee',
                            value: _formatFee(currentTier.makerFee),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x4),
                        Expanded(
                          child: _HeroFeeBox(
                            label: 'Taker fee',
                            value: _formatFee(currentTier.takerFee),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroFeeBox extends StatelessWidget {
  const _HeroFeeBox({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
      child: Column(
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: _vipSuccess,
              fontSize: 22,
              fontWeight: FontWeight.w900,
              height: 1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _VipTabs extends StatelessWidget {
  const _VipTabs({required this.active, required this.onChanged});

  final _VipTab active;
  final ValueChanged<_VipTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.x2),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: VitTabBar(
        variant: VitTabBarVariant.pill,
        activeKey: active.name,
        onChanged: (key) => onChanged(_VipTab.values.byName(key)),
        tabs: const [
          VitTabItem(key: 'overview', label: 'T\u1ED5ng quan'),
          VitTabItem(key: 'benefits', label: '\u0110\u1EB7c quy\u1EC1n'),
          VitTabItem(key: 'history', label: 'L\u1ECBch s\u1EED'),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({super.key, required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    final children = <Widget>[];
    if (nextTier != null) {
      children.add(_ProgressCard(snapshot: snapshot, nextTier: nextTier));
      children.add(const SizedBox(height: AppSpacing.x5));
    }
    children.add(_TierTable(snapshot: snapshot));
    children.add(const SizedBox(height: AppSpacing.x5));
    children.add(const _FeeSavingsCard());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.snapshot, required this.nextTier});

  final ProfileVipSnapshot snapshot;
  final ProfileVipTier nextTier;

  @override
  Widget build(BuildContext context) {
    final volumeProgress = (snapshot.monthlyVolume / nextTier.monthlyVolume)
        .clamp(0.0, 1.0);
    final assetProgress = (snapshot.assetHold / nextTier.assetHold).clamp(
      0.0,
      1.0,
    );

    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text(
                'Ti\u1EBFn \u0111\u1ED9 l\u00EAn h\u1EA1ng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
              const Spacer(),
              _TierIcon(tier: nextTier),
            ],
          ),
          const SizedBox(height: 16),
          _ProgressLine(
            label: 'Kh\u1ED1i l\u01B0\u1EE3ng 30 ng\u00E0y',
            value:
                '${_formatUsd(snapshot.monthlyVolume)} / ${_formatUsd(nextTier.monthlyVolume)}',
            progress: volumeProgress,
            color: _vipAccent,
            helper:
                'C\u1EA7n th\u00EAm ${_formatUsd(nextTier.monthlyVolume - snapshot.monthlyVolume)} \u0111\u1EC3 \u0111\u1EA1t m\u1EE5c ti\u00EAu',
          ),
          const SizedBox(height: 17),
          _ProgressLine(
            label: 'T\u00E0i s\u1EA3n \u0111ang gi\u1EEF',
            value:
                '${_formatUsd(snapshot.assetHold)} / ${_formatUsd(nextTier.assetHold)}',
            progress: assetProgress,
            color: _vipSuccess,
            helper:
                '\u2713 \u0110i\u1EC1u ki\u1EC7n t\u00E0i s\u1EA3n \u0111\u1EA1t \u2713',
            helperColor: _vipSuccess,
          ),
        ],
      ),
    );
  }
}

class _ProgressLine extends StatelessWidget {
  const _ProgressLine({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
    required this.helper,
    this.helperColor = _vipMuted,
  });

  final String label;
  final String value;
  final double progress;
  final Color color;
  final String helper;
  final Color helperColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1,
                ),
              ),
            ),
            Text(
              value,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: FontWeight.w900,
                fontFeatures: AppTextStyles.tabularFigures,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 10,
            value: progress,
            color: color,
            backgroundColor: AppColors.surface3,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          helper,
          style: AppTextStyles.micro.copyWith(
            color: helperColor,
            fontSize: 11,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _TierTable extends StatelessWidget {
  const _TierTable({required this.snapshot});

  final ProfileVipSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      clip: true,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'So s\u00E1nh c\u00E1c c\u1EA5p VIP',
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.divider),
          const _TableHeader(),
          for (final tier in snapshot.tiers)
            _TierRow(tier: tier, active: tier.level == snapshot.currentLevel),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _TableCell(
            flex: 28,
            child: Text('C\u1EA5p \u0111\u1ED9', style: _headerStyle),
          ),
          _TableCell(
            flex: 26,
            child: Text('Volume/th\u00E1ng', style: _headerStyle),
          ),
          _TableCell(flex: 22, child: Text('Maker', style: _headerStyle)),
          _TableCell(flex: 22, child: Text('Taker', style: _headerStyle)),
        ],
      ),
    );
  }

  TextStyle get _headerStyle =>
      AppTextStyles.micro.copyWith(color: _vipMuted, fontSize: 11);
}

class _TierRow extends StatelessWidget {
  const _TierRow({required this.tier, required this.active});

  final ProfileVipTier tier;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final textColor = active ? _vipAccent : AppColors.text1;
    return Container(
      key: VIPPage.tierRowKey(tier.level),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: active ? AppColors.primary08 : AppColors.transparent,
        border: const Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          _TableCell(
            flex: 28,
            child: Row(
              children: [
                _TierIcon(tier: tier),
                const SizedBox(width: AppSpacing.x3),
                Flexible(
                  child: Text(
                    tier.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: textColor,
                      fontWeight: active ? FontWeight.w900 : FontWeight.w700,
                      height: 1.15,
                    ),
                  ),
                ),
                if (active) ...[
                  const SizedBox(width: AppSpacing.x2),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: _vipAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ],
            ),
          ),
          _TableCell(
            flex: 26,
            child: Text(
              tier.monthlyVolume == 0
                  ? '-'
                  : _formatCompactUsd(tier.monthlyVolume),
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 12,
              ),
            ),
          ),
          _TableCell(
            flex: 22,
            child: Text(_formatFee(tier.makerFee), style: _feeStyle(active)),
          ),
          _TableCell(
            flex: 22,
            child: Text(_formatFee(tier.takerFee), style: _feeStyle(active)),
          ),
        ],
      ),
    );
  }

  TextStyle _feeStyle(bool active) {
    return AppTextStyles.micro.copyWith(
      color: active ? _vipSuccess : AppColors.text1,
      fontSize: 12,
      fontWeight: FontWeight.w900,
      fontFeatures: AppTextStyles.tabularFigures,
    );
  }
}

class _TableCell extends StatelessWidget {
  const _TableCell({required this.flex, required this.child});

  final int flex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Expanded(flex: flex, child: child);
  }
}

class _FeeSavingsCard extends StatelessWidget {
  const _FeeSavingsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _vipSuccess.withValues(alpha: .24),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.bolt_rounded, color: _vipSuccess, size: 17),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Ti\u1EBFt ki\u1EC7m ph\u00ED c\u1EE7a b\u1EA1n',
                style: AppTextStyles.body.copyWith(
                  color: _vipSuccess,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              Expanded(
                child: _SavingBox(
                  label: 'Th\u00E1ng n\u00E0y',
                  value: '\$12.45',
                  sub: 'vs. Standard rate',
                ),
              ),
              SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SavingBox(
                  label: 'T\u1ED5ng t\u00EDch l\u0169y',
                  value: '\$89.30',
                  sub: 't\u1EEB 15/08/2023',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SavingBox extends StatelessWidget {
  const _SavingBox({
    required this.label,
    required this.value,
    required this.sub,
  });

  final String label;
  final String value;
  final String sub;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.micro.copyWith(color: _vipMuted)),
          const SizedBox(height: AppSpacing.x3),
          Text(
            value,
            style: AppTextStyles.base.copyWith(
              color: _vipSuccess,
              fontWeight: FontWeight.w900,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            sub,
            style: AppTextStyles.micro.copyWith(
              color: _vipMuted,
              fontSize: 10,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _BenefitsTab extends StatelessWidget {
  const _BenefitsTab({
    super.key,
    required this.snapshot,
    required this.onTrade,
  });

  final ProfileVipSnapshot snapshot;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    final nextTier = snapshot.nextTier;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final tier in snapshot.tiers.where((tier) => tier.level > 0)) ...[
          _BenefitTierCard(
            tier: tier,
            unlocked: snapshot.currentLevel >= tier.level,
          ),
          const SizedBox(height: AppSpacing.x4),
        ],
        if (nextTier != null) _UpgradeCta(nextTier: nextTier, onTrade: onTrade),
      ],
    );
  }
}

class _BenefitTierCard extends StatelessWidget {
  const _BenefitTierCard({required this.tier, required this.unlocked});

  final ProfileVipTier tier;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    final accent = unlocked ? _vipGold : _vipProfileAccent;
    return Opacity(
      opacity: unlocked ? 1 : .68,
      child: VitCard(
        borderColor: accent.withValues(alpha: unlocked ? .34 : .14),
        clip: true,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: unlocked ? .12 : .04),
                border: const Border(
                  bottom: BorderSide(color: AppColors.divider),
                ),
              ),
              child: Row(
                children: [
                  _TierIcon(tier: tier),
                  const SizedBox(width: AppSpacing.x4),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tier.name,
                          style: AppTextStyles.base.copyWith(
                            color: accent,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        Text(
                          'Volume >= ${_formatUsd(tier.monthlyVolume)}/th\u00E1ng ho\u1EB7c T\u00E0i s\u1EA3n >= ${_formatUsd(tier.assetHold)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: _vipMuted,
                            fontSize: 11,
                            height: 1.25,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    unlocked
                        ? Icons.check_circle_outline_rounded
                        : Icons.lock_outline_rounded,
                    color: accent,
                    size: 19,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  for (final feature in tier.features) ...[
                    _FeatureLine(
                      text: feature,
                      accent: accent,
                      unlocked: unlocked,
                    ),
                    if (feature != tier.features.last)
                      const SizedBox(height: AppSpacing.x3),
                  ],
                  const SizedBox(height: AppSpacing.x4),
                  const Divider(height: 1, color: AppColors.divider),
                  const SizedBox(height: AppSpacing.x4),
                  Row(
                    children: [
                      _BenefitMetric(
                        label: 'Maker',
                        value: _formatFee(tier.makerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: AppSpacing.x5),
                      _BenefitMetric(
                        label: 'Taker',
                        value: _formatFee(tier.takerFee),
                        active: unlocked,
                      ),
                      const SizedBox(width: AppSpacing.x5),
                      Expanded(
                        child: _BenefitMetric(
                          label: 'H\u1EA1n m\u1EE9c r\u00FAt',
                          value:
                              '${_formatCompactUsd(tier.withdrawLimit)}/ng\u00E0y',
                          active: unlocked,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureLine extends StatelessWidget {
  const _FeatureLine({
    required this.text,
    required this.accent,
    required this.unlocked,
  });

  final String text;
  final Color accent;
  final bool unlocked;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: unlocked ? .18 : .07),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            color: unlocked ? accent : _vipMuted,
            size: 11,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: unlocked ? AppColors.text1 : _vipMuted,
              fontSize: 13,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _BenefitMetric extends StatelessWidget {
  const _BenefitMetric({
    required this.label,
    required this.value,
    required this.active,
  });

  final String label;
  final String value;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: _vipMuted, fontSize: 10),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _vipSuccess : AppColors.text2,
            fontWeight: FontWeight.w900,
            fontFeatures: AppTextStyles.tabularFigures,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _UpgradeCta extends StatelessWidget {
  const _UpgradeCta({required this.nextTier, required this.onTrade});

  final ProfileVipTier nextTier;
  final VoidCallback onTrade;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      borderColor: _vipAccent.withValues(alpha: .24),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary12,
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(
              Icons.workspace_premium_outlined,
              color: _vipAccent,
              size: 21,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'N\u00E2ng c\u1EA5p l\u00EAn ${nextTier.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: AppSpacing.x3),
                Text(
                  'T\u0103ng kh\u1ED1i l\u01B0\u1EE3ng giao d\u1ECBch \u0111\u1EC3 ti\u1EBFt ki\u1EC7m th\u00EAm',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          GestureDetector(
            key: VIPPage.tradeCtaKey,
            onTap: onTrade,
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: AppSpacing.buttonCompact,
              padding: const EdgeInsets.symmetric(horizontal: 13),
              decoration: BoxDecoration(
                gradient: AppGradients.navCenter,
                borderRadius: AppRadii.smRadius,
              ),
              alignment: Alignment.center,
              child: Text(
                'Giao d\u1ECBch',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.onAccent,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TierIcon extends StatelessWidget {
  const _TierIcon({required this.tier, this.large = false});

  final ProfileVipTier tier;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 56.0 : 18.0;
    final iconSize = large ? 29.0 : 14.0;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _tierAccent(tier).withValues(alpha: large ? .16 : .12),
        borderRadius: large ? AppRadii.cardRadius : AppRadii.smRadius,
      ),
      child: Icon(
        _iconForTier(tier.iconKey),
        color: _tierAccent(tier),
        size: iconSize,
      ),
    );
  }
}

Color _tierAccent(ProfileVipTier tier) {
  if (tier.level == 0) return _vipProfileAccent;
  if (tier.level >= 4) return AppColors.accent;
  return _vipGold;
}

IconData _iconForTier(String key) {
  return switch (key) {
    'star' => Icons.star_rounded,
    'medal' => Icons.military_tech_rounded,
    'workspace' => Icons.workspace_premium_rounded,
    'diamond' => Icons.diamond_outlined,
    'rocket' => Icons.rocket_launch_rounded,
    _ => Icons.person_outline_rounded,
  };
}

String _formatFee(double value) {
  if (value == 0) return '0%';
  return '${value.toStringAsFixed(2)}%';
}

String _formatUsd(double value) {
  return '\$${_formatNumber(value)}.00';
}

String _formatCompactUsd(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(0)}M';
  }
  if (value >= 1000) {
    return '\$${(value / 1000).toStringAsFixed(0)}K';
  }
  return '\$${value.toStringAsFixed(0)}';
}

String _formatNumber(double value) {
  final text = value.toStringAsFixed(0);
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    final remaining = text.length - i;
    buffer.write(text[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  return buffer.toString();
}
