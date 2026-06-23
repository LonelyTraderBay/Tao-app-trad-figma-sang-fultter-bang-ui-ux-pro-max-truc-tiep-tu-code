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
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_notice_widgets.dart';

part '../widgets/p2p_escrow_detail_status_address.dart';
part '../widgets/p2p_escrow_detail_multisig_order.dart';
part '../widgets/p2p_escrow_detail_timeline_actions.dart';

const double _p2pEscrowVisualNavClearance =
    DeviceMetrics.safeBottom + DeviceMetrics.tabBar;
const double _p2pEscrowNativeNavClearance =
    _p2pEscrowVisualNavClearance - AppSpacing.x4;
const double _p2pEscrowVisualClearance = AppSpacing.x3;
const double _p2pEscrowNativeClearance = AppSpacing.x2;
const double _p2pEscrowSectionGap = AppSpacing.x3;
const double _p2pEscrowTightGap = AppSpacing.x2;
const double _p2pEscrowRingSize = AppSpacing.buttonCompact + AppSpacing.x2;
const double _p2pEscrowTimelineConnectorHeight = AppSpacing.x4;
const double _p2pEscrowBodyLineHeight = 1.35;
const EdgeInsets _p2pEscrowScrollPadding = EdgeInsets.fromLTRB(
  AppSpacing.contentPad,
  AppSpacing.x3,
  AppSpacing.contentPad,
  0,
);
const EdgeInsets _p2pEscrowHeroPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _p2pEscrowCardPadding = EdgeInsets.all(AppSpacing.x3);
const EdgeInsets _p2pEscrowInnerPadding = EdgeInsets.all(AppSpacing.x2);
const EdgeInsets _p2pEscrowExplorerPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.x3,
  vertical: AppSpacing.x2,
);
const EdgeInsets _p2pEscrowTimelineRowPadding = EdgeInsets.only(
  bottom: AppSpacing.x2,
);

class P2PEscrowDetailPage extends ConsumerStatefulWidget {
  const P2PEscrowDetailPage({
    super.key,
    required this.orderId,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc246_p2p_escrow_detail_hero');
  static const addressKey = Key('sc246_p2p_escrow_detail_address');
  static const copyKey = Key('sc246_p2p_escrow_detail_copy');
  static const revealKey = Key('sc246_p2p_escrow_detail_reveal');
  static const explorerKey = Key('sc246_p2p_escrow_detail_explorer');
  static const multisigKey = Key('sc246_p2p_escrow_detail_multisig');
  static const orderInfoKey = Key('sc246_p2p_escrow_detail_order_info');
  static const timelineKey = Key('sc246_p2p_escrow_detail_timeline');
  static const securityKey = Key('sc246_p2p_escrow_detail_security');
  static const orderLinkKey = Key('sc246_p2p_escrow_detail_order_link');
  static const feedbackKey = Key('sc246_p2p_escrow_detail_feedback');

  final String orderId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PEscrowDetailPage> createState() =>
      _P2PEscrowDetailPageState();
}

class _P2PEscrowDetailPageState extends ConsumerState<P2PEscrowDetailPage> {
  bool _showFullAddress = false;
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pEscrowDetailProvider(widget.orderId));
    final order = snapshot.order;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndPadding =
        (mode.usesVisualQaFrame
            ? _p2pEscrowVisualNavClearance + _p2pEscrowVisualClearance
            : _p2pEscrowNativeNavClearance + _p2pEscrowNativeClearance) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-246 P2PEscrowDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết Escrow',
            subtitle: 'Escrow · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                    physics: const ClampingScrollPhysics(),
                    padding: _p2pEscrowScrollPadding.copyWith(
                      bottom: scrollEndPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _EscrowStatusHero(snapshot: snapshot),
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _EscrowAddressCard(
                          snapshot: snapshot,
                          showFullAddress: _showFullAddress,
                          onReveal: () {
                            HapticFeedback.selectionClick();
                            setState(
                              () => _showFullAddress = !_showFullAddress,
                            );
                          },
                          onCopy: () {
                            HapticFeedback.selectionClick();
                            Clipboard.setData(
                              ClipboardData(text: snapshot.escrowAddress),
                            );
                            setState(
                              () => _feedback = 'Đã copy địa chỉ escrow',
                            );
                          },
                          onExplorer: () {
                            HapticFeedback.selectionClick();
                            setState(
                              () => _feedback = 'Đã mở Blockchain Explorer',
                            );
                          },
                        ),
                        if (_feedback != null) ...[
                          const SizedBox(height: _p2pEscrowTightGap),
                          _FeedbackBanner(message: _feedback!),
                        ],
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _MultiSigCard(snapshot: snapshot),
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _OrderInfoCard(order: order),
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _EscrowTimelineCard(events: snapshot.timeline),
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _SecurityNotice(snapshot: snapshot),
                        const SizedBox(height: _p2pEscrowSectionGap),
                        _OrderLink(orderId: widget.orderId),
                        const SizedBox(height: _p2pEscrowTightGap),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: _p2pEscrowInnerPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Escrow detail review',
                            message:
                                'Masked escrow address, reveal/copy action, multisig state, order link, timeline and next safe step are reviewed before fund action.',
                            contractId: 'p2p-escrow-detail-review',
                          ),
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
}
