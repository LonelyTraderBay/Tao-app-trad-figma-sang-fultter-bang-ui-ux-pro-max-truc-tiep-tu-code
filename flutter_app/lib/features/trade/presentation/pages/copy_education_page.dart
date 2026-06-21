import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

part '../widgets/copy_education_page_sections.dart';
part '../widgets/copy_education_page_common.dart';

const _copyPrimary = AppColors.primary;

class CopyEducationPage extends ConsumerStatefulWidget {
  const CopyEducationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc065_copy_education_scroll_content');
  static const providerCtaKey = Key('sc065_provider_cta');
  static Key tabKey(String id) => Key('sc065_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CopyEducationPage> createState() => _CopyEducationPageState();
}

class _CopyEducationPageState extends ConsumerState<CopyEducationPage> {
  late String _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = 'how-it-works';
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getCopyEducation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final chromeReserve = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final scrollTailReserve =
        chromeReserve +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? AppSpacing.x6 : AppSpacing.x3);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-065 CopyEducationPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Hướng dẫn Copy Trading',
            showBack: true,
            onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  key: CopyEducationPage.contentKey,
                  padding: AppSpacing.zeroInsets.copyWith(
                    left: AppSpacing.contentPad,
                    top: AppSpacing.x4,
                    right: AppSpacing.contentPad,
                    bottom: scrollTailReserve,
                  ),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    gap: VitContentGap.tight,
                    fullBleed: true,
                    children: [
                      _IntroBanner(snapshot: snapshot),
                      const VitHighRiskStatePanel(
                        state: VitHighRiskUiState.riskReview,
                        title: 'Review copy trading education',
                        message:
                            'Understand fees, drawdown, slippage, provider risk, and copy modes before copying a provider.',
                        contractId: 'Education module: copy trading',
                      ),
                      _EducationTabs(
                        tabs: snapshot.tabs,
                        active: _activeTab,
                        onChanged: (value) =>
                            setState(() => _activeTab = value),
                      ),
                      if (_activeTab == 'how-it-works')
                        _HowItWorksContent(snapshot: snapshot)
                      else
                        _SupplementalTabContent(activeTab: _activeTab),
                      _ProviderCta(
                        onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
                      ),
                    ],
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
