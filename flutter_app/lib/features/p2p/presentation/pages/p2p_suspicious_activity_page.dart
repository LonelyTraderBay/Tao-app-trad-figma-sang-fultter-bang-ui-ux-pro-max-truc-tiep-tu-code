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
import 'package:vit_trade_flutter/shared/layout/vit_auto_hide_header_scaffold.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PSuspiciousActivityPage extends ConsumerStatefulWidget {
  const P2PSuspiciousActivityPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc258_p2p_suspicious_summary');
  static const alertsKey = Key('sc258_p2p_suspicious_alerts');
  static const emptyKey = Key('sc258_p2p_suspicious_empty');

  static Key alertKey(String id) => Key('sc258_p2p_suspicious_alert_$id');

  static Key dismissKey(String id) => Key('sc258_p2p_suspicious_dismiss_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PSuspiciousActivityPage> createState() =>
      _P2PSuspiciousActivityPageState();
}

class _P2PSuspiciousActivityPageState
    extends ConsumerState<P2PSuspiciousActivityPage> {
  late List<P2PSuspiciousAlertDraft> _alerts;

  @override
  void initState() {
    super.initState();
    _alerts = List.of(ref.read(p2pSuspiciousActivityProvider).alerts);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pSuspiciousActivityProvider);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final unreviewedCount = _alerts.where((alert) => !alert.reviewed).length;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-258 P2PSuspiciousActivityPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: 'Suspicious Activity',
            subtitle: 'An toàn · P2P',
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
          ),
          child: VitPageContent(
            padding: VitContentPadding.none,
            fullBleed: true,
            customGap: 0,
            children: [
              Expanded(
                child: RefreshIndicator(
                  color: AppModuleAccents.p2p,
                  backgroundColor: AppColors.surface2,
                  onRefresh: () async {
                    HapticFeedback.selectionClick();
                    await Future<void>.delayed(
                      const Duration(milliseconds: 120),
                    );
                  },
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(
                      context,
                    ).copyWith(scrollbars: false),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: EdgeInsets.fromLTRB(
                        AppSpacing.contentPad,
                        AppSpacing.x4,
                        AppSpacing.contentPad,
                        bottomInset,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SummaryCard(
                            unreviewedCount: unreviewedCount,
                            subtitle: snapshot.summarySubtitle,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                          if (_alerts.isEmpty)
                            _EmptyState(snapshot: snapshot)
                          else
                            _AlertList(
                              alerts: _alerts,
                              onDismiss: _markReviewed,
                            ),
                          const SizedBox(height: AppSpacing.x3),
                          const VitCard(
                            variant: VitCardVariant.inner,
                            padding: EdgeInsets.all(AppSpacing.x3),
                            child: VitHighRiskStatePanel(
                              state: VitHighRiskUiState.riskReview,
                              title: 'Suspicious activity review',
                              message:
                                  'Alert severity, reviewed state, dismissal action, account risk and next security step are reviewed before clearing alerts.',
                              contractId: 'p2p-suspicious-activity-review',
                            ),
                          ),
                        ],
                      ),
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

  void _markReviewed(String alertId) {
    HapticFeedback.selectionClick();
    setState(() {
      _alerts = [
        for (final alert in _alerts)
          if (alert.id == alertId) alert.copyWith(reviewed: true) else alert,
      ];
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.unreviewedCount, required this.subtitle});

  final int unreviewedCount;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSuspiciousActivityPage.summaryKey,
      radius: VitCardRadius.lg,
      borderColor: AppColors.warningBorder,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: AppColors.warn.withValues(alpha: .18),
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: AppColors.warn,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$unreviewedCount cảnh báo mới',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.warn,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  subtitle,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertList extends StatelessWidget {
  const _AlertList({required this.alerts, required this.onDismiss});

  final List<P2PSuspiciousAlertDraft> alerts;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PSuspiciousActivityPage.alertsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < alerts.length; index++) ...[
          _AlertCard(alert: alerts[index], onDismiss: onDismiss),
          if (index != alerts.length - 1) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onDismiss});

  final P2PSuspiciousAlertDraft alert;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    final color = _severityColor(alert.severity);

    return VitCard(
      key: P2PSuspiciousActivityPage.alertKey(alert.id),
      radius: VitCardRadius.lg,
      borderColor: alert.reviewed ? null : color,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.inputHeight,
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: Icon(Icons.warning_amber_rounded, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.message,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 11,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      alert.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
                if (alert.reviewed) ...[
                  const SizedBox(height: AppSpacing.x2),
                  const _ReviewedBadge(),
                ],
              ],
            ),
          ),
          if (!alert.reviewed)
            _DismissButton(alertId: alert.id, onDismiss: onDismiss),
        ],
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.alertId, required this.onDismiss});

  final String alertId;
  final ValueChanged<String> onDismiss;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: 32,
      child: IconButton(
        key: P2PSuspiciousActivityPage.dismissKey(alertId),
        onPressed: () => onDismiss(alertId),
        padding: EdgeInsets.zero,
        icon: const Icon(
          Icons.close_rounded,
          color: AppColors.text3,
          size: AppSpacing.iconSm,
        ),
      ),
    );
  }
}

class _ReviewedBadge extends StatelessWidget {
  const _ReviewedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.buy.withValues(alpha: .14),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          'Đã xem lại',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.buy,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.snapshot});

  final P2PSuspiciousActivitySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PSuspiciousActivityPage.emptyKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        children: [
          const Icon(
            Icons.shield_outlined,
            color: AppColors.buy,
            size: AppSpacing.iconLg,
          ),
          const SizedBox(height: AppSpacing.x3),
          Text(
            snapshot.emptyTitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.baseMedium.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Color _severityColor(String severity) {
  return switch (severity) {
    'high' => AppColors.sell,
    'medium' => AppColors.warn,
    _ => AppModuleAccents.p2p,
  };
}
