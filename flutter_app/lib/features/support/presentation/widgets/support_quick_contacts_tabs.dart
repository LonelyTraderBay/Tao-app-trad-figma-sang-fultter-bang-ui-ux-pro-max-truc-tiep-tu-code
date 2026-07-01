part of '../pages/support_page.dart';

class _QuickContactGrid extends StatelessWidget {
  const _QuickContactGrid({required this.snapshot});

  final SupportHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SupportPage.quickLinksKey,
      radius: VitCardRadius.standard,
      padding: AppSpacing.supportQuickLinksPadding,
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
