import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

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

    return VitTradeHubScaffold(
      title: 'Hướng dẫn Copy Trading',
      semanticLabel: 'SC-065 CopyEducationPage',
      contentKey: CopyEducationPage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      useCopyTradingInset: true,
      onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
      children: [
        VitTradeSection(
          title: 'Giới thiệu',
          child: _IntroBanner(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Đánh giá rủi ro',
          child: const VitHighRiskStatePanel(
            state: VitHighRiskUiState.riskReview,
            title: 'Review copy trading education',
            message:
                'Understand fees, drawdown, slippage, provider risk, and copy modes before copying a provider.',
            contractId: 'Education module: copy trading',
          ),
        ),
        VitTradeSection(
          title: 'Chủ đề',
          child: _EducationTabs(
            tabs: snapshot.tabs,
            active: _activeTab,
            onChanged: (value) => setState(() => _activeTab = value),
          ),
        ),
        VitTradeSection(
          title: _activeTab == 'how-it-works' ? 'Cách hoạt động' : 'Nội dung',
          child: _activeTab == 'how-it-works'
              ? _HowItWorksContent(snapshot: snapshot)
              : _SupplementalTabContent(activeTab: _activeTab),
        ),
        VitTradeSection(
          title: 'Tiếp theo',
          child: _ProviderCta(
            onTap: () => context.go(AppRoutePaths.tradeCopyTrading),
          ),
        ),
      ],
    );
  }
}
