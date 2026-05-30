import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/enterprise_states_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class EnterpriseStatesPage extends ConsumerStatefulWidget {
  const EnterpriseStatesPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc320_enterprise_states_content');
  static const marketCtaKey = Key('sc320_market_cta');
  static const kycCtaKey = Key('sc320_kyc_cta');
  static const loginCtaKey = Key('sc320_login_cta');

  static Key sectionKey(EnterpriseStateSection section) =>
      Key('sc320_section_${section.name}');
  static Key stateKey(EnterprisePreviewState state) =>
      Key('sc320_state_${state.name}');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<EnterpriseStatesPage> createState() =>
      _EnterpriseStatesPageState();
}

class _EnterpriseStatesPageState extends ConsumerState<EnterpriseStatesPage> {
  EnterpriseStateSection _section = EnterpriseStateSection.stateKit;
  EnterprisePreviewState _preview = EnterprisePreviewState.loading;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(enterpriseStatesControllerProvider).reference();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-320 EnterpriseStatesPage',
      child: Material(
        type: MaterialType.transparency,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: SingleChildScrollView(
            key: EnterpriseStatesPage.contentKey,
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: bottomInset),
            child: VitPageContent(
              padding: VitContentPadding.none,
              fullBleed: true,
              customGap: AppSpacing.x5,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    0,
                  ),
                  child: _PageHero(snapshot: snapshot),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.contentPad,
                  ),
                  child: _SectionTabs(
                    tabs: snapshot.tabs,
                    active: _section,
                    onChanged: (section) {
                      HapticFeedback.selectionClick();
                      setState(() => _section = section);
                    },
                  ),
                ),
                if (_section == EnterpriseStateSection.stateKit)
                  _StateKitSection(
                    snapshot: snapshot,
                    activeState: _preview,
                    onStateChanged: (state) {
                      HapticFeedback.selectionClick();
                      setState(() => _preview = state);
                    },
                    onMarkets: () => context.go(snapshot.marketRoute),
                    onKyc: () => context.go(snapshot.kycRoute),
                  )
                else if (_section == EnterpriseStateSection.applied)
                  _AppliedSection(snapshot: snapshot)
                else
                  _SecuritySection(snapshot: snapshot),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageHero extends StatelessWidget {
  const _PageHero({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          decoration: BoxDecoration(
            color: AppColors.buy,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: AppColors.buy20),
          ),
          child: const Icon(
            Icons.layers_outlined,
            color: AppColors.text1,
            size: AppSpacing.iconLg,
          ),
        ),
        const SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                snapshot.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionTabs extends StatelessWidget {
  const _SectionTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<EnterpriseTabDraft> tabs;
  final EnterpriseStateSection active;
  final ValueChanged<EnterpriseStateSection> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: _SectionTabButton(
                tab: tab,
                active: tab.section == active,
                onTap: () => onChanged(tab.section),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionTabButton extends StatelessWidget {
  const _SectionTabButton({
    required this.tab,
    required this.active,
    required this.onTap,
  });

  final EnterpriseTabDraft tab;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        key: EnterpriseStatesPage.sectionKey(tab.section),
        onTap: onTap,
        borderRadius: AppRadii.cardRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.rowPy,
          ),
          decoration: BoxDecoration(
            color: active ? AppColors.primary : AppColors.transparent,
            borderRadius: AppRadii.cardRadius,
          ),
          alignment: Alignment.center,
          child: Text(
            tab.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.text1 : AppColors.text3,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _StateKitSection extends StatelessWidget {
  const _StateKitSection({
    required this.snapshot,
    required this.activeState,
    required this.onStateChanged,
    required this.onMarkets,
    required this.onKyc,
  });

  final EnterpriseStatesSnapshot snapshot;
  final EnterprisePreviewState activeState;
  final ValueChanged<EnterprisePreviewState> onStateChanged;
  final VoidCallback onMarkets;
  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '5 state pattern chuẩn enterprise, match 100% visual style hiện tại. Chọn state để xem preview.',
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (final state in snapshot.previewStates) ...[
                  _PreviewStateChip(
                    state: state,
                    active: state.state == activeState,
                    onTap: () => onStateChanged(state.state),
                  ),
                  if (state != snapshot.previewStates.last)
                    const SizedBox(width: AppSpacing.x3),
                ],
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x6),
          _PreviewFrame(
            activeState: activeState,
            onMarkets: onMarkets,
            onKyc: onKyc,
          ),
          const SizedBox(height: AppSpacing.x6),
          Text(
            'Banner Variants',
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          for (final banner in snapshot.banners) ...[
            _ReferenceBanner(banner: banner),
            if (banner != snapshot.banners.last)
              const SizedBox(height: AppSpacing.x4),
          ],
        ],
      ),
    );
  }
}

class _PreviewStateChip extends StatelessWidget {
  const _PreviewStateChip({
    required this.state,
    required this.active,
    required this.onTap,
  });

  final EnterprisePreviewStateDraft state;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitStatusPill(
      key: EnterpriseStatesPage.stateKey(state.state),
      label: state.label,
      icon: _previewIcon(state.state),
      status: _pillStatus(state.state),
      size: VitStatusPillSize.lg,
      outline: !active,
      onTap: onTap,
    );
  }
}

class _PreviewFrame extends StatelessWidget {
  const _PreviewFrame({
    required this.activeState,
    required this.onMarkets,
    required this.onKyc,
  });

  final EnterprisePreviewState activeState;
  final VoidCallback onMarkets;
  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      clip: true,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.x4,
              vertical: AppSpacing.x3,
            ),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                const VitSkeleton(
                  width: AppSpacing.x6,
                  height: AppSpacing.x6,
                  borderRadius: AppRadii.cardRadius,
                ),
                Expanded(
                  child: Text(
                    'Preview — ${_previewLabel(activeState).toLowerCase()}',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x6),
              ],
            ),
          ),
          if (activeState == EnterprisePreviewState.loading)
            const _SkeletonPreview()
          else if (activeState == EnterprisePreviewState.empty)
            _EmptyPreview(onMarkets: onMarkets)
          else if (activeState == EnterprisePreviewState.error)
            const _ErrorPreview()
          else if (activeState == EnterprisePreviewState.offline)
            const _OfflinePreview()
          else
            _GatePreview(onKyc: onKyc),
        ],
      ),
    );
  }
}

class _SkeletonPreview extends StatelessWidget {
  const _SkeletonPreview();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VitSkeleton(width: 150, height: AppSpacing.x4),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: const [
              VitSkeleton(width: 76, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 60, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 68, height: AppSpacing.x5),
              SizedBox(width: AppSpacing.x3),
              VitSkeleton(width: 52, height: AppSpacing.x5),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < 5; i++) ...[
            const _SkeletonMarketRow(),
            if (i < 4) const SizedBox(height: AppSpacing.x5),
          ],
          const SizedBox(height: AppSpacing.x4),
          const VitSkeleton(width: double.infinity, height: AppSpacing.x6),
        ],
      ),
    );
  }
}

class _SkeletonMarketRow extends StatelessWidget {
  const _SkeletonMarketRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        VitSkeleton(
          width: AppSpacing.inputHeight,
          height: AppSpacing.inputHeight,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        SizedBox(width: AppSpacing.x4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VitSkeleton(width: 130, height: AppSpacing.x4),
              SizedBox(height: AppSpacing.x3),
              VitSkeleton(width: 82, height: AppSpacing.x3),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.x4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            VitSkeleton(width: 74, height: AppSpacing.x4),
            SizedBox(height: AppSpacing.x3),
            VitSkeleton(width: 52, height: AppSpacing.x4),
          ],
        ),
      ],
    );
  }
}

class _EmptyPreview extends StatelessWidget {
  const _EmptyPreview({required this.onMarkets});

  final VoidCallback onMarkets;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x6),
      child: VitEmptyState(
        icon: Icons.star_border_rounded,
        title: 'Bạn chưa theo dõi cặp nào',
        message:
            'Thêm cặp giao dịch vào danh sách theo dõi để không bỏ lỡ biến động giá.',
        actionLabel: 'Thêm vào Watchlist',
        actionKey: EnterpriseStatesPage.marketCtaKey,
        onAction: onMarkets,
      ),
    );
  }
}

class _ErrorPreview extends StatelessWidget {
  const _ErrorPreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.x6),
      child: VitErrorState(
        title: 'Có lỗi xảy ra',
        message: 'Vui lòng thử lại. Nếu lỗi tiếp tục, hãy kiểm tra kết nối.',
      ),
    );
  }
}

class _OfflinePreview extends StatelessWidget {
  const _OfflinePreview();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          VitOfflineBanner(message: 'Mất kết nối. Đang hiển thị dữ liệu cũ.'),
          SizedBox(height: AppSpacing.x5),
          Opacity(opacity: .55, child: VitSkeletonList(rows: 2)),
        ],
      ),
    );
  }
}

class _GatePreview extends StatelessWidget {
  const _GatePreview({required this.onKyc});

  final VoidCallback onKyc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: VitCard(
        variant: VitCardVariant.inner,
        padding: const EdgeInsets.all(AppSpacing.x5),
        child: Column(
          children: [
            const Icon(
              Icons.verified_user_outlined,
              color: AppColors.warn,
              size: AppSpacing.iconLg,
            ),
            const SizedBox(height: AppSpacing.x4),
            Text(
              'Cần KYC để tiếp tục',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            Text(
              'Hoàn tất xác minh danh tính để mở khóa tính năng này.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
            const SizedBox(height: AppSpacing.x5),
            VitCtaButton(
              key: EnterpriseStatesPage.kycCtaKey,
              onPressed: onKyc,
              leading: const Icon(Icons.arrow_forward_rounded),
              child: const Text('Đi tới KYC'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReferenceBanner extends StatelessWidget {
  const _ReferenceBanner({required this.banner});

  final EnterpriseBannerDraft banner;

  @override
  Widget build(BuildContext context) {
    final color = _bannerColor(banner.kind);
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: color.withValues(alpha: .32),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Icon(_bannerIcon(banner.kind), color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                if (banner.detail != null) ...[
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    banner.detail!,
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

class _AppliedSection extends StatelessWidget {
  const _AppliedSection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '6 màn dữ liệu × 4–5 states. Chọn page và state để preview.',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x5),
          _ReferenceTile(
            icon: Icons.bar_chart_rounded,
            title: 'MarketListPage',
            subtitle: 'Loading · Empty · Error · Offline',
            actionLabel: 'Mở Markets',
            onTap: () => context.go(snapshot.marketRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          const _ReferenceTile(
            icon: Icons.history_rounded,
            title: 'OrdersHistoryPage',
            subtitle: 'Gate state requires 2FA before risky actions',
            actionLabel: 'Preview only',
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.snapshot});

  final EnterpriseStatesSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '4 security overlay chuẩn enterprise. Các CTA đi tới route đã migrate hoặc auth shell.',
            style: AppTextStyles.body.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x5),
          _ReferenceTile(
            icon: Icons.login_rounded,
            title: 'Session Expired Modal',
            subtitle: 'Phiên đăng nhập đã hết hạn',
            actionLabel: 'Đăng nhập lại',
            actionKey: EnterpriseStatesPage.loginCtaKey,
            onTap: () => context.go(snapshot.loginRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ReferenceTile(
            icon: Icons.verified_user_outlined,
            title: 'KYC Gate Panel',
            subtitle: 'Cần KYC để tiếp tục',
            actionLabel: 'Đi tới KYC',
            onTap: () => context.go(snapshot.kycRoute),
          ),
          const SizedBox(height: AppSpacing.x4),
          _ReferenceTile(
            icon: Icons.key_rounded,
            title: '2FA Gate Panel',
            subtitle: 'Bật 2FA để tiếp tục',
            actionLabel: 'Thiết lập 2FA',
            onTap: () => context.go(snapshot.securityRoute),
          ),
        ],
      ),
    );
  }
}

class _ReferenceTile extends StatelessWidget {
  const _ReferenceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actionLabel,
    this.actionKey,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String actionLabel;
  final Key? actionKey;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _IconBubble(icon: icon, color: AppColors.primary),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          VitStatusPill(
            key: actionKey,
            label: actionLabel,
            status: onTap == null
                ? VitStatusPillStatus.neutral
                : VitStatusPillStatus.orange,
            size: VitStatusPillSize.md,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _IconBubble extends StatelessWidget {
  const _IconBubble({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.inputHeight,
      height: AppSpacing.inputHeight,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconMd),
    );
  }
}

String _previewLabel(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return 'Loading';
    case EnterprisePreviewState.empty:
      return 'Empty';
    case EnterprisePreviewState.error:
      return 'Error';
    case EnterprisePreviewState.offline:
      return 'Offline';
    case EnterprisePreviewState.gate:
      return 'Gate';
  }
}

IconData _previewIcon(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return Icons.hourglass_top_rounded;
    case EnterprisePreviewState.empty:
      return Icons.inbox_outlined;
    case EnterprisePreviewState.error:
      return Icons.close_rounded;
    case EnterprisePreviewState.offline:
      return Icons.wifi_off_rounded;
    case EnterprisePreviewState.gate:
      return Icons.lock_outline_rounded;
  }
}

VitStatusPillStatus _pillStatus(EnterprisePreviewState state) {
  switch (state) {
    case EnterprisePreviewState.loading:
      return VitStatusPillStatus.info;
    case EnterprisePreviewState.empty:
      return VitStatusPillStatus.neutral;
    case EnterprisePreviewState.error:
      return VitStatusPillStatus.error;
    case EnterprisePreviewState.offline:
      return VitStatusPillStatus.warning;
    case EnterprisePreviewState.gate:
      return VitStatusPillStatus.purple;
  }
}

Color _bannerColor(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return AppColors.primary;
    case EnterpriseBannerKind.warning:
      return AppColors.warn;
    case EnterpriseBannerKind.error:
      return AppColors.sell;
  }
}

IconData _bannerIcon(EnterpriseBannerKind kind) {
  switch (kind) {
    case EnterpriseBannerKind.info:
      return Icons.bar_chart_rounded;
    case EnterpriseBannerKind.warning:
      return Icons.warning_amber_rounded;
    case EnterpriseBannerKind.error:
      return Icons.report_problem_outlined;
  }
}
