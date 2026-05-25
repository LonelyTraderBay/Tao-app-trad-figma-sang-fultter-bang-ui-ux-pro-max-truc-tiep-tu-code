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
import '../data/dev_tools_repository.dart';

class RouteChecker extends ConsumerStatefulWidget {
  const RouteChecker({super.key, this.shellRenderMode});

  static const contentKey = Key('sc325_route_checker_content');
  static const resetButtonKey = Key('sc325_route_checker_reset');
  static Key phaseKey(int? phase) => Key('sc325_phase_${phase ?? 'all'}');
  static Key routeKey(String path) => Key('sc325_route_$path');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RouteChecker> createState() => _RouteCheckerState();
}

class _RouteCheckerState extends ConsumerState<RouteChecker> {
  final Set<String> _testedRoutes = {};
  int? _activePhase;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(routeCheckerRepositoryProvider)
        .getRouteChecker();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x7
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x5) +
        MediaQuery.paddingOf(context).bottom;
    final filteredRoutes = _activePhase == null
        ? snapshot.routes
        : snapshot.routes
              .where((route) => route.phase == _activePhase)
              .toList();

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-325 RouteChecker',
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
                key: RouteChecker.contentKey,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.only(bottom: bottomInset),
                child: VitPageContent(
                  gap: VitContentGap.defaultGap,
                  children: [
                    _IntroBlock(snapshot: snapshot),
                    _ProgressCard(
                      testedCount: _testedRoutes.length,
                      totalCount: snapshot.totalRoutes,
                    ),
                    _PhaseFilters(
                      snapshot: snapshot,
                      activePhase: _activePhase,
                      onChanged: (phase) {
                        HapticFeedback.selectionClick();
                        setState(() => _activePhase = phase);
                      },
                    ),
                    _RouteList(
                      routes: filteredRoutes,
                      testedRoutes: _testedRoutes,
                      onTapRoute: (route) {
                        HapticFeedback.selectionClick();
                        setState(() => _testedRoutes.add(route.path));
                      },
                    ),
                    _ActionsRow(
                      testedCount: _testedRoutes.length,
                      totalCount: snapshot.totalRoutes,
                      onReset: () {
                        HapticFeedback.selectionClick();
                        setState(_testedRoutes.clear);
                      },
                    ),
                    _PhaseStats(
                      snapshot: snapshot,
                      testedRoutes: _testedRoutes,
                    ),
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

class _IntroBlock extends StatelessWidget {
  const _IntroBlock({required this.snapshot});

  final RouteCheckerSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const _IconBadge(
              icon: Icons.science_outlined,
              color: AppColors.buy,
              background: AppColors.buy10,
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                snapshot.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          snapshot.subtitle,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
      ],
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.testedCount, required this.totalCount});

  final int testedCount;
  final int totalCount;

  @override
  Widget build(BuildContext context) {
    final progress = totalCount == 0 ? 0.0 : testedCount / totalCount;

    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Testing Progress',
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
              ),
              Text(
                '$testedCount / $totalCount',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          ClipRRect(
            borderRadius: AppRadii.xlRadius,
            child: ColoredBox(
              color: AppColors.surface2,
              child: SizedBox(
                height: AppSpacing.x3,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FractionallySizedBox(
                    widthFactor: progress.clamp(0, 1),
                    child: const ColoredBox(color: AppColors.buy),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhaseFilters extends StatelessWidget {
  const _PhaseFilters({
    required this.snapshot,
    required this.activePhase,
    required this.onChanged,
  });

  final RouteCheckerSnapshot snapshot;
  final int? activePhase;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _PhaseChip(
            key: RouteChecker.phaseKey(null),
            label: 'All (${snapshot.totalRoutes})',
            selected: activePhase == null,
            onTap: () => onChanged(null),
          ),
          const SizedBox(width: AppSpacing.x3),
          for (final phase in snapshot.phases) ...[
            _PhaseChip(
              key: RouteChecker.phaseKey(phase),
              label: 'Phase $phase (${snapshot.phaseTotal(phase)})',
              selected: activePhase == phase,
              onTap: () => onChanged(phase),
            ),
            if (phase != snapshot.phases.last)
              const SizedBox(width: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _PhaseChip extends StatelessWidget {
  const _PhaseChip({
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
    return Material(
      color: selected ? AppColors.primary : AppColors.surface2,
      borderRadius: AppRadii.xlRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.xlRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: selected ? AppColors.navCenterIcon : AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _RouteList extends StatelessWidget {
  const _RouteList({
    required this.routes,
    required this.testedRoutes,
    required this.onTapRoute,
  });

  final List<DevRouteDraft> routes;
  final Set<String> testedRoutes;
  final ValueChanged<DevRouteDraft> onTapRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final route in routes) ...[
          _RouteCard(
            route: route,
            tested: testedRoutes.contains(route.path),
            onTap: () => onTapRoute(route),
          ),
          if (route != routes.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RouteCard extends StatelessWidget {
  const _RouteCard({
    required this.route,
    required this.tested,
    required this.onTap,
  });

  final DevRouteDraft route;
  final bool tested;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: RouteChecker.routeKey(route.path),
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      borderColor: tested ? AppColors.buy20 : AppColors.borderSolid,
      onTap: onTap,
      child: Row(
        children: [
          tested
              ? const Icon(
                  Icons.check_circle_outline_rounded,
                  color: AppColors.buy,
                  size: AppSpacing.iconMd,
                )
              : Container(
                  width: AppSpacing.iconMd,
                  height: AppSpacing.iconMd,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary40),
                  ),
                ),
          const SizedBox(width: AppSpacing.x4),
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
                      route.name,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    if (route.featured) const _FeaturedBadge(),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  route.path,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          _PhaseBadge(phase: route.phase),
          const SizedBox(width: AppSpacing.x3),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
          ),
        ],
      ),
    );
  }
}

class _FeaturedBadge extends StatelessWidget {
  const _FeaturedBadge();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.warn10,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          'FEATURED',
          style: AppTextStyles.micro.copyWith(
            color: AppColors.warn,
            fontWeight: AppTextStyles.bold,
            fontSize: AppSpacing.x3,
          ),
        ),
      ),
    );
  }
}

class _PhaseBadge extends StatelessWidget {
  const _PhaseBadge({required this.phase});

  final int phase;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xlRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x3,
          vertical: AppSpacing.x2,
        ),
        child: Text(
          'Phase $phase',
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({
    required this.testedCount,
    required this.totalCount,
    required this.onReset,
  });

  final int testedCount;
  final int totalCount;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    final complete = testedCount == totalCount;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: AppColors.surface2,
            borderRadius: AppRadii.inputRadius,
            child: InkWell(
              key: RouteChecker.resetButtonKey,
              onTap: onReset,
              borderRadius: AppRadii.inputRadius,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  'Reset Tests',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (complete) ...[
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: AppColors.buy10,
                borderRadius: AppRadii.inputRadius,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
                child: Text(
                  'All Routes Tested',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PhaseStats extends StatelessWidget {
  const _PhaseStats({required this.snapshot, required this.testedRoutes});

  final RouteCheckerSnapshot snapshot;
  final Set<String> testedRoutes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      radius: VitCardRadius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Stats by Phase',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x4),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.x3,
            crossAxisSpacing: AppSpacing.x3,
            childAspectRatio: 1.18,
            children: [
              for (final phase in snapshot.phases)
                _PhaseStatTile(
                  phase: phase,
                  total: snapshot.phaseTotal(phase),
                  tested: snapshot.routes
                      .where(
                        (route) =>
                            route.phase == phase &&
                            testedRoutes.contains(route.path),
                      )
                      .length,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhaseStatTile extends StatelessWidget {
  const _PhaseStatTile({
    required this.phase,
    required this.total,
    required this.tested,
  });

  final int phase;
  final int total;
  final int tested;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : tested / total;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Phase $phase',
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
            const SizedBox(height: AppSpacing.x1),
            Text(
              '$tested/$total',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
            const SizedBox(height: AppSpacing.x2),
            ClipRRect(
              borderRadius: AppRadii.xlRadius,
              child: ColoredBox(
                color: AppColors.bg,
                child: SizedBox(
                  height: AppSpacing.x1,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progress.clamp(0, 1),
                      child: const ColoredBox(color: AppColors.buy),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InternalNotice extends StatelessWidget {
  const _InternalNotice({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primary08,
        border: Border.all(color: AppColors.primary20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x3),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.admin_panel_settings_outlined,
              color: AppColors.primary,
              size: AppSpacing.iconSm,
            ),
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

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x6,
      height: AppSpacing.x6,
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: AppSpacing.iconSm),
    );
  }
}
