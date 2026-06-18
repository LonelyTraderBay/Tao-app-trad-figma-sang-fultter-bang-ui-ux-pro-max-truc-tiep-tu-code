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
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';
import 'package:vit_trade_flutter/features/p2p/presentation/widgets/p2p_notice_widgets.dart';

part '../widgets/p2p_escrow_detail_status_address.dart';
part '../widgets/p2p_escrow_detail_multisig_order.dart';
part '../widgets/p2p_escrow_detail_timeline_actions.dart';

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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
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
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.p2pEscrowDetailScrollPadding(
                      bottomInset,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: 0,
                      children: [
                        _EscrowStatusHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
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
                          const SizedBox(height: AppSpacing.x3),
                          _FeedbackBanner(message: _feedback!),
                        ],
                        const SizedBox(height: AppSpacing.x4),
                        _MultiSigCard(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _OrderInfoCard(order: order),
                        const SizedBox(height: AppSpacing.x4),
                        _EscrowTimelineCard(events: snapshot.timeline),
                        const SizedBox(height: AppSpacing.x4),
                        _SecurityNotice(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _OrderLink(orderId: widget.orderId),
                        const SizedBox(height: AppSpacing.x3),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: AppSpacing.p2pEscrowDetailInnerPadding,
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
