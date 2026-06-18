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

part '../widgets/p2p_ad_detail_merchant_info.dart';
part '../widgets/p2p_ad_detail_amount_terms.dart';

class P2PAdDetailPage extends ConsumerStatefulWidget {
  const P2PAdDetailPage({super.key, required this.adId, this.shellRenderMode});

  static const contentKey = Key('sc224_p2p_ad_detail_content');
  static const buyButtonKey = Key('sc224_p2p_ad_detail_buy');
  static Key percentKey(int percent) => Key('sc224_percent_$percent');

  final String adId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PAdDetailPage> createState() => _P2PAdDetailPageState();
}

class _P2PAdDetailPageState extends ConsumerState<P2PAdDetailPage> {
  int? _selectedPercent;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pAdDetailProvider(widget.adId));
    final ad = snapshot.ad;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x4
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x3) +
        MediaQuery.paddingOf(context).bottom;
    final footerInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome
            : DeviceMetrics.nativeBottomChrome) +
        MediaQuery.paddingOf(context).bottom;
    final fiatAmount = _selectedPercent == null
        ? 0
        : (ad.maxLimit * _selectedPercent! / 100).round();
    final cryptoAmount = fiatAmount == 0 ? 0.0 : fiatAmount / ad.price;
    final isValid =
        fiatAmount >= ad.minLimit &&
        fiatAmount <= ad.maxLimit &&
        cryptoAmount <= snapshot.availableAmount;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-224 P2PAdDetailPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Chi tiết quảng cáo',
            subtitle: 'Quảng cáo · P2P',
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
                    key: P2PAdDetailPage.contentKey,
                    physics: const BouncingScrollPhysics(),
                    padding: AppSpacing.p2pAdDetailScrollPadding(bottomInset),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      customGap: AppSpacing.x4,
                      children: [
                        _MerchantCard(snapshot: snapshot),
                        _TrustMarketRow(snapshot: snapshot),
                        _SignalChips(snapshot: snapshot),
                        _PriceCard(snapshot: snapshot),
                        _AmountCard(
                          snapshot: snapshot,
                          selectedPercent: _selectedPercent,
                          fiatAmount: fiatAmount,
                          cryptoAmount: cryptoAmount,
                          onPercent: (percent) {
                            HapticFeedback.selectionClick();
                            setState(() => _selectedPercent = percent);
                          },
                        ),
                        _RequirementCard(snapshot: snapshot),
                        _TermsCard(snapshot: snapshot),
                        _EscrowCard(snapshot: snapshot, amount: cryptoAmount),
                        const VitCard(
                          variant: VitCardVariant.inner,
                          padding: AppSpacing.p2pAdDetailCompactCardPadding,
                          child: VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'P2P order preview review',
                            message:
                                'Merchant trust, limit, available amount, payment terms, escrow protection and next order step are reviewed before the buy action.',
                            contractId: 'p2p-ad-detail-order-review',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              VitStickyFooter(
                backgroundColor: AppColors.surface.withValues(alpha: .96),
                child: Padding(
                  padding: AppSpacing.p2pAdDetailFooterPadding(footerInset),
                  child: VitCtaButton(
                    key: P2PAdDetailPage.buyButtonKey,
                    onPressed: isValid
                        ? () => context.go(
                            AppRoutePaths.p2pOrder(snapshot.targetOrderId),
                          )
                        : null,
                    variant: VitCtaButtonVariant.success,
                    child: Text('Mua ${ad.asset}'),
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
