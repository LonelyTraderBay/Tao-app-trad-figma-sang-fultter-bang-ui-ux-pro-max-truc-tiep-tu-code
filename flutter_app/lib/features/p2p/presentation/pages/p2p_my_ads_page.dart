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
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/vit_p2p_flow_scaffold.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/spacing/p2p_spacing_tokens.dart';

part '../widgets/p2p_my_ads_stats_cards.dart';
part '../widgets/p2p_my_ads_empty_links.dart';

enum _MyAdsFilter { all, active, paused }

const double _p2pMyAdsVisualClearance = AppSpacing.x3;
const double _p2pMyAdsNativeClearance = AppSpacing.x2;
const double _p2pMyAdsMajorGap = AppSpacing.x3;
const double _p2pMyAdsSectionGap = AppSpacing.x2;
const double _p2pMyAdsTightGap = AppSpacing.x1;
const double _p2pMyAdsStatExtent = AppSpacing.x7 + AppSpacing.x3;
const double _p2pMyAdsActionExtent = AppSpacing.searchBarCompactHeight;
const double _p2pMyAdsQuickIconBox = AppSpacing.searchBarCompactHeight;

class P2PMyAdsPage extends ConsumerStatefulWidget {
  const P2PMyAdsPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc225_p2p_my_ads_content');
  static const createButtonKey = Key('sc225_p2p_my_ads_create');
  static Key analyticsKey(String adId) => Key('sc225_analytics_$adId');
  static Key toggleKey(String adId) => Key('sc225_toggle_$adId');
  static Key editKey(String adId) => Key('sc225_edit_$adId');
  static Key deleteKey(String adId) => Key('sc225_delete_$adId');
  static Key quickLinkKey(String id) => Key('sc225_quick_$id');
  static Key adMenuKey(String adId) => Key('sc225_menu_$adId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PMyAdsPage> createState() => _P2PMyAdsPageState();
}

class _P2PMyAdsPageState extends ConsumerState<P2PMyAdsPage> {
  _MyAdsFilter _filter = _MyAdsFilter.all;
  final Map<String, P2PMyAdStatus> _statusOverrides = {};
  final Set<String> _deletedAds = {};

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pMyAdsProvider);
    final ads = _resolveAds(snapshot.ads);
    final activeCount = ads
        .where((ad) => ad.status == P2PMyAdStatus.active)
        .length;
    final pausedCount = ads
        .where((ad) => ad.status == P2PMyAdStatus.paused)
        .length;
    final totalVolume = ads.fold<int>(
      0,
      (sum, ad) => sum + ad.totalVolume30dUsd,
    );
    final filtered = ads
        .where((ad) {
          return switch (_filter) {
            _MyAdsFilter.all => true,
            _MyAdsFilter.active => ad.status == P2PMyAdStatus.active,
            _MyAdsFilter.paused => ad.status == P2PMyAdStatus.paused,
          };
        })
        .toList(growable: false);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + _p2pMyAdsVisualClearance
            : DeviceMetrics.nativeBottomChrome + _p2pMyAdsNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitP2PFlowScaffold(
      semanticLabel: 'SC-225 P2PMyAdsPage',
      title: 'Quảng cáo của tôi',
      subtitle: 'Quảng cáo · P2P',
      onBack: () => context.go(AppRoutePaths.p2p),
      contentKey: P2PMyAdsPage.contentKey,
      shellRenderMode: mode,
      bottomInset: scrollEndPadding,
      headerActions: [
        VitHeaderActionItem(
          key: P2PMyAdsPage.createButtonKey,
          type: VitHeaderActionType.add,
          tooltip: 'Tạo quảng cáo',
          onPressed: () => context.go(AppRoutePaths.p2pCreate),
        ),
      ],
      children: [
        _StatsRow(
          activeCount: activeCount,
          pausedCount: pausedCount,
          totalVolume: totalVolume,
        ),
        VitTabBar(
          variant: VitTabBarVariant.segment,
          activeKey: _filter.name,
          onChanged: (key) {
            HapticFeedback.selectionClick();
            setState(() => _filter = _filterFromKey(key));
          },
          tabs: [
            VitTabItem(
              key: _MyAdsFilter.all.name,
              label: 'Tất cả (${ads.length})',
            ),
            VitTabItem(
              key: _MyAdsFilter.active.name,
              label: 'Hoạt động ($activeCount)',
            ),
            VitTabItem(
              key: _MyAdsFilter.paused.name,
              label: 'Tạm dừng ($pausedCount)',
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (filtered.isEmpty)
              _EmptyMyAds(snapshot: snapshot)
            else
              for (var index = 0; index < filtered.length; index++) ...[
                if (index > 0) const SizedBox(height: AppSpacing.rowGap),
                _MyAdCard(
                  ad: filtered[index],
                  onAnalytics: () =>
                      context.go(AppRoutePaths.p2pAdAnalytics('sample')),
                  onToggle: () => _toggleStatus(filtered[index]),
                  onEdit: () => context.go(AppRoutePaths.p2pCreate),
                  onDelete: () => _confirmDelete(context, filtered[index]),
                ),
              ],
          ],
        ),
        _QuickLinksCard(links: snapshot.quickLinks),
        const VitHighRiskStatePanel(
          state: VitHighRiskUiState.riskReview,
          title: 'My ads state review',
          message:
              'Ad status, pause/delete state, analytics links, empty state, and active order impact stay visible before changing P2P advertisement exposure.',
          contractId: 'SC-225',
        ),
      ],
    );
  }

  List<P2PMyAdDraft> _resolveAds(List<P2PMyAdDraft> ads) {
    return [
      for (final ad in ads)
        if (!_deletedAds.contains(ad.id))
          ad.copyWith(status: _statusOverrides[ad.id]),
    ];
  }

  void _toggleStatus(P2PMyAdDraft ad) {
    HapticFeedback.selectionClick();
    final nextStatus = ad.status == P2PMyAdStatus.active
        ? P2PMyAdStatus.paused
        : P2PMyAdStatus.active;
    setState(() => _statusOverrides[ad.id] = nextStatus);
  }

  Future<void> _confirmDelete(BuildContext context, P2PMyAdDraft ad) async {
    HapticFeedback.lightImpact();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          surfaceTintColor: AppColors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
          title: Text(
            'Xóa quảng cáo này?',
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
          ),
          content: Text(
            'Quảng cáo sẽ bị xóa vĩnh viễn. Các đơn hàng đang xử lý sẽ không bị ảnh hưởng.',
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
              variant: VitCtaButtonVariant.danger,
              fullWidth: false,
              height: AppSpacing.buttonCompact,
              padding: P2PSpacingTokens.p2pMerchantCommerceDialogButtonPadding,
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _deletedAds.add(ad.id);
      _statusOverrides.remove(ad.id);
    });
  }
}
