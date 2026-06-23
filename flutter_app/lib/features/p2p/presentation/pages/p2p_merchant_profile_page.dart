import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

part '../widgets/p2p_merchant_profile_header_stats.dart';
part '../widgets/p2p_merchant_profile_ads_reviews.dart';

const double _p2pMerchantVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pMerchantNativeNavClearance =
    _p2pMerchantVisualNavClearance - AppSpacing.x4;
const double _p2pMerchantVisualClearance = AppSpacing.x3;
const double _p2pMerchantNativeClearance = AppSpacing.x2;
const double _p2pMerchantSectionGap = AppSpacing.x3;
const double _p2pMerchantTightGap = AppSpacing.x2;
const double _p2pMerchantButtonHeight =
    AppSpacing.buttonCompact + AppSpacing.x1;
const double _p2pMerchantActionHeight = AppSpacing.buttonCompact;
const double _p2pMerchantBodyLineHeight = 1.35;
const EdgeInsets _p2pMerchantScrollPadding = EdgeInsets.fromLTRB(
  AppSpacing.contentPad,
  AppSpacing.x3,
  AppSpacing.contentPad,
  0,
);
const EdgeInsets _p2pMerchantCardPadding = EdgeInsets.all(AppSpacing.x3);

enum _MerchantProfileTab { ads, reviews }

class P2PMerchantProfilePage extends ConsumerStatefulWidget {
  const P2PMerchantProfilePage({
    super.key,
    required this.merchantId,
    this.shellRenderMode,
  });

  static const contentKey = Key('sc228_p2p_merchant_profile_content');
  static const followButtonKey = Key('sc228_p2p_merchant_follow');
  static const reportButtonKey = Key('sc228_p2p_merchant_report');
  static const blockButtonKey = Key('sc228_p2p_merchant_block');
  static const reviewsTabKey = Key('sc228_p2p_merchant_reviews_tab');

  static Key adKey(String adId) => Key('sc228_p2p_merchant_ad_$adId');

  final String merchantId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMerchantProfilePage> createState() =>
      _P2PMerchantProfilePageState();
}

class _P2PMerchantProfilePageState
    extends ConsumerState<P2PMerchantProfilePage> {
  _MerchantProfileTab _tab = _MerchantProfileTab.ads;
  bool _following = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pMerchantProfileProvider(widget.merchantId));
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pMerchantVisualNavClearance + _p2pMerchantVisualClearance
            : _p2pMerchantNativeNavClearance + _p2pMerchantNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-228 P2PMerchantProfilePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hồ sơ Merchant',
            subtitle: 'Merchant · P2P',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.p2p),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    key: P2PMerchantProfilePage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: _p2pMerchantScrollPadding.copyWith(
                      bottom: scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _ProfileHeader(
                          snapshot: snapshot,
                          following: _following,
                          onFollow: _toggleFollow,
                          onReport: () => context.go(snapshot.reportRoute),
                          onBlock: () => _confirmBlock(context, snapshot),
                        ),
                        const SizedBox(height: _p2pMerchantSectionGap),
                        _StatsGrid(merchant: snapshot.merchant),
                        const SizedBox(height: _p2pMerchantSectionGap),
                        _ReputationCard(snapshot: snapshot),
                        const SizedBox(height: _p2pMerchantSectionGap),
                        VitTabBar(
                          variant: VitTabBarVariant.segment,
                          activeKey: _tab.name,
                          onChanged: (key) {
                            HapticFeedback.selectionClick();
                            setState(() => _tab = _tabFromKey(key));
                          },
                          tabs: [
                            VitTabItem(
                              key: _MerchantProfileTab.ads.name,
                              label: 'Quảng cáo (${snapshot.ads.length})',
                            ),
                            VitTabItem(
                              key: _MerchantProfileTab.reviews.name,
                              label: 'Đánh giá (${snapshot.reviews.length})',
                            ),
                          ],
                        ),
                        const SizedBox(height: _p2pMerchantTightGap),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 180),
                          child: _tab == _MerchantProfileTab.ads
                              ? _AdsList(snapshot: snapshot)
                              : _ReviewsList(snapshot: snapshot),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _MerchantProfileTab _tabFromKey(String key) {
    return _MerchantProfileTab.values.firstWhere(
      (tab) => tab.name == key,
      orElse: () => _MerchantProfileTab.ads,
    );
  }

  void _toggleFollow() {
    HapticFeedback.selectionClick();
    setState(() => _following = !_following);
  }

  Future<void> _confirmBlock(
    BuildContext context,
    P2PMerchantProfileSnapshot snapshot,
  ) async {
    HapticFeedback.lightImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Chặn ${snapshot.merchant.name}?',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Text(
            'Bạn sẽ không thể giao dịch với người này. Có thể bỏ chặn trong danh sách chặn.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          actions: [
            VitCtaButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              variant: VitCtaButtonVariant.secondary,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: const Text('Hủy'),
            ),
            VitCtaButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              variant: VitCtaButtonVariant.warning,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
              child: const Text('Chặn'),
            ),
          ],
        );
      },
    );

    if (!context.mounted || confirmed != true) return;
    HapticFeedback.mediumImpact();
    context.go(snapshot.blacklistAddRoute);
  }
}
