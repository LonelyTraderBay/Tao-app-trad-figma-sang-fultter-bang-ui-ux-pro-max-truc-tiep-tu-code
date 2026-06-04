import 'package:flutter/material.dart';
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
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PAmlScreeningPage extends ConsumerWidget {
  const P2PAmlScreeningPage({super.key, this.shellRenderMode});

  static const heroKey = Key('sc268_p2p_aml_hero');
  static const scheduleKey = Key('sc268_p2p_aml_schedule');
  static const checksKey = Key('sc268_p2p_aml_checks');
  static const infoKey = Key('sc268_p2p_aml_info');

  static Key checkKey(String id) => Key('sc268_p2p_aml_check_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pAmlScreeningProvider);
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-268 P2PAMLScreeningPage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: VitHeader(
            title: snapshot.title,
            subtitle: snapshot.subtitle,
            showBack: true,
            onBack: () => context.go(snapshot.parentRoute),
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
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.contentPad,
                      AppSpacing.x4,
                      AppSpacing.contentPad,
                      bottomInset,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _AmlHero(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        _AmlSchedule(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x6),
                        Text(
                          'Chi tiết kiểm tra',
                          style: AppTextStyles.baseMedium.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x3),
                        _AmlCheckList(checks: snapshot.checks),
                        const SizedBox(height: AppSpacing.x5),
                        _AmlInfoNotice(snapshot: snapshot),
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
}

class _AmlHero extends StatelessWidget {
  const _AmlHero({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PAmlScreeningPage.heroKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.buy,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppColors.buy),
      ),
      child: Row(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.onAccent.withValues(alpha: .20),
              borderRadius: AppRadii.lgRadius,
            ),
            child: const SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                Icons.shield_outlined,
                color: AppColors.onAccent,
                size: AppSpacing.iconMd,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.statusLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.onAccent,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.statusDescription,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.onAccent.withValues(alpha: .90),
                    fontWeight: AppTextStyles.bold,
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

class _AmlSchedule extends StatelessWidget {
  const _AmlSchedule({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAmlScreeningPage.scheduleKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Expanded(
            child: _ScheduleMetric(
              label: snapshot.lastCheckLabel,
              value: snapshot.lastCheckAt,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: _ScheduleMetric(
              label: snapshot.nextCheckLabel,
              value: snapshot.nextCheckAt,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleMetric extends StatelessWidget {
  const _ScheduleMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontSize: 12,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _AmlCheckList extends StatelessWidget {
  const _AmlCheckList({required this.checks});

  final List<P2PAmlCheckDraft> checks;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PAmlScreeningPage.checksKey,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.zero,
      clip: true,
      child: Column(
        children: [
          for (var index = 0; index < checks.length; index++) ...[
            _AmlCheckRow(check: checks[index]),
            if (index != checks.length - 1)
              const Divider(height: 1, color: AppColors.borderSolid),
          ],
        ],
      ),
    );
  }
}

class _AmlCheckRow extends StatelessWidget {
  const _AmlCheckRow({required this.check});

  final P2PAmlCheckDraft check;

  @override
  Widget build(BuildContext context) {
    final config = _statusConfig(check.status);

    return Padding(
      key: P2PAmlScreeningPage.checkKey(check.id),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: config.color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                config.icon,
                color: config.color,
                size: AppSpacing.iconMd,
              ),
            ),
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
                        check.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    VitStatusPill(
                      label: config.label,
                      status: config.pillStatus,
                      size: VitStatusPillSize.sm,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  check.detail,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
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

class _AmlInfoNotice extends StatelessWidget {
  const _AmlInfoNotice({required this.snapshot});

  final P2PAmlScreeningSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: P2PAmlScreeningPage.infoKey,
      padding: const EdgeInsets.all(AppSpacing.x3),
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p.withValues(alpha: .10),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: AppModuleAccents.p2p.withValues(alpha: .24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.description_outlined,
            color: AppModuleAccents.p2p,
            size: 16,
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppModuleAccents.p2p,
                    fontWeight: AppTextStyles.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  snapshot.infoBody,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.5,
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

_AmlStatusConfig _statusConfig(String status) {
  return switch (status) {
    'review' => const _AmlStatusConfig(
      color: AppColors.warn,
      icon: Icons.schedule_rounded,
      label: 'Review',
      pillStatus: VitStatusPillStatus.warning,
    ),
    'fail' => const _AmlStatusConfig(
      color: AppColors.sell,
      icon: Icons.warning_amber_rounded,
      label: 'Fail',
      pillStatus: VitStatusPillStatus.error,
    ),
    'pass' => const _AmlStatusConfig(
      color: AppColors.buy,
      icon: Icons.check_circle_outline_rounded,
      label: 'Pass',
      pillStatus: VitStatusPillStatus.success,
    ),
    _ => const _AmlStatusConfig(
      color: AppColors.text3,
      icon: Icons.description_outlined,
      label: 'N/A',
      pillStatus: VitStatusPillStatus.neutral,
    ),
  };
}

final class _AmlStatusConfig {
  const _AmlStatusConfig({
    required this.color,
    required this.icon,
    required this.label,
    required this.pillStatus,
  });

  final Color color;
  final IconData icon;
  final String label;
  final VitStatusPillStatus pillStatus;
}
