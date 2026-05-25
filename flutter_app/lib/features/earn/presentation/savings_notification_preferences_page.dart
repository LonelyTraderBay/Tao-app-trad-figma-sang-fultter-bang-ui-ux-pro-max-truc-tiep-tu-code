import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/earn_repository.dart';

TextStyle get _captionMedium =>
    AppTextStyles.caption.copyWith(fontWeight: AppTextStyles.medium);
TextStyle get _bodyBold =>
    AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold);

class SavingsNotificationPreferencesPage extends ConsumerStatefulWidget {
  const SavingsNotificationPreferencesPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc345_summary');
  static const statsKey = Key('sc345_stats');
  static const eventsListKey = Key('sc345_events_list');
  static const productsListKey = Key('sc345_products_list');
  static const deliveryListKey = Key('sc345_delivery_list');
  static const masterToggleKey = Key('sc345_master_toggle');

  static Key alertKey(String id) => Key('sc345_alert_$id');
  static Key productKey(String id) => Key('sc345_product_$id');
  static Key channelKey(String id) => Key('sc345_channel_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<SavingsNotificationPreferencesPage> createState() =>
      _SavingsNotificationPreferencesPageState();
}

class _SavingsNotificationPreferencesPageState
    extends ConsumerState<SavingsNotificationPreferencesPage> {
  String? _tab;
  bool? _masterEnabled;
  late List<SavingsNotificationAlertDraft> _alerts;
  late List<SavingsDeliveryChannelDraft> _channels;

  @override
  void initState() {
    super.initState();
    final snapshot = const MockSavingsNotificationPreferencesRepository()
        .getPreferences();
    _alerts = snapshot.alerts;
    _channels = snapshot.channels;
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(savingsNotificationPreferencesRepositoryProvider)
        .getPreferences();
    final activeTab = _tab ?? snapshot.defaultTab;
    final masterEnabled = _masterEnabled ?? snapshot.masterEnabled;
    final enabledAlerts = _alerts.where((item) => item.enabled).length;
    final enabledChannels = _channels.where((item) => item.enabled).length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-345 SavingsNotificationPreferencesPage',
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
                  padding: VitContentPadding.compact,
                  gap: VitContentGap.defaultGap,
                  children: [
                    _MasterSummaryCard(
                      masterEnabled: masterEnabled,
                      enabledAlerts: enabledAlerts,
                      totalAlerts: _alerts.length,
                      onChanged: (value) {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _masterEnabled = value;
                          if (!value) {
                            _alerts = [
                              for (final alert in _alerts)
                                SavingsNotificationAlertDraft(
                                  id: alert.id,
                                  title: alert.title,
                                  description: alert.description,
                                  iconKey: alert.iconKey,
                                  enabled: false,
                                  category: alert.category,
                                  severity: alert.severity,
                                ),
                            ];
                          }
                        });
                      },
                    ),
                    _QuickStats(
                      enabledChannels: enabledChannels,
                      totalChannels: _channels.length,
                      digestFrequency: snapshot.digestFrequency,
                      quietHours: snapshot.quietHours,
                    ),
                    _Tabs(
                      tabs: snapshot.tabs,
                      active: activeTab,
                      onChanged: (tab) {
                        HapticFeedback.selectionClick();
                        setState(() => _tab = tab);
                      },
                    ),
                    if (activeTab == 'events')
                      _EventsTab(
                        alerts: _alerts,
                        masterEnabled: masterEnabled,
                        onToggle: _toggleAlert,
                      )
                    else if (activeTab == 'products')
                      _ProductsTab(products: snapshot.productAlerts)
                    else
                      _DeliveryTab(
                        channels: _channels,
                        digestFrequency: snapshot.digestFrequency,
                        quietHours: snapshot.quietHours,
                        onToggle: _toggleChannel,
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

  void _toggleAlert(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          alert.id == id
              ? SavingsNotificationAlertDraft(
                  id: alert.id,
                  title: alert.title,
                  description: alert.description,
                  iconKey: alert.iconKey,
                  enabled: !alert.enabled,
                  category: alert.category,
                  severity: alert.severity,
                )
              : alert,
      ];
    });
  }

  void _toggleChannel(String id) {
    HapticFeedback.selectionClick();
    setState(() {
      _channels = [
        for (final channel in _channels)
          channel.id == id && !channel.locked
              ? SavingsDeliveryChannelDraft(
                  id: channel.id,
                  label: channel.label,
                  detail: channel.detail,
                  iconKey: channel.iconKey,
                  enabled: !channel.enabled,
                  locked: channel.locked,
                )
              : channel,
      ];
    });
  }
}

class _MasterSummaryCard extends StatelessWidget {
  const _MasterSummaryCard({
    required this.masterEnabled,
    required this.enabledAlerts,
    required this.totalAlerts,
    required this.onChanged,
  });

  final bool masterEnabled;
  final int enabledAlerts;
  final int totalAlerts;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final color = masterEnabled ? AppColors.buy : AppColors.sell;

    return VitCard(
      key: SavingsNotificationPreferencesPage.summaryKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              masterEnabled
                  ? Icons.notifications_none_rounded
                  : Icons.notifications_off_outlined,
              color: color,
              size: 22,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  masterEnabled ? 'Thông báo đang bật' : 'Thông báo đã tắt',
                  style: _bodyBold.copyWith(color: AppColors.text1),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '$enabledAlerts/$totalAlerts loại thông báo đang hoạt động',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _TokenSwitch(
            key: SavingsNotificationPreferencesPage.masterToggleKey,
            value: masterEnabled,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _QuickStats extends StatelessWidget {
  const _QuickStats({
    required this.enabledChannels,
    required this.totalChannels,
    required this.digestFrequency,
    required this.quietHours,
  });

  final int enabledChannels;
  final int totalChannels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: SavingsNotificationPreferencesPage.statsKey,
      children: [
        Expanded(
          child: _StatTile(
            label: 'Kênh hoạt động',
            value: '$enabledChannels/$totalChannels',
            color: AppColors.text1,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatTile(
            label: 'Tần suất',
            value: _frequencyLabel(digestFrequency),
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: _StatTile(
            label: 'Giờ im lặng',
            value: quietHours.enabled
                ? '${quietHours.startHour}h-${quietHours.endHour}h'
                : 'Tắt',
            color: quietHours.enabled ? AppColors.accent : AppColors.text3,
          ),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: AppSpacing.x1),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: _bodyBold.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({
    required this.tabs,
    required this.active,
    required this.onChanged,
  });

  final List<SavingsPreferenceTabDraft> tabs;
  final String active;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
        child: VitTabBar(
          variant: VitTabBarVariant.underline,
          activeKey: active,
          onChanged: onChanged,
          tabs: [
            for (final tab in tabs) VitTabItem(key: tab.id, label: tab.label),
          ],
        ),
      ),
    );
  }
}

class _EventsTab extends StatelessWidget {
  const _EventsTab({
    required this.alerts,
    required this.masterEnabled,
    required this.onToggle,
  });

  final List<SavingsNotificationAlertDraft> alerts;
  final bool masterEnabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesPage.eventsListKey,
      children: [
        for (final category in SavingsNotificationPreferenceCategory.values)
          _CategorySection(
            category: category,
            alerts: [
              for (final alert in alerts)
                if (alert.category == category) alert,
            ],
            masterEnabled: masterEnabled,
            onToggle: onToggle,
          ),
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({
    required this.category,
    required this.alerts,
    required this.masterEnabled,
    required this.onToggle,
  });

  final SavingsNotificationPreferenceCategory category;
  final List<SavingsNotificationAlertDraft> alerts;
  final bool masterEnabled;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category);
    final enabled = alerts.where((item) => item.enabled).length;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(_categoryIcon(category), color: color, size: 18),
              const SizedBox(width: AppSpacing.x2),
              Text(
                _categoryLabel(category),
                style: _captionMedium.copyWith(color: AppColors.text2),
              ),
              const SizedBox(width: AppSpacing.x2),
              Text(
                '($enabled/${alerts.length})',
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x2),
          for (final alert in alerts) ...[
            _AlertCard(
              alert: alert,
              enabled: masterEnabled && alert.enabled,
              disabled: !masterEnabled,
              onToggle: () => onToggle(alert.id),
            ),
            if (alert != alerts.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({
    required this.alert,
    required this.enabled,
    required this.disabled,
    required this.onToggle,
  });

  final SavingsNotificationAlertDraft alert;
  final bool enabled;
  final bool disabled;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(alert.severity);

    return VitCard(
      key: SavingsNotificationPreferencesPage.alertKey(alert.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(_alertIcon(alert.iconKey), color: color, size: 19),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        alert.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: _captionMedium.copyWith(color: AppColors.text1),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _SeverityPill(severity: alert.severity),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  alert.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    height: 1.32,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          _TokenSwitch(
            value: enabled,
            disabled: disabled,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }
}

class _ProductsTab extends StatelessWidget {
  const _ProductsTab({required this.products});

  final List<SavingsProductNotificationDraft> products;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesPage.productsListKey,
      children: [
        _InfoCard(
          icon: Icons.info_outline_rounded,
          text:
              'Tùy chỉnh thông báo cho từng sản phẩm đang ký. Chỉ áp dụng cho sản phẩm bạn đang có vị thế hoạt động.',
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final product in products) ...[
          _ProductCard(product: product),
          if (product != products.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final SavingsProductNotificationDraft product;

  @override
  Widget build(BuildContext context) {
    final color = _assetColorName(product.asset);

    return VitCard(
      key: SavingsNotificationPreferencesPage.productKey(product.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  product.asset,
                  style: AppTextStyles.micro.copyWith(
                    color: color,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.productName,
                      style: _captionMedium.copyWith(color: AppColors.text1),
                    ),
                    Text(
                      '${product.enabledCount}/${product.totalCount} thông báo đang bật',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                product.typeLabel == 'Linh hoạt'
                    ? Icons.lock_open_rounded
                    : Icons.lock_outline_rounded,
                color: product.typeLabel == 'Linh hoạt'
                    ? AppColors.buy
                    : AppColors.primary,
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final label in product.alertLabels)
                _SmallChip(label: label, color: color),
            ],
          ),
        ],
      ),
    );
  }
}

class _DeliveryTab extends StatelessWidget {
  const _DeliveryTab({
    required this.channels,
    required this.digestFrequency,
    required this.quietHours,
    required this.onToggle,
  });

  final List<SavingsDeliveryChannelDraft> channels;
  final SavingsDeliveryFrequency digestFrequency;
  final SavingsQuietHoursDraft quietHours;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: SavingsNotificationPreferencesPage.deliveryListKey,
      children: [
        VitPageSection(
          label: 'Kênh nhận thông báo',
          accentColor: AppColors.primary,
          children: [
            for (final channel in channels)
              _ChannelCard(channel: channel, onToggle: onToggle),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitPageSection(
          label: 'Tần suất gửi',
          accentColor: AppColors.primary,
          children: [
            _ActionSettingCard(
              icon: Icons.schedule_rounded,
              title: _frequencyLabel(digestFrequency),
              subtitle: _frequencyDescription(digestFrequency),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitPageSection(
          label: 'Giờ im lặng',
          accentColor: AppColors.accent,
          children: [
            _ActionSettingCard(
              icon: Icons.dark_mode_outlined,
              title: quietHours.enabled
                  ? '${quietHours.startHour}:00 - ${quietHours.endHour}:00'
                  : 'Chưa bật',
              subtitle: quietHours.enabled
                  ? 'Tạm dừng thông báo, ngoại trừ cảnh báo quan trọng'
                  : 'Bật để tạm dừng thông báo vào ban đêm',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCtaButton(
          onPressed: () => HapticFeedback.lightImpact(),
          child: const Text('Lưu tất cả cài đặt'),
        ),
      ],
    );
  }
}

class _ChannelCard extends StatelessWidget {
  const _ChannelCard({required this.channel, required this.onToggle});

  final SavingsDeliveryChannelDraft channel;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    final color = channel.enabled ? AppColors.buy : AppColors.text3;

    return VitCard(
      key: SavingsNotificationPreferencesPage.channelKey(channel.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(_alertIcon(channel.iconKey), color: color, size: 19),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  channel.label,
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                Text(
                  channel.detail,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          _TokenSwitch(
            value: channel.enabled,
            disabled: channel.locked,
            onChanged: (_) => onToggle(channel.id),
          ),
        ],
      ),
    );
  }
}

class _ActionSettingCard extends StatelessWidget {
  const _ActionSettingCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: _captionMedium.copyWith(color: AppColors.text1),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x3),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.caption.copyWith(color: AppColors.text2),
            ),
          ),
        ],
      ),
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadii.xs),
      ),
      child: Text(label, style: AppTextStyles.micro.copyWith(color: color)),
    );
  }
}

class _SeverityPill extends StatelessWidget {
  const _SeverityPill({required this.severity});

  final SavingsNotificationPreferenceSeverity severity;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(severity);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(AppRadii.xs),
      ),
      child: Text(
        _severityLabel(severity),
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TokenSwitch extends StatelessWidget {
  const _TokenSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    this.disabled = false,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final trackColor = value ? AppColors.buy : AppColors.surface3;
    final thumbColor = value ? Colors.white : AppColors.text3;

    return Semantics(
      button: true,
      toggled: value,
      enabled: !disabled,
      child: GestureDetector(
        onTap: disabled ? null : () => onChanged(!value),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: disabled ? .55 : 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 46,
            height: 26,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: trackColor,
              borderRadius: BorderRadius.circular(AppRadii.xl),
              border: Border.all(
                color: value ? AppColors.buy : AppColors.borderSolid,
              ),
            ),
            child: Align(
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: thumbColor,
                  shape: BoxShape.circle,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 4,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Color _severityColor(SavingsNotificationPreferenceSeverity severity) {
  switch (severity) {
    case SavingsNotificationPreferenceSeverity.critical:
      return AppColors.sell;
    case SavingsNotificationPreferenceSeverity.important:
      return AppColors.primary;
    case SavingsNotificationPreferenceSeverity.info:
      return AppColors.accent;
  }
}

String _severityLabel(SavingsNotificationPreferenceSeverity severity) {
  switch (severity) {
    case SavingsNotificationPreferenceSeverity.critical:
      return 'Quan trọng';
    case SavingsNotificationPreferenceSeverity.important:
      return 'Lưu ý';
    case SavingsNotificationPreferenceSeverity.info:
      return 'Thông tin';
  }
}

String _categoryLabel(SavingsNotificationPreferenceCategory category) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return 'Sản phẩm';
    case SavingsNotificationPreferenceCategory.transaction:
      return 'Giao dịch';
    case SavingsNotificationPreferenceCategory.system:
      return 'Hệ thống';
  }
}

Color _categoryColor(SavingsNotificationPreferenceCategory category) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return AppColors.primary;
    case SavingsNotificationPreferenceCategory.transaction:
      return AppColors.buy;
    case SavingsNotificationPreferenceCategory.system:
      return AppColors.accent;
  }
}

IconData _categoryIcon(SavingsNotificationPreferenceCategory category) {
  switch (category) {
    case SavingsNotificationPreferenceCategory.product:
      return Icons.inventory_2_outlined;
    case SavingsNotificationPreferenceCategory.transaction:
      return Icons.arrow_downward_rounded;
    case SavingsNotificationPreferenceCategory.system:
      return Icons.shield_outlined;
  }
}

IconData _alertIcon(String key) {
  switch (key) {
    case 'trending':
      return Icons.trending_up_rounded;
    case 'calendar':
      return Icons.calendar_today_rounded;
    case 'warning':
      return Icons.warning_amber_rounded;
    case 'package':
      return Icons.inventory_2_outlined;
    case 'zap':
      return Icons.bolt_rounded;
    case 'download':
      return Icons.arrow_downward_rounded;
    case 'upload':
      return Icons.arrow_upward_rounded;
    case 'piggy':
      return Icons.savings_outlined;
    case 'refresh':
      return Icons.sync_rounded;
    case 'target':
      return Icons.track_changes_rounded;
    case 'settings':
      return Icons.settings_outlined;
    case 'shield':
      return Icons.shield_outlined;
    case 'campaign':
      return Icons.campaign_outlined;
    case 'bell':
      return Icons.notifications_none_rounded;
    case 'mail':
      return Icons.mail_outline_rounded;
    case 'phone':
      return Icons.smartphone_rounded;
    case 'message':
      return Icons.message_outlined;
    default:
      return Icons.notifications_none_rounded;
  }
}

String _frequencyLabel(SavingsDeliveryFrequency frequency) {
  switch (frequency) {
    case SavingsDeliveryFrequency.instant:
      return 'Ngay lập tức';
    case SavingsDeliveryFrequency.hourly:
      return 'Mỗi giờ';
    case SavingsDeliveryFrequency.daily:
      return 'Hằng ngày';
    case SavingsDeliveryFrequency.weekly:
      return 'Hằng tuần';
  }
}

String _frequencyDescription(SavingsDeliveryFrequency frequency) {
  switch (frequency) {
    case SavingsDeliveryFrequency.instant:
      return 'Gửi thông báo mỗi khi sự kiện xảy ra';
    case SavingsDeliveryFrequency.hourly:
      return 'Gộp nhóm thông báo gửi 1 lần/giờ';
    case SavingsDeliveryFrequency.daily:
      return 'Tóm tắt thông báo gửi 1 lần/ngày lúc 9:00';
    case SavingsDeliveryFrequency.weekly:
      return 'Báo cáo tổng hợp gửi mỗi thứ Hai';
  }
}

Color _assetColorName(String asset) {
  switch (asset) {
    case 'USDT':
      return AppColors.buy;
    case 'BTC':
      return AppColors.primary;
    case 'SOL':
      return AppColors.accent;
    default:
      return AppColors.text2;
  }
}
