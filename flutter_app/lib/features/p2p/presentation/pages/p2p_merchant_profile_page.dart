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
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../widgets/p2p_merchant_profile_header_stats.dart';
part '../widgets/p2p_merchant_profile_ads_reviews.dart';

const double _p2pMerchantSectionGap = AppSpacing.x3;
const double _p2pMerchantTightGap = AppSpacing.x2;
const double _p2pMerchantButtonHeight =
    AppSpacing.buttonCompact + AppSpacing.x1;
const double _p2pMerchantActionHeight = AppSpacing.buttonCompact;
const double _p2pMerchantBodyLineHeight =
    P2PSpacingTokens.p2pMerchantCommerceBodyLineHeight;

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

    return VitP2PFlowScaffold(
      title: 'Hồ sơ Merchant',
      subtitle: 'Merchant · P2P',
      semanticLabel: 'SC-228 P2PMerchantProfilePage',
      contentKey: P2PMerchantProfilePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      onBack: () => context.go(AppRoutePaths.p2p),
      children: [
        _ProfileHeader(
          snapshot: snapshot,
          following: _following,
          onFollow: _toggleFollow,
          onReport: () => context.go(snapshot.reportRoute),
          onBlock: () => _confirmBlock(context, snapshot),
        ),
        _StatsGrid(merchant: snapshot.merchant),
        _ReputationCard(snapshot: snapshot),
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
              widgetKey: P2PMerchantProfilePage.reviewsTabKey,
            ),
          ],
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: _tab == _MerchantProfileTab.ads
              ? _AdsList(snapshot: snapshot)
              : _ReviewsList(snapshot: snapshot),
        ),
      ],
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
              padding: P2PSpacingTokens.p2pMerchantCommerceDialogButtonPadding,
              child: const Text('Hủy'),
            ),
            VitCtaButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              variant: VitCtaButtonVariant.warning,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pMerchantCommerceDialogButtonPadding,
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
