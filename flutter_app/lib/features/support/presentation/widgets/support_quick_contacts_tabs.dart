part of '../pages/support_page.dart';

class _SupportHubBody extends StatelessWidget {
  const _SupportHubBody({
    required this.snapshot,
    required this.supportContext,
    required this.showFaq,
    required this.expandedFaqIndex,
    required this.activeTickets,
    required this.doneTickets,
    required this.onShowTickets,
    required this.onShowFaq,
    required this.onToggleFaq,
    required this.onRetry,
  });

  final SupportHubSnapshot snapshot;
  final ProductSupportContext? supportContext;
  final bool showFaq;
  final int? expandedFaqIndex;
  final List<SupportTicketDraft> activeTickets;
  final List<SupportTicketDraft> doneTickets;
  final VoidCallback onShowTickets;
  final VoidCallback onShowFaq;
  final ValueChanged<int> onToggleFaq;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return switch (snapshot.screenState) {
      SupportScreenState.loading => const VitSkeletonList(
        key: SupportPage.loadingKey,
        rows: 4,
      ),
      SupportScreenState.error => VitErrorState(
        key: SupportPage.errorKey,
        title: 'Không tải được hub hỗ trợ',
        message: 'Kiểm tra kết nối và thử lại.',
        actionLabel: 'Thử lại',
        onAction: onRetry,
      ),
      SupportScreenState.empty ||
      SupportScreenState.offline when snapshot.tickets.isEmpty &&
          snapshot.faqItems.isEmpty =>
        const VitEmptyState(
          title: 'Chưa có nội dung hỗ trợ',
          message: 'Ticket và FAQ sẽ hiển thị tại đây khi có dữ liệu.',
          icon: Icons.support_agent_rounded,
        ),
      _ => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (supportContext != null)
            Padding(
              padding: AppSpacing.supportContentPadding,
              child: _SupportContextCard(supportContext: supportContext!),
            ),
          _QuickContactGrid(snapshot: snapshot),
          Padding(
            padding: AppSpacing.supportContentPadding,
            child: _SupportTabs(
              ticketCount: snapshot.tickets.length,
              showFaq: showFaq,
              onShowTickets: onShowTickets,
              onShowFaq: onShowFaq,
            ),
          ),
          Padding(
            padding: AppSpacing.supportContentPadding,
            child: showFaq
                ? _FaqPanel(
                    items: snapshot.faqItems,
                    expandedIndex: expandedFaqIndex,
                    onToggle: onToggleFaq,
                  )
                : _TicketsPanel(
                    activeTickets: activeTickets,
                    doneTickets: doneTickets,
                  ),
          ),
        ],
      ),
    };
  }
}

class _QuickContactGrid extends StatelessWidget {
  const _QuickContactGrid({required this.snapshot});

  final SupportHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: SupportPage.quickLinksKey,
      padding: AppSpacing.supportContentPadding,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _QuickLinkCard(
                  key: SupportPage.quickLinkKey('help'),
                  icon: Icons.menu_book_outlined,
                  eyebrow: 'Trung tâm',
                  title: 'Trợ giúp',
                  color: AppColors.accent,
                  onTap: () => context.go(snapshot.helpRoute),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _QuickLinkCard(
                  key: SupportPage.quickLinkKey('announcements'),
                  icon: Icons.notifications_none_rounded,
                  eyebrow: 'Thông báo',
                  title: 'Hệ thống',
                  color: AppColors.warn,
                  onTap: () => context.go(snapshot.announcementsRoute),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _QuickLinkCard(
                  key: SupportPage.quickLinkKey('email'),
                  icon: Icons.mail_outline_rounded,
                  eyebrow: 'Email',
                  title: 'support@...',
                  color: AppModuleAccents.support,
                  onTap: HapticFeedback.selectionClick,
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _QuickLinkCard(
                  key: SupportPage.quickLinkKey('hotline'),
                  icon: Icons.call_outlined,
                  eyebrow: 'Hotline',
                  title: snapshot.hotline,
                  color: AppColors.buy,
                  onTap: HapticFeedback.selectionClick,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickLinkCard extends StatelessWidget {
  const _QuickLinkCard({
    super.key,
    required this.icon,
    required this.eyebrow,
    required this.title,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String eyebrow;
  final String title;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.standard,
      borderColor: color.withValues(alpha: .28),
      padding: AppSpacing.supportQuickCardPadding,
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.iconMd),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eyebrow,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.navLabel.copyWith(color: color),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: AppSpacing.supportLineHeightTight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportTabs extends StatelessWidget {
  const _SupportTabs({
    required this.ticketCount,
    required this.showFaq,
    required this.onShowTickets,
    required this.onShowFaq,
  });

  final int ticketCount;
  final bool showFaq;
  final VoidCallback onShowTickets;
  final VoidCallback onShowFaq;

  @override
  Widget build(BuildContext context) {
    return VitTabBar(
      activeKey: showFaq ? 'faq' : 'tickets',
      variant: VitTabBarVariant.segment,
      tabs: [
        VitTabItem(
          key: 'tickets',
          label: 'Tickets ($ticketCount)',
          widgetKey: SupportPage.ticketsTabKey,
        ),
        const VitTabItem(
          key: 'faq',
          label: 'FAQ',
          widgetKey: SupportPage.faqTabKey,
        ),
      ],
      onChanged: (key) {
        if (key == 'faq') {
          onShowFaq();
          return;
        }
        onShowTickets();
      },
    );
  }
}
