part of '../pages/support_page.dart';

class _TicketsPanel extends StatelessWidget {
  const _TicketsPanel({required this.activeTickets, required this.doneTickets});

  final List<SupportTicketDraft> activeTickets;
  final List<SupportTicketDraft> doneTickets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _CreateTicketButton(onTap: HapticFeedback.selectionClick),
        const SizedBox(height: AppSpacing.x5),
        if (activeTickets.isNotEmpty) ...[
          _TicketSection(
            key: SupportPage.activeTicketsKey,
            title: 'ĐANG XỬ LÝ (${activeTickets.length})',
            tickets: activeTickets,
          ),
          const SizedBox(height: AppSpacing.x5),
        ],
        if (doneTickets.isNotEmpty)
          _TicketSection(
            key: SupportPage.doneTicketsKey,
            title: 'ĐÃ HOÀN THÀNH',
            tickets: doneTickets,
          ),
      ],
    );
  }
}

class _CreateTicketButton extends StatelessWidget {
  const _CreateTicketButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: SupportPage.createTicketKey,
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: AppSpacing.ctaHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add_rounded, color: AppColors.onAccent, size: 20),
            const SizedBox(width: AppSpacing.x3),
            Text(
              'Tạo ticket mới',
              style: AppTextStyles.baseMedium.copyWith(
                color: AppColors.onAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TicketSection extends StatelessWidget {
  const _TicketSection({super.key, required this.title, required this.tickets});

  final String title;
  final List<SupportTicketDraft> tickets;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (var i = 0; i < tickets.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.x3),
          _TicketCard(ticket: tickets[i]),
        ],
      ],
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final SupportTicketDraft ticket;

  @override
  Widget build(BuildContext context) {
    final status = _statusStyle(ticket.status);
    final priority = _priorityStyle(ticket.priority);
    final lastMessage = ticket.messages.last;
    return VitCard(
      key: SupportPage.ticketKey(ticket.id),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: HapticFeedback.selectionClick,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    _MiniPill(
                      label: '#${ticket.id.toUpperCase()}',
                      style: status,
                    ),
                    _MiniPill(label: priority.label, style: priority),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _StatusLabel(style: status),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            ticket.subject,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
              height: 1.25,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _CategoryPill(label: _categoryLabel(ticket.category)),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Tạo lúc ${ticket.createdAt}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Container(
            padding: const EdgeInsets.all(AppSpacing.x4),
            decoration: const BoxDecoration(
              color: AppColors.surface2,
              borderRadius: AppRadii.mdRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.chat_bubble_outline_rounded,
                      color: AppColors.text2,
                      size: AppSpacing.iconSm,
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      lastMessage.sender == 'user' ? 'Bạn' : 'Hỗ trợ',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text2,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    Text(
                      lastMessage.time,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  lastMessage.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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
