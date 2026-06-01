import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/providers/dev_tools_controller_providers.dart';
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

part '../widgets/performance_monitor_sections.dart';
part '../widgets/performance_monitor_common.dart';

class PerformanceMonitor extends ConsumerWidget {
  const PerformanceMonitor({super.key, this.shellRenderMode});

  static const contentKey = Key('sc326_performance_monitor_content');

  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(performanceMonitorControllerProvider).snapshot();
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-326 PerformanceMonitor',
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
                key: PerformanceMonitor.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    _PerformanceScoreCard(snapshot: snapshot),
                    VitPageSection(
                      label: 'Core Web Vitals',
                      children: [_VitalsCard(metrics: snapshot.vitals)],
                    ),
                    VitPageSection(
                      label: 'Memory Usage',
                      children: [_MemoryCard(memory: snapshot.memory)],
                    ),
                    VitPageSection(
                      label: 'Lazy Loaded Chunks',
                      children: [_LazyChunksCard(chunks: snapshot.lazyChunks)],
                    ),
                    VitPageSection(
                      label: 'Top 10 Slowest Resources',
                      children: [_ResourcesCard(resources: snapshot.resources)],
                    ),
                    VitPageSection(
                      label: 'Optimization Tips',
                      children: [
                        for (final tip in snapshot.tips) _TipCard(tip: tip),
                      ],
                    ),
                    _TargetsCard(targets: snapshot.targets),
                    _InternalNotice(text: snapshot.contractNotes),
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
