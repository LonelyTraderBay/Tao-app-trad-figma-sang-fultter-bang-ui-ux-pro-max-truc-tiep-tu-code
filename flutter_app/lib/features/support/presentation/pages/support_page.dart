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
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class SupportPage extends ConsumerStatefulWidget {
  const SupportPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc294_support_content');
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
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-294 SupportPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: SupportPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.none,
                    fullBleed: true,
                    customGap: AppSpacing.x5,
                    children: [
                      _QuickContactGrid(snapshot: snapshot),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
                        child: _SupportTabs(
                          ticketCount: snapshot.tickets.length,
                          showFaq: _showFaq,
                          onShowTickets: () => _setFaq(false),
                          onShowFaq: () => _setFaq(true),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.contentPad,
                        ),
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

class _FaqPanel extends StatelessWidget {
  const _FaqPanel({
    required this.items,
    required this.expandedIndex,
    required this.onToggle,
  });

  final List<SupportFaqDraft> items;
  final int? expandedIndex;
  final ValueChanged<int> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: AppModuleAccents.support,
              size: AppSpacing.iconMd,
            ),
            const SizedBox(width: AppSpacing.x3),
            Text(
              'Câu hỏi thường gặp',
              style: AppTextStyles.baseMedium.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.x3),
          _FaqCard(
            index: i,
            item: items[i],
            expanded: expandedIndex == i,
            onTap: () => onToggle(i),
          ),
        ],
        const SizedBox(height: AppSpacing.x5),
        VitCard(
          variant: VitCardVariant.inner,
          padding: const EdgeInsets.all(AppSpacing.x4),
          borderColor: AppColors.primary20,
          child: Text(
            'Không tìm thấy câu trả lời? Hãy tạo ticket hoặc liên hệ support qua email/hotline.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
      ],
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({
    required this.index,
    required this.item,
    required this.expanded,
    required this.onTap,
  });

  final int index;
  final SupportFaqDraft item;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SupportPage.faqKey(index),
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x4),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.question,
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              AnimatedRotation(
                turns: expanded ? .5 : 0,
                duration: const Duration(milliseconds: 160),
                child: Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary12,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppModuleAccents.support,
                    size: AppSpacing.iconMd,
                  ),
                ),
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: AppSpacing.x3),
            Text(
              item.answer,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ],
        ],
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({required this.label, required this.style});

  final String label;
  final _SupportLabelStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: style.color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: style.color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({required this.style});

  final _SupportLabelStyle style;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(style.icon, color: style.color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Text(
          style.label,
          style: AppTextStyles.micro.copyWith(
            color: style.color,
            fontWeight: AppTextStyles.bold,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class _CategoryPill extends StatelessWidget {
  const _CategoryPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: AppColors.text2,
          fontSize: 11,
        ),
      ),
    );
  }
}

final class _SupportLabelStyle {
  const _SupportLabelStyle({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

_SupportLabelStyle _statusStyle(SupportTicketStatus status) {
  return switch (status) {
    SupportTicketStatus.open => const _SupportLabelStyle(
      label: 'Mở',
      color: AppModuleAccents.support,
      icon: Icons.access_time_rounded,
    ),
    SupportTicketStatus.inProgress => const _SupportLabelStyle(
      label: 'Đang xử lý',
      color: AppColors.warn,
      icon: Icons.error_outline_rounded,
    ),
    SupportTicketStatus.resolved => const _SupportLabelStyle(
      label: 'Đã giải quyết',
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
    ),
    SupportTicketStatus.closed => const _SupportLabelStyle(
      label: 'Đã đóng',
      color: AppColors.text2,
      icon: Icons.cancel_outlined,
    ),
  };
}

_SupportLabelStyle _priorityStyle(SupportTicketPriority priority) {
  return switch (priority) {
    SupportTicketPriority.low => const _SupportLabelStyle(
      label: 'Thấp',
      color: AppColors.text2,
      icon: Icons.low_priority_rounded,
    ),
    SupportTicketPriority.medium => const _SupportLabelStyle(
      label: 'Trung bình',
      color: AppModuleAccents.support,
      icon: Icons.flag_outlined,
    ),
    SupportTicketPriority.high => const _SupportLabelStyle(
      label: 'Cao',
      color: AppColors.warn,
      icon: Icons.priority_high_rounded,
    ),
    SupportTicketPriority.urgent => const _SupportLabelStyle(
      label: 'Khẩn cấp',
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
    ),
  };
}

String _categoryLabel(SupportTicketCategory category) {
  return switch (category) {
    SupportTicketCategory.technical => 'Kỹ thuật',
    SupportTicketCategory.trading => 'Giao dịch',
    SupportTicketCategory.deposit => 'Nạp tiền',
    SupportTicketCategory.withdraw => 'Rút tiền',
    SupportTicketCategory.kyc => 'KYC',
    SupportTicketCategory.other => 'Khác',
  };
}
