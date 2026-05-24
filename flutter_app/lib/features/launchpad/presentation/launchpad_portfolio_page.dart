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
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

class LaunchpadPortfolioPage extends ConsumerStatefulWidget {
  const LaunchpadPortfolioPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc296_launchpad_portfolio_content');
  static const heroKey = Key('sc296_launchpad_portfolio_hero');
  static const tabsKey = Key('sc296_launchpad_portfolio_tabs');
  static const disclaimerKey = Key('sc296_launchpad_portfolio_disclaimer');

  static Key tabKey(String id) => Key('sc296_launchpad_portfolio_tab_$id');
  static Key subscriptionKey(String id) =>
      Key('sc296_launchpad_portfolio_subscription_$id');
  static Key claimKey(String id) => Key('sc296_launchpad_portfolio_claim_$id');
  static Key refundKey(String id) =>
      Key('sc296_launchpad_portfolio_refund_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPortfolioPage> createState() =>
      _LaunchpadPortfolioPageState();
}

class _LaunchpadPortfolioPageState
    extends ConsumerState<LaunchpadPortfolioPage> {
  var _activeTab = _PortfolioTab.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getPortfolio();
    final subscriptions = _subscriptionsFor(snapshot.subscriptions, _activeTab);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-296 LaunchpadPortfolioPage',
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
                  key: LaunchpadPortfolioPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      _PortfolioHero(subscriptions: snapshot.subscriptions),
                      _PortfolioTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      if (subscriptions.isEmpty)
                        _EmptyPortfolio(route: snapshot.launchpadRoute)
                      else
                        for (final subscription in subscriptions)
                          _SubscriptionCard(
                            subscription: subscription,
                            receiptRoute: snapshot.receiptRoute,
                          ),
                      const _PortfolioDisclaimer(),
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

class _PortfolioHero extends StatelessWidget {
  const _PortfolioHero({required this.subscriptions});

  final List<LaunchpadSubscriptionDraft> subscriptions;

  @override
  Widget build(BuildContext context) {
    final totalInvested = subscriptions.fold<double>(
      0,
      (sum, subscription) => sum + subscription.amount,
    );
    final allocatedCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.allocated ||
              subscription.status ==
                  LaunchpadSubscriptionStatus.partiallyAllocated ||
              subscription.status == LaunchpadSubscriptionStatus.claimed,
        )
        .length;
    final pendingCount = subscriptions
        .where(
          (subscription) =>
              subscription.status == LaunchpadSubscriptionStatus.pending,
        )
        .length;

    return VitCard(
      key: LaunchpadPortfolioPage.heroKey,
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
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary12,
                  border: Border.all(color: AppColors.primary30),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.business_center_outlined,
                  color: AppColors.primary,
                  size: AppSpacing.iconMd,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng đã đầu tư',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextMuted,
                      ),
                    ),
                    Text(
                      _formatUsd(totalInvested),
                      style: AppTextStyles.pageTitle.copyWith(
                        color: AppColors.text1,
                        fontFeatures: AppTextStyles.tabularFigures,
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
                  label: 'Dự án',
                  value: '${subscriptions.length}',
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đã phân bổ',
                  value: '$allocatedCount',
                  color: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  label: 'Đang chờ',
                  value: '$pendingCount',
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.baseMedium.copyWith(
              color: color,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioTabs extends StatelessWidget {
  const _PortfolioTabs({required this.activeTab, required this.onChanged});

  final _PortfolioTab activeTab;
  final ValueChanged<_PortfolioTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: LaunchpadPortfolioPage.tabsKey,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final tab in _PortfolioTab.values)
          InkWell(
            key: LaunchpadPortfolioPage.tabKey(tab.id),
            onTap: () => onChanged(tab),
            borderRadius: AppRadii.inputRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              decoration: BoxDecoration(
                color: tab == activeTab
                    ? AppColors.primary12
                    : AppColors.surface2,
                border: Border.all(
                  color: tab == activeTab
                      ? AppColors.primary30
                      : AppColors.cardBorder,
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.caption.copyWith(
                  color: tab == activeTab ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscription,
    required this.receiptRoute,
  });

  final LaunchpadSubscriptionDraft subscription;
  final String receiptRoute;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(subscription.status);
    final hasClaimable =
        subscription.status == LaunchpadSubscriptionStatus.allocated ||
        subscription.status == LaunchpadSubscriptionStatus.partiallyAllocated;

    return VitCard(
      key: LaunchpadPortfolioPage.subscriptionKey(subscription.id),
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: () => context.go(receiptRoute),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _SubscriptionAvatar(subscription: subscription),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subscription.projectName,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    Text(
                      subscription.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _StatusPill(style: status),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _InfoTile(
                  label: 'Đã đầu tư',
                  value: _formatUsd(subscription.amount),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _InfoTile(
                  label: 'Token phân bổ',
                  value:
                      '${_formatInt(subscription.tokensAllocated)} ${subscription.projectSymbol}',
                ),
              ),
            ],
          ),
          if (subscription.allocationRatio > 0 &&
              subscription.allocationRatio < 1) ...[
            const SizedBox(height: AppSpacing.x3),
            _InlineNotice(
              icon: Icons.error_outline_rounded,
              label:
                  'Phân bổ ${(subscription.allocationRatio * 100).round()}% — Hoàn lại: ${_formatUsd(subscription.refundAmount)}',
              color: AppColors.warn,
            ),
          ],
          const SizedBox(height: AppSpacing.x4),
          _VestingProgress(subscription: subscription),
          if (hasClaimable) ...[
            const SizedBox(height: AppSpacing.x3),
            _ActionRow(
              key: LaunchpadPortfolioPage.claimKey(subscription.id),
              icon: Icons.lock_open_rounded,
              label: 'Có token sẵn sàng nhận',
              color: AppColors.buy,
              onTap: HapticFeedback.selectionClick,
            ),
          ],
          if (subscription.refundAmount > 0 &&
              subscription.status ==
                  LaunchpadSubscriptionStatus.partiallyAllocated) ...[
            const SizedBox(height: AppSpacing.x3),
            _ActionRow(
              key: LaunchpadPortfolioPage.refundKey(subscription.id),
              icon: Icons.file_download_outlined,
              label: 'Nhận hoàn ${_formatUsd(subscription.refundAmount)} USDT',
              color: AppColors.primary,
              onTap: HapticFeedback.selectionClick,
            ),
          ],
        ],
      ),
    );
  }
}

class _SubscriptionAvatar extends StatelessWidget {
  const _SubscriptionAvatar({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: subscription.accent.withValues(alpha: .12),
        border: Border.all(color: subscription.accent.withValues(alpha: .35)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        subscription.projectLogo,
        style: AppTextStyles.caption.copyWith(
          color: subscription.accent,
          fontWeight: AppTextStyles.bold,
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
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _VestingProgress extends StatelessWidget {
  const _VestingProgress({required this.subscription});

  final LaunchpadSubscriptionDraft subscription;

  @override
  Widget build(BuildContext context) {
    final total = _formatInt(subscription.tokensAllocated);
    final claimed = _formatInt(subscription.tokensClaimed);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Vesting',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '$claimed / $total ${subscription.projectSymbol}',
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
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (subscription.vestingProgress / 100).clamp(
                    0.0,
                    1.0,
                  ),
                  child: const ColoredBox(color: AppColors.primary),
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
                '${subscription.vestingProgress}% đã mở khóa',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            const Icon(
              Icons.schedule_rounded,
              color: AppColors.text3,
              size: AppSpacing.iconSm,
            ),
            const SizedBox(width: AppSpacing.x1),
            Text(
              'Tiếp theo: ${subscription.nextUnlockDate}',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ],
    );
  }
}

class _InlineNotice extends StatelessWidget {
  const _InlineNotice({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.x4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: .10),
          border: Border.all(color: color.withValues(alpha: .20)),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppSpacing.iconMd),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: color,
              size: AppSpacing.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.style});

  final _StatusStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .12),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        style.label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontWeight: AppTextStyles.bold,
          height: 1.2,
        ),
      ),
    );
  }
}

class _EmptyPortfolio extends StatelessWidget {
  const _EmptyPortfolio({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.business_center_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            'Chưa có dự án nào',
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            'Bạn chưa tham gia dự án Launchpad nào. Khám phá ngay.',
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            onPressed: () => context.go(route),
            leading: const Icon(Icons.rocket_launch_outlined),
            child: const Text('Khám phá Launchpad'),
          ),
        ],
      ),
    );
  }
}

class _PortfolioDisclaimer extends StatelessWidget {
  const _PortfolioDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Row(
      key: LaunchpadPortfolioPage.disclaimerKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            'Phân bổ thực tế phụ thuộc vào tổng số đăng ký. Token mở khóa theo lịch vesting của từng dự án.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

enum _PortfolioTab {
  all('all', 'Tất cả'),
  pending('pending', 'Đang chờ'),
  allocated('allocated', 'Đã phân bổ'),
  claimed('claimed', 'Đã nhận');

  const _PortfolioTab(this.id, this.label);

  final String id;
  final String label;
}

final class _StatusStyle {
  const _StatusStyle({required this.label, required this.color});

  final String label;
  final Color color;
}

List<LaunchpadSubscriptionDraft> _subscriptionsFor(
  List<LaunchpadSubscriptionDraft> subscriptions,
  _PortfolioTab tab,
) {
  return switch (tab) {
    _PortfolioTab.all => subscriptions,
    _PortfolioTab.pending =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.pending,
          )
          .toList(),
    _PortfolioTab.allocated =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.allocated ||
                subscription.status ==
                    LaunchpadSubscriptionStatus.partiallyAllocated,
          )
          .toList(),
    _PortfolioTab.claimed =>
      subscriptions
          .where(
            (subscription) =>
                subscription.status == LaunchpadSubscriptionStatus.claimed ||
                subscription.status == LaunchpadSubscriptionStatus.refunded,
          )
          .toList(),
  };
}

_StatusStyle _statusStyle(LaunchpadSubscriptionStatus status) {
  return switch (status) {
    LaunchpadSubscriptionStatus.pending => const _StatusStyle(
      label: 'Chờ phân bổ',
      color: AppColors.warn,
    ),
    LaunchpadSubscriptionStatus.allocated => const _StatusStyle(
      label: 'Đã phân bổ',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.partiallyAllocated => const _StatusStyle(
      label: 'Phân bổ 1 phần',
      color: AppColors.primary,
    ),
    LaunchpadSubscriptionStatus.claimed => const _StatusStyle(
      label: 'Đã nhận',
      color: AppColors.buy,
    ),
    LaunchpadSubscriptionStatus.refunded => const _StatusStyle(
      label: 'Đã hoàn tiền',
      color: AppColors.text2,
    ),
  };
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  return '\$${_withCommas(fixed)}';
}

String _formatInt(int value) => _withCommas(value.toString());

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
