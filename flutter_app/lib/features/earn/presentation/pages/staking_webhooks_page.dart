import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/features/earn/data/earn_repository.dart';

class StakingWebhooksPage extends ConsumerWidget {
  const StakingWebhooksPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc393_webhooks_hero');
  static const createKey = Key('sc393_create_webhook');
  static const activeKey = Key('sc393_active_webhooks');
  static const eventsKey = Key('sc393_available_events');
  static const createSheetKey = Key('sc393_create_sheet');
  static const urlFieldKey = Key('sc393_webhook_url_field');

  static Key webhookKey(String id) => Key('sc393_webhook_$id');

  static Key webhookDeleteKey(String id) => Key('sc393_delete_$id');

  static Key eventKey(String id) => Key('sc393_event_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(stakingWebhooksRepositoryProvider).getWebhooks();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      semanticLabel: 'SC-393 StakingWebhooksPage',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  padding: VitContentPadding.defaultPadding,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _WebhooksHero(snapshot: snapshot),
                    VitCtaButton(
                      key: createKey,
                      onPressed: () => _showCreateSheet(context, snapshot),
                      leading: const Icon(Icons.add_rounded),
                      child: Text(snapshot.createLabel),
                    ),
                    _ActiveWebhooks(snapshot: snapshot),
                    _AvailableEvents(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSheet(
    BuildContext context,
    StakingWebhooksSnapshot snapshot,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _SheetFrame(child: _CreateWebhookSheet(snapshot: snapshot)),
    );
  }
}

class _WebhooksHero extends StatelessWidget {
  const _WebhooksHero({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: StakingWebhooksPage.heroKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      borderColor: AppColors.accent30,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            snapshot.heroTitle,
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: AppSpacing.x2),
          Text(
            snapshot.heroBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActiveWebhooks extends StatelessWidget {
  const _ActiveWebhooks({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingWebhooksPage.activeKey,
      label: snapshot.activeTitle,
      children: [
        for (final webhook in snapshot.webhooks) _WebhookCard(webhook: webhook),
      ],
    );
  }
}

class _WebhookCard extends StatelessWidget {
  const _WebhookCard({required this.webhook});

  final StakingWebhookDraft webhook;

  @override
  Widget build(BuildContext context) {
    final statusColor = webhook.active ? AppColors.buy : AppColors.sell;
    return VitCard(
      key: StakingWebhooksPage.webhookKey(webhook.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      webhook.url,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        Icon(
                          webhook.active
                              ? Icons.check_circle_outline_rounded
                              : Icons.cancel_outlined,
                          color: statusColor,
                          size: AppSpacing.iconSm,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Expanded(
                          child: Text(
                            'Last: ${webhook.lastTriggered}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.micro.copyWith(
                              color: AppColors.text3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  key: StakingWebhooksPage.webhookDeleteKey(webhook.id),
                  borderRadius: AppRadii.smRadius,
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.x1),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: AppColors.sell,
                      size: AppSpacing.iconSm,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in webhook.events)
                _EventChip(
                  key: StakingWebhooksPage.eventKey('${webhook.id}_$event'),
                  label: event,
                  selected: false,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AvailableEvents extends StatelessWidget {
  const _AvailableEvents({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: StakingWebhooksPage.eventsKey,
      label: snapshot.eventsTitle,
      children: [
        VitCard(
          radius: VitCardRadius.lg,
          padding: const EdgeInsets.all(AppSpacing.x4),
          child: Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in snapshot.availableEvents)
                _EventChip(
                  key: StakingWebhooksPage.eventKey(event),
                  label: event,
                  selected: true,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EventChip extends StatelessWidget {
  const _EventChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? AppColors.primary15 : AppColors.surface2;
    final fg = selected ? AppColors.primarySoft : AppColors.text3;
    return Material(
      color: bg,
      borderRadius: AppRadii.smRadius,
      child: InkWell(
        borderRadius: AppRadii.smRadius,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x2,
            vertical: AppSpacing.x1,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(color: fg),
          ),
        ),
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        margin: const EdgeInsets.all(AppSpacing.contentPad),
        padding: const EdgeInsets.all(AppSpacing.x5),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.88,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadii.cardLargeRadius,
        ),
        child: child,
      ),
    );
  }
}

class _CreateWebhookSheet extends StatefulWidget {
  const _CreateWebhookSheet({required this.snapshot});

  final StakingWebhooksSnapshot snapshot;

  @override
  State<_CreateWebhookSheet> createState() => _CreateWebhookSheetState();
}

class _CreateWebhookSheetState extends State<_CreateWebhookSheet> {
  late final TextEditingController _controller;
  late final Set<String> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _selectedEvents = widget.snapshot.availableEvents.take(1).toSet();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final events = widget.snapshot.availableEvents.take(4).toList();
    return SingleChildScrollView(
      key: StakingWebhooksPage.createSheetKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.snapshot.sheetTitle,
            style: AppTextStyles.sectionTitle.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x5),
          VitInput(
            controller: _controller,
            fieldKey: StakingWebhooksPage.urlFieldKey,
            label: widget.snapshot.urlLabel,
            hintText: widget.snapshot.urlPlaceholder,
            keyboardType: TextInputType.url,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            widget.snapshot.eventsLabel,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x2),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final event in events)
                _EventChip(
                  key: StakingWebhooksPage.eventKey('sheet_$event'),
                  label: event,
                  selected: _selectedEvents.contains(event),
                  onTap: () {
                    setState(() {
                      if (_selectedEvents.contains(event)) {
                        _selectedEvents.remove(event);
                      } else {
                        _selectedEvents.add(event);
                      }
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          VitCtaButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(widget.snapshot.createLabel),
          ),
        ],
      ),
    );
  }
}
