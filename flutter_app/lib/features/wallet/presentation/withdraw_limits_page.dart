import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/wallet_repository.dart';

const _limitsBackground = AppColors.bg;
const _limitsPanel = AppColors.surface;
const _limitsHero = AppColors.surface;
const _limitsHeroBorder = AppColors.primary20;
const _limitsBorder = Color(0x14FFFFFF);
const _limitsPrimary = AppColors.primary;
const _limitsGreen = Color(0xFF10B981);
const _limitsAmber = Color(0xFFF59E0B);
const _limitsMuted = AppColors.text3;

class WithdrawLimitsPage extends ConsumerWidget {
  const WithdrawLimitsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc153_withdraw_limits_content');
  static const upgradeKycKey = Key('sc153_withdraw_limits_upgrade_kyc');
  static Key tierKey(int level) => Key('sc153_withdraw_limits_tier_$level');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(walletRepositoryProvider).getWithdrawLimits();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 92
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-153 WithdrawLimitsPage',
      child: Material(
        color: _limitsBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'H\u1EA1n m\u1EE9c r\u00FAt ti\u1EC1n',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.wallet),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: WithdrawLimitsPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CurrentTierCard(snapshot: snapshot),
                    const SizedBox(height: 18),
                    _QuickStats(tier: snapshot.currentTier),
                    const SizedBox(height: 16),
                    const _LimitWarning(),
                    const SizedBox(height: 18),
                    const _SectionLabel(
                      label: 'So s\u00E1nh h\u1EA1n m\u1EE9c theo c\u1EA5p KYC',
                    ),
                    const SizedBox(height: 10),
                    for (final tier in snapshot.tiers) ...[
                      _KycTierCard(
                        tier: tier,
                        currentLevel: snapshot.currentLevel,
                      ),
                      if (tier != snapshot.tiers.last)
                        const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 18),
                    _FaqCard(faqs: snapshot.faqs),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentTierCard extends StatelessWidget {
  const _CurrentTierCard({required this.snapshot});

  final WalletWithdrawLimitsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tier = snapshot.currentTier;
    final tierColor = Color(tier.colorHex);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
      decoration: BoxDecoration(
        color: _limitsHero,
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: _limitsHeroBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: tierColor.withValues(alpha: .14),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: tierColor.withValues(alpha: .5)),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.shield_outlined, color: tierColor, size: 25),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'KYC Level ${tier.level}',
                          style: AppTextStyles.body.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            height: 1.05,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Flexible(
                          child: _Pill(
                            label: tier.name,
                            color: tierColor,
                            compact: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\u0110\u00E3 x\u00E1c minh',
                      style: AppTextStyles.micro.copyWith(
                        color: _limitsMuted,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.check_circle_outline, color: tierColor, size: 22),
            ],
          ),
          const SizedBox(height: 24),
          _LimitProgress(
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/ng\u00E0y',
            used: snapshot.usedToday,
            limit: tier.dailyLimit,
            remaining: snapshot.dailyRemaining,
            percent: snapshot.dailyPercent,
          ),
          const SizedBox(height: 18),
          _LimitProgress(
            label: 'H\u1EA1n m\u1EE9c r\u00FAt/th\u00E1ng',
            used: snapshot.usedMonth,
            limit: tier.monthlyLimit,
            remaining: snapshot.monthlyRemaining,
            percent: snapshot.monthlyPercent,
          ),
        ],
      ),
    );
  }
}

class _LimitProgress extends StatelessWidget {
  const _LimitProgress({
    required this.label,
    required this.used,
    required this.limit,
    required this.remaining,
    required this.percent,
  });

  final String label;
  final double used;
  final double limit;
  final double remaining;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 12,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${_formatUsd(used)} / ${_formatUsd(limit)}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 12,
                fontWeight: FontWeight.w900,
                height: 1,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            minHeight: 8,
            value: (percent / 100).clamp(0, 1).toDouble(),
            color: _limitsGreen,
            backgroundColor: AppColors.surface3,
          ),
        ),
        const SizedBox(height: 9),
        Row(
          children: [
            Expanded(
              child: Text(
                'C\u00F2n l\u1EA1i: ${_formatUsd(remaining)}',
                style: AppTextStyles.micro.copyWith(
                  color: _limitsGreen,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
            ),
            Text(
              '${percent.toStringAsFixed(1)}% \u0111\u00E3 d\u00F9ng',
              style: AppTextStyles.micro.copyWith(
                color: _limitsMuted,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({required this.tier});

  final WalletKycTier tier;

  @override
  Widget build(BuildContext context) {
    final stats = [
      (
        label: 'R\u00FAt/ng\u00E0y t\u1ED1i \u0111a',
        value: _formatUsd(tier.dailyLimit),
        color: _limitsPrimary,
      ),
      (
        label: 'Giao d\u1ECBch \u0111\u01A1n',
        value: _formatUsd(tier.singleTxLimit),
        color: _limitsGreen,
      ),
      (
        label: 'R\u00FAt/th\u00E1ng',
        value: _formatUsd(tier.monthlyLimit),
        color: _limitsAmber,
      ),
    ];

    return Row(
      children: [
        for (final stat in stats) ...[
          Expanded(
            child: Container(
              height: 58,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: _limitsPanel,
                borderRadius: AppRadii.inputRadius,
                border: Border.all(color: _limitsBorder),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      stat.value,
                      style: AppTextStyles.caption.copyWith(
                        color: stat.color,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  Text(
                    stat.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(
                      color: _limitsMuted,
                      fontSize: 9,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (stat != stats.last) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _LimitWarning extends StatelessWidget {
  const _LimitWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 13, 16, 13),
      decoration: BoxDecoration(
        color: _limitsAmber.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _limitsAmber.withValues(alpha: .34)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _limitsAmber,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(
                    text:
                        'Y\u00EAu c\u1EA7u r\u00FAt tr\u00EAn \$10,000.00 s\u1EBD c\u1EA7n xem x\u00E9t th\u1EE7 c\u00F4ng (l\u00EAn \u0111\u1EBFn 24 gi\u1EDD). ',
                  ),
                  TextSpan(
                    text:
                        'R\u00FAt tr\u00EAn \$50,000.00 c\u1EA7n x\u00E1c minh video call.',
                    style: AppTextStyles.caption.copyWith(
                      color: _limitsAmber,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
              style: AppTextStyles.caption.copyWith(
                color: _limitsAmber,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _limitsPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: FontWeight.w900,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _KycTierCard extends StatelessWidget {
  const _KycTierCard({required this.tier, required this.currentLevel});

  final WalletKycTier tier;
  final int currentLevel;

  @override
  Widget build(BuildContext context) {
    final tierColor = Color(tier.colorHex);
    final isCurrent = tier.level == currentLevel;
    final isCompleted = tier.level < currentLevel;
    final isLocked = tier.level > currentLevel;

    return GestureDetector(
      key: WithdrawLimitsPage.tierKey(tier.level),
      onTap: isLocked ? () => context.go(AppRoutePaths.profileKyc) : () {},
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: AppSpacing.buttonStandard + AppSpacing.x4,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: _limitsPanel,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: isCurrent ? tierColor.withValues(alpha: .45) : _limitsBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: tierColor.withValues(alpha: isCurrent ? .15 : .12),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Icon(
                isLocked
                    ? Icons.lock_outline_rounded
                    : isCompleted
                    ? Icons.check_circle_outline_rounded
                    : Icons.star_border_rounded,
                color: tierColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Level ${tier.level}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          height: 1,
                        ),
                      ),
                      const SizedBox(width: 9),
                      Flexible(
                        child: Text(
                          tier.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: tierColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                      ),
                      if (isCurrent) ...[
                        const SizedBox(width: 8),
                        _Pill(
                          label: 'HI\u1EC6N T\u1EA0I',
                          color: tierColor,
                          compact: true,
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 9),
                  Text(
                    tier.dailyLimit > 0
                        ? '${_formatUsd(tier.dailyLimit)}/ng\u00E0y'
                        : 'Kh\u00F4ng c\u00F3 h\u1EA1n m\u1EE9c',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _limitsMuted,
                      fontSize: 11,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF4A5568),
              size: 21,
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faqs});

  final List<WalletLimitFaq> faqs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: _limitsPanel,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _limitsBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'C\u00E2u h\u1ECFi th\u01B0\u1EDDng g\u1EB7p',
            style: AppTextStyles.body.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < faqs.length; i++) ...[
            Text(
              faqs[i].question,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              faqs[i].answer,
              style: AppTextStyles.caption.copyWith(
                color: _limitsMuted,
                fontSize: 12,
                height: 1.45,
              ),
            ),
            if (i != faqs.length - 1) ...[
              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 14),
            ],
          ],
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.label, required this.color, this.compact = false});

  final String label;
  final Color color;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 7 : 8,
        vertical: compact ? 4 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: compact ? 10 : 11,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final integer = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < integer.length; i++) {
    if (i > 0 && (integer.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(integer[i]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
