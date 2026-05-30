import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
import 'package:vit_trade_flutter/app/providers/cross_module_controller_providers.dart';

class SmartAlertCenter extends ConsumerStatefulWidget {
  const SmartAlertCenter({super.key, this.shellRenderMode});

  static const contentKey = Key('sc323_smart_alert_center_content');
  static const createButtonKey = Key('sc323_create_alert_button');
  static Key tabKey(SmartAlertTab tab) => Key('sc323_tab_${tab.name}');
  static Key channelKey(String channelId) => Key('sc323_channel_$channelId');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SmartAlertCenter> createState() => _SmartAlertCenterState();
}

class _SmartAlertCenterState extends ConsumerState<SmartAlertCenter> {
  SmartAlertTab _activeTab = SmartAlertTab.active;
  final Map<String, bool> _channelOverrides = {};

  @override
  Widget build(BuildContext context) {
    final controller = ref.watch(smartAlertsControllerProvider);
    final snapshot = controller.state.snapshot;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-323 SmartAlertCenter',
      child: Material(
        color: AppColors.bg,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
            ),
            _SmartAlertTabs(
              tabs: snapshot.tabs,
              active: _activeTab,
              onChanged: (tab) {
                HapticFeedback.selectionClick();
                setState(() => _activeTab = tab);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                key: SmartAlertCenter.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    if (_activeTab == SmartAlertTab.active)
                      _ActiveAlertsTab(snapshot: snapshot)
                    else if (_activeTab == SmartAlertTab.history)
                      _AlertHistoryTab(snapshot: snapshot)
                    else
                      _AlertSettingsTab(
                        snapshot: snapshot,
                        isChannelEnabled: (channel) =>
                            _channelOverrides[channel.id] ?? channel.enabled,
                        onToggleChannel: (channel) {
                          HapticFeedback.selectionClick();
                          setState(() {
                            final current =
                                _channelOverrides[channel.id] ??
                                channel.enabled;
                            _channelOverrides[channel.id] = !current;
                          });
                        },
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SmartAlertTabs extends StatelessWidget {
  const _SmartAlertTabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SmartAlertTabDraft> tabs;
  final SmartAlertTab active;
  final ValueChanged<SmartAlertTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.contentPad),
        child: Row(
          children: [
            for (final tab in tabs)
              Expanded(
                child: InkWell(
                  key: SmartAlertCenter.tabKey(tab.tab),
                  onTap: () => onChanged(tab.tab),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.x4,
                        ),
                        child: Text(
                          tab.label,
                          style: AppTextStyles.caption.copyWith(
                            color: tab.tab == active
                                ? AppColors.primary
                                : AppColors.text3,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        height: AppSpacing.x1,
                        width: tab.tab == active ? AppSpacing.buttonHero : 0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: AppRadii.xlRadius,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActiveAlertsTab extends StatelessWidget {
  const _ActiveAlertsTab({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SmartAlertSummaryCard(snapshot: snapshot),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Canh bao hoat dong',
          children: [
            for (final alert in snapshot.alerts) _SmartAlertCard(alert: alert),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        const _CreateAlertButton(),
        const SizedBox(height: AppSpacing.x4),
        _InfoPanel(
          icon: Icons.info_outline_rounded,
          color: AppColors.primary,
          background: AppColors.primary08,
          border: AppColors.primary20,
          text:
              'Smart alerts work across all modules. Set conditions and get notified via push, email, or SMS.',
        ),
      ],
    );
  }
}

class _SmartAlertSummaryCard extends StatelessWidget {
  const _SmartAlertSummaryCard({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _IconBadge(
                icon: Icons.notifications_none_rounded,
                color: AppColors.primary,
                background: AppColors.primary12,
                size: AppSpacing.inputHeight,
                iconSize: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.title,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      '${snapshot.alerts.length} total alerts',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _MetricColumn(
                  label: 'Active',
                  value: '${snapshot.activeCount}',
                  valueColor: AppColors.buy,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Triggered',
                  value: '${snapshot.totalTriggers}',
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: 'Modules',
                  value: '${snapshot.moduleCount}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x2),
        Text(
          value,
          style: AppTextStyles.sectionTitle.copyWith(
            color: valueColor,
            fontSize: AppSpacing.x5,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _SmartAlertCard extends StatelessWidget {
  const _SmartAlertCard({required this.alert});

  final SmartAlertDraft alert;

  @override
  Widget build(BuildContext context) {
    final module = _moduleVisual(alert.module);

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _IconBadge(
                icon: module.icon,
                color: module.color,
                background: module.background,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: AppSpacing.x2,
                      runSpacing: AppSpacing.x1,
                      children: [
                        Text(
                          alert.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.baseMedium.copyWith(
                            fontSize: AppSpacing.x4,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusBadge(status: alert.status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      alert.moduleName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              _SmallIconAction(
                icon: Icons.edit_outlined,
                color: AppColors.text3,
                background: AppColors.surface2,
                onTap: HapticFeedback.selectionClick,
              ),
              const SizedBox(width: AppSpacing.x2),
              _SmallIconAction(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                background: AppColors.sell10,
                onTap: HapticFeedback.selectionClick,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          _DetailBlock(label: 'Condition', value: alert.condition),
          const SizedBox(height: AppSpacing.x3),
          _DetailBlock(label: 'Action', value: alert.action),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              Expanded(
                child: _DetailBlock(
                  label: 'Triggered',
                  value: '${alert.triggerCount} times',
                  emphasize: true,
                ),
              ),
              if (alert.lastTriggeredLabel != null)
                Expanded(
                  child: _DetailBlock(
                    label: 'Last Trigger',
                    value: alert.lastTriggeredLabel!,
                    emphasize: true,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SmartAlertStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SmartAlertStatus.active => AppColors.buy,
      SmartAlertStatus.paused => AppColors.text3,
      SmartAlertStatus.triggered => AppColors.primary,
    };
    final background = switch (status) {
      SmartAlertStatus.active => AppColors.buy10,
      SmartAlertStatus.paused => AppColors.surface3,
      SmartAlertStatus.triggered => AppColors.primary12,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.x3,
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: emphasize ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _CreateAlertButton extends StatelessWidget {
  const _CreateAlertButton();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        key: SmartAlertCenter.createButtonKey,
        onTap: HapticFeedback.selectionClick,
        borderRadius: AppRadii.inputRadius,
        child: SizedBox(
          height: AppSpacing.ctaHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_rounded,
                size: AppSpacing.iconMd,
                color: AppColors.navCenterIcon,
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                'Create Alert',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.navCenterIcon,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertHistoryTab extends StatelessWidget {
  const _AlertHistoryTab({required this.snapshot});

  final SmartAlertsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Alert History',
          children: [
            for (final entry in snapshot.history)
              VitCard(
                padding: const EdgeInsets.all(AppSpacing.x4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.alertName,
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.text1,
                                  fontWeight: AppTextStyles.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.x2),
                              _ModulePill(label: entry.moduleName),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.buy,
                          size: AppSpacing.iconMd,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x3),
                    Text(
                      entry.action,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Row(
                      children: [
                        const Icon(
                          Icons.schedule_rounded,
                          size: AppSpacing.iconSm,
                          color: AppColors.text3,
                        ),
                        const SizedBox(width: AppSpacing.x2),
                        Text(
                          entry.triggeredAtLabel,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitCard(
          padding: const EdgeInsets.all(AppSpacing.x4),
          radius: VitCardRadius.lg,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Alert Statistics (30 days)',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.x4),
              Row(
                children: [
                  Expanded(
                    child: _MetricColumn(
                      label: 'Total Triggered',
                      value: '${snapshot.totalTriggers}',
                    ),
                  ),
                  Expanded(
                    child: _MetricColumn(
                      label: 'Avg per Day',
                      value: (snapshot.totalTriggers / 30).toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertSettingsTab extends StatelessWidget {
  const _AlertSettingsTab({
    required this.snapshot,
    required this.isChannelEnabled,
    required this.onToggleChannel,
  });

  final SmartAlertsSnapshot snapshot;
  final bool Function(SmartAlertChannelDraft channel) isChannelEnabled;
  final ValueChanged<SmartAlertChannelDraft> onToggleChannel;

  @override
  Widget build(BuildContext context) {
    final categories = snapshot.templates
        .map((template) => template.category)
        .toSet()
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitPageSection(
          label: 'Notification Channels',
          children: [
            for (final channel in snapshot.channels)
              _ChannelCard(
                channel: channel,
                enabled: isChannelEnabled(channel),
                onTap: () => onToggleChannel(channel),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.sectionGap),
        VitPageSection(
          label: 'Alert Templates',
          children: [
            for (final category in categories)
              _TemplateCategory(
                category: category,
                templates: snapshot.templates
                    .where((template) => template.category == category)
                    .toList(),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        _InfoPanel(
          icon: Icons.warning_amber_rounded,
          color: AppColors.warn,
          background: AppColors.warn08,
          border: AppColors.warn15,
          text:
              'SMS alerts may incur additional charges. Check with your mobile provider.',
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({
    required this.channel,
    required this.enabled,
    required this.onTap,
  });

  final SmartAlertChannelDraft channel;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  enabled ? 'Enabled' : 'Disabled',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _ToggleSwitch(
            key: SmartAlertCenter.channelKey(channel.id),
            enabled: enabled,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}

class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({super.key, required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: AppSpacing.inputHeight,
        height: AppSpacing.x6,
        padding: const EdgeInsets.all(AppSpacing.x2),
        decoration: BoxDecoration(
          color: enabled ? AppColors.primary : AppColors.toggleTrackOff,
          borderRadius: AppRadii.xlRadius,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 160),
          alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: AppSpacing.x5,
            height: AppSpacing.x5,
            decoration: const BoxDecoration(
              color: AppColors.navCenterIcon,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}

class _TemplateCategory extends StatelessWidget {
  const _TemplateCategory({required this.category, required this.templates});

  final String category;
  final List<SmartAlertTemplateDraft> templates;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          category,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final template in templates) ...[
          _TemplateCard(template: template),
          if (template != templates.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({required this.template});

  final SmartAlertTemplateDraft template;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x3),
      radius: VitCardRadius.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            template.name,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x1),
          Text(
            template.description,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              const Icon(
                Icons.stacked_line_chart_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconSm,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${template.popularity}% users',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              TextButton(
                onPressed: HapticFeedback.selectionClick,
                style: TextButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.navCenterIcon,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.x4,
                    vertical: AppSpacing.x2,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadii.smRadius,
                  ),
                ),
                child: Text(
                  'Use',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.navCenterIcon,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModulePill extends StatelessWidget {
  const _ModulePill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text2),
        ),
      ),
    );
  }
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
    this.size = AppSpacing.x6,
    this.iconSize = AppSpacing.iconSm,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: iconSize),
    );
  }
}

class _SmallIconAction extends StatelessWidget {
  const _SmallIconAction({
    required this.icon,
    required this.color,
    required this.background,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        width: AppSpacing.x6,
        height: AppSpacing.x6,
        decoration: BoxDecoration(
          color: background,
          borderRadius: AppRadii.smRadius,
        ),
        child: Icon(icon, color: color, size: AppSpacing.iconSm),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.color,
    required this.background,
    required this.border,
    required this.text,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final Color border;
  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.micro.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final class _ModuleVisual {
  const _ModuleVisual({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;
}

_ModuleVisual _moduleVisual(SmartAlertModuleId module) {
  return switch (module) {
    SmartAlertModuleId.trading => const _ModuleVisual(
      icon: Icons.trending_up_rounded,
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    SmartAlertModuleId.p2p => const _ModuleVisual(
      icon: Icons.shopping_cart_outlined,
      color: AppModuleAccents.p2p,
      background: AppColors.warn10,
    ),
    SmartAlertModuleId.predictions => const _ModuleVisual(
      icon: Icons.track_changes_rounded,
      color: AppModuleAccents.predictions,
      background: AppColors.accent10,
    ),
    SmartAlertModuleId.arena => const _ModuleVisual(
      icon: Icons.bolt_rounded,
      color: AppModuleAccents.arena,
      background: AppColors.warn10,
    ),
    SmartAlertModuleId.dca => const _ModuleVisual(
      icon: Icons.show_chart_rounded,
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    SmartAlertModuleId.wallet => const _ModuleVisual(
      icon: Icons.account_balance_wallet_outlined,
      color: AppModuleAccents.wallet,
      background: AppColors.primary15,
    ),
  };
}
