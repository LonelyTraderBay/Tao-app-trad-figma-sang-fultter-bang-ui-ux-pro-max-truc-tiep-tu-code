part of '../pages/support_page.dart';

class _QuickContactGrid extends StatelessWidget {
  const _QuickContactGrid({required this.snapshot});

  final SupportHubSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: SupportPage.quickLinksKey,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.contentPad,
        AppSpacing.x4,
        AppSpacing.contentPad,
        AppSpacing.x4,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
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
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .28),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x4,
        vertical: AppSpacing.x4,
      ),
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
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontSize: 11,
                  ),
                ),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.25,
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
    return Row(
      children: [
        Expanded(
          child: _TabButton(
            key: SupportPage.ticketsTabKey,
            label: 'Tickets ($ticketCount)',
            selected: !showFaq,
            onTap: onShowTickets,
          ),
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: _TabButton(
            key: SupportPage.faqTabKey,
            label: 'FAQ',
            selected: showFaq,
            onTap: onShowFaq,
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: selected ? AppColors.onAccent : AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}
