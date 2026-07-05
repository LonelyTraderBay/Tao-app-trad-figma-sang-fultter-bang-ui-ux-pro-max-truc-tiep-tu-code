import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/launchpad_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/launchpad_receipt_states_success.dart';
part '../widgets/launchpad_receipt_details_next_steps.dart';

const double _launchpadReceiptVisualNavClearance = 112;
const double _launchpadReceiptNativeNavClearance = 88;

class LaunchpadReceiptPage extends ConsumerWidget {
  const LaunchpadReceiptPage({
    super.key,
    this.subscriptionId = 'sub001',
    this.shellRenderMode,
  });

  static const contentKey = Key('sc301_launchpad_receipt_content');
  static const errorKey = Key('sc301_launchpad_receipt_error');
  static const portfolioButtonKey = Key('sc301_launchpad_receipt_portfolio');
  static const launchpadButtonKey = Key('sc301_launchpad_receipt_launchpad');

  final String subscriptionId;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref
        .watch(launchpadControllerProvider)
        .getReceipt(subscriptionId);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final navClearance = mode.usesVisualQaFrame
        ? _launchpadReceiptVisualNavClearance
        : _launchpadReceiptNativeNavClearance;
    final scrollEndPadding =
        navClearance + MediaQuery.paddingOf(context).bottom;
    final hasSubscription = snapshot.subscription != null;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-301 LaunchpadReceiptPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          semanticLabel: 'SC-301 LaunchpadReceiptPage scroll surface',
          header: VitHeader(
            title: hasSubscription ? 'Biên lai đăng ký' : snapshot.title,
            subtitle: hasSubscription ? 'Xác nhận tham gia IDO' : null,
            showBack: true,
            onBack: () => context.go(snapshot.backRoute),
          ),
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(
              context,
            ).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              key: contentKey,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsetsDirectional.only(bottom: scrollEndPadding),
              child: VitPageContent(
                padding: VitContentPadding.compact,
                density: VitDensity.compact,
                children: [
                if (!hasSubscription)
                  const _ReceiptErrorState()
                else
                  _ReceiptSuccess(snapshot: snapshot),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
