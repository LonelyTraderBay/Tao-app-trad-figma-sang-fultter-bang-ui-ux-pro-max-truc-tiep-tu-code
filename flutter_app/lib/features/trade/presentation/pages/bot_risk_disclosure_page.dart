import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';
import 'package:vit_trade_flutter/features/trade/presentation/widgets/trade_module_layout.dart';

part '../widgets/bot_risk_disclosure_page_sections.dart';
part '../widgets/bot_risk_disclosure_page_common.dart';

const _botRiskRed = AppColors.sell;
const _botRiskAmber = AppColors.caution;
const _botRiskPurple = AppColors.accent;
const _botRiskPrimary = AppColors.primary;
const _botRiskGreen = AppColors.buy;
const _riskSpace = AppSpacing.x2;
const _riskTinySpace = AppSpacing.x1;
const _riskIconTile = 34.0;
const _riskActionHeight = 44.0;
const _riskLineTight = 1.2;

class BotRiskDisclosurePage extends ConsumerStatefulWidget {
  const BotRiskDisclosurePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc118_bot_risk_content');
  static const acknowledgmentKey = Key('sc118_bot_risk_acknowledgment');
  static const ctaKey = Key('sc118_bot_risk_cta');
  static Key categoryKey(String id) => Key('sc118_bot_risk_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotRiskDisclosurePage> createState() =>
      _BotRiskDisclosurePageState();
}

class _BotRiskDisclosurePageState extends ConsumerState<BotRiskDisclosurePage> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotRiskDisclosure();
    return VitTradeHubScaffold(
      title: 'Risk Disclosure',
      subtitle: 'Công bố rủi ro trước khi dùng bot',
      semanticLabel: 'SC-118 BotRiskDisclosurePage',
      contentKey: BotRiskDisclosurePage.contentKey,
      shellRenderMode: widget.shellRenderMode,
      activeProductId: 'bots',
      onBack: () => context.go(AppRoutePaths.tradeBots),
      children: [
        VitBotSubpageHero(
          primaryLabel: 'Nhóm rủi ro',
          primaryValue: '${snapshot.categories.length}',
          secondaryLabel: 'Xác nhận',
          secondaryValue: _acknowledged ? 'Đã đọc' : 'Chưa đọc',
          secondaryColor: _acknowledged ? _botRiskGreen : _botRiskAmber,
        ),
        VitTradeSection(
          title: 'High risk notice',
          child: _HighRiskBanner(snapshot: snapshot),
        ),
        VitTradeSection(
          title: 'Past performance',
          child: _PastPerformanceCard(snapshot: snapshot),
        ),
        VitTradeSection(
          title: snapshot.riskSectionLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final category in snapshot.categories)
                _RiskCategoryCard(category: category),
            ],
          ),
        ),
        VitTradeSection(
          title: snapshot.additionalWarningsLabel,
          child: _AdditionalWarningsCard(warnings: snapshot.additionalWarnings),
        ),
        VitTradeSection(
          title: snapshot.regulatoryNoticeLabel,
          child: _RegulatoryNoticeCard(snapshot: snapshot),
        ),
        VitTradeSection(
          title: snapshot.acknowledgmentLabel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _AcknowledgmentCard(
                snapshot: snapshot,
                acknowledged: _acknowledged,
                onTap: () => setState(() => _acknowledged = !_acknowledged),
              ),
              _RiskCta(
                snapshot: snapshot,
                acknowledged: _acknowledged,
                onPressed: () => context.go(snapshot.nextPath),
              ),
            ],
          ),
        ),
        VitTradeSection(
          title: 'Help',
          child: _HelpCard(snapshot: snapshot),
        ),
        const VitBotRiskReviewFooter(
          title: 'Bot risk disclosure review',
          message:
              'Past performance, category risks, regulatory notice, acknowledgment and next steps are reviewed before bot access.',
          contractId: 'bot-risk-disclosure-review',
          statusLabel: 'Acknowledgment required',
          status: VitStatusPillStatus.error,
        ),
      ],
    );
  }
}
