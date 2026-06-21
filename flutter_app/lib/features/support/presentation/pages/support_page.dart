import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/support_controller_providers.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/core/product_flow/contextual_support_contract.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

part '../widgets/support_quick_contacts_tabs.dart';
part '../widgets/support_context_card.dart';
part '../widgets/support_tickets.dart';
part '../widgets/support_faq_common.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key, this.shellRenderMode, this.supportContext});

  static const contentKey = Key('sc294_support_content');
  static const contextKey = Key('sc294_support_context');
  static const quickLinksKey = Key('sc294_support_quick_links');
  static const ticketsTabKey = Key('sc294_support_tickets_tab');
  static const faqTabKey = Key('sc294_support_faq_tab');
  static const createTicketKey = Key('sc294_support_create_ticket');
  static const activeTicketsKey = Key('sc294_support_active_tickets');
  static const doneTicketsKey = Key('sc294_support_done_tickets');

  static Key quickLinkKey(String id) => Key('sc294_support_quick_$id');
  static Key ticketKey(String id) => Key('sc294_support_ticket_$id');
  static Key faqKey(int index) => Key('sc294_support_faq_$index');

  final ShellRenderMode? shellRenderMode;
  final ProductSupportContext? supportContext;

  @override
  ConsumerState<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends ConsumerState<SupportPage> {
  bool _showFaq = false;
  int? _expandedFaqIndex;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(supportControllerProvider).getSupportHub();
    final activeTickets = snapshot.tickets
        .where(
          (ticket) =>
              ticket.status == SupportTicketStatus.open ||
              ticket.status == SupportTicketStatus.inProgress,
        )
        .toList();
    final doneTickets = snapshot.tickets
        .where(
          (ticket) =>
              ticket.status == SupportTicketStatus.resolved ||
              ticket.status == SupportTicketStatus.closed,
        )
        .toList();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final scrollEndClearance =
        (mode.usesVisualQaFrame
            ? AppSpacing.x7 + AppSpacing.x6
            : AppSpacing.x7) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-294 SupportPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(
              widget.supportContext?.sourceRoute ?? snapshot.backRoute,
            ),
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
                    key: SupportPage.contentKey,
                    physics: const ClampingScrollPhysics(),
                    padding: AppSpacing.supportScrollPadding(
                      scrollEndClearance,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.none,
                      fullBleed: true,
                      gap: VitContentGap.tight,
                      children: [
                        if (widget.supportContext != null)
                          Padding(
                            padding: AppSpacing.supportContentPadding,
                            child: _SupportContextCard(
                              supportContext: widget.supportContext!,
                            ),
                          ),
                        _QuickContactGrid(snapshot: snapshot),
                        Padding(
                          padding: AppSpacing.supportContentPadding,
                          child: _SupportTabs(
                            ticketCount: snapshot.tickets.length,
                            showFaq: _showFaq,
                            onShowTickets: () => _setFaq(false),
                            onShowFaq: () => _setFaq(true),
                          ),
                        ),
                        Padding(
                          padding: AppSpacing.supportContentPadding,
                          child: _showFaq
                              ? _FaqPanel(
                                  items: snapshot.faqItems,
                                  expandedIndex: _expandedFaqIndex,
                                  onToggle: _toggleFaq,
                                )
                              : _TicketsPanel(
                                  activeTickets: activeTickets,
                                  doneTickets: doneTickets,
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

  void _setFaq(bool value) {
    HapticFeedback.selectionClick();
    setState(() {
      _showFaq = value;
      _expandedFaqIndex = null;
    });
  }

  void _toggleFaq(int index) {
    HapticFeedback.selectionClick();
    setState(() {
      _expandedFaqIndex = _expandedFaqIndex == index ? null : index;
    });
  }
}
