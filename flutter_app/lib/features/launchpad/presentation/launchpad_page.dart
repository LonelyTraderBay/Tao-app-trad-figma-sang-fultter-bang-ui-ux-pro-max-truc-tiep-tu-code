import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/launchpad_repository.dart';

class LaunchpadPage extends ConsumerStatefulWidget {
  const LaunchpadPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc295_launchpad_content');
  static const heroKey = Key('sc295_launchpad_hero');
  static const filterActionKey = Key('sc295_launchpad_filter');
  static const performanceActionKey = Key('sc295_launchpad_performance');
  static const portfolioActionKey = Key('sc295_launchpad_portfolio');
  static const tabsKey = Key('sc295_launchpad_tabs');
  static const stakingKey = Key('sc295_launchpad_staking');
  static const advancedToolsKey = Key('sc295_launchpad_advanced_tools');
  static const riskToolsKey = Key('sc295_launchpad_risk_tools');
  static const safetyKey = Key('sc295_launchpad_safety');

  static Key projectKey(String id) => Key('sc295_launchpad_project_$id');
  static Key tabKey(String id) => Key('sc295_launchpad_tab_$id');
  static Key toolKey(String id) => Key('sc295_launchpad_tool_$id');
  static Key joinKey(String id) => Key('sc295_launchpad_join_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LaunchpadPage> createState() => _LaunchpadPageState();
}

class _LaunchpadPageState extends ConsumerState<LaunchpadPage> {
  var _activeTab = _LaunchpadTab.all;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(launchpadRepositoryProvider).getHome();
    final projects = _projectsFor(snapshot.projects, _activeTab);
    final activeCount = snapshot.projects
        .where((project) => project.status == LaunchpadProjectStatus.active)
        .length;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-295 LaunchpadPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(snapshot.backRoute),
              trailing: _HeaderActions(snapshot: snapshot),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: LaunchpadPage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.defaultPadding,
                    customGap: AppSpacing.x4,
                    children: [
                      _HeroCard(activeCount: activeCount),
                      _LaunchpadTabs(
                        activeTab: _activeTab,
                        onChanged: (tab) => setState(() => _activeTab = tab),
                      ),
                      for (final project in projects)
                        _ProjectCard(project: project),
                      _StakingEntry(route: snapshot.stakingRoute),
                      _ToolSection(
                        key: LaunchpadPage.advancedToolsKey,
                        title: 'Công cụ nâng cao',
                        tools: snapshot.advancedTools,
                      ),
                      _ToolSection(
                        key: LaunchpadPage.riskToolsKey,
                        title: 'Trading & Risk Management',
                        tools: snapshot.riskTools,
                      ),
                      const _SafetyWarning(),
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
}

class _HeaderActions extends StatelessWidget {
  const _HeaderActions({required this.snapshot});

  final LaunchpadHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        VitIconButton(
          key: LaunchpadPage.filterActionKey,
          icon: Icons.tune_rounded,
          tooltip: 'Bộ lọc',
          size: VitIconButtonSize.md,
          onPressed: HapticFeedback.selectionClick,
        ),
        const SizedBox(width: AppSpacing.x2),
        VitIconButton(
          key: LaunchpadPage.performanceActionKey,
          icon: Icons.bar_chart_rounded,
          tooltip: 'Hiệu suất',
          size: VitIconButtonSize.md,
          onPressed: () => context.go(snapshot.performanceRoute),
        ),
        const SizedBox(width: AppSpacing.x2),
        VitIconButton(
          key: LaunchpadPage.portfolioActionKey,
          icon: Icons.business_center_outlined,
          tooltip: 'Portfolio',
          size: VitIconButtonSize.md,
          onPressed: () => context.go(snapshot.portfolioRoute),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.activeCount});

  final int activeCount;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadPage.heroKey,
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      borderColor: AppModuleAccents.launchpad.withValues(alpha: .24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: AppSpacing.x7,
                height: AppSpacing.x7,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.accent12,
                  border: Border.all(color: AppColors.accent30),
                  borderRadius: AppRadii.lgRadius,
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: AppColors.accent,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'VitLaunch',
                      style: AppTextStyles.sectionTitle.copyWith(
                        color: AppColors.text1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      'Ra mắt token an toàn & uy tín',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.portfolioTextDim,
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
              const Expanded(
                child: _HeroMetric(
                  icon: Icons.rocket_launch_outlined,
                  label: 'Dự án',
                  value: '47',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              const Expanded(
                child: _HeroMetric(
                  icon: Icons.groups_2_outlined,
                  label: 'Người tham gia',
                  value: '280K+',
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: _HeroMetric(
                  icon: Icons.trending_up_rounded,
                  label: 'Đang hoạt động',
                  value: '$activeCount',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Hiệu suất quá khứ không đảm bảo kết quả tương lai. Nghiên cứu kỹ trước khi tham gia.',
            textAlign: TextAlign.center,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCardStat(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x4,
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.accent, size: AppSpacing.iconSm),
          const SizedBox(height: AppSpacing.x2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.baseMedium.copyWith(
              color: AppColors.text1,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.portfolioTextMuted,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }
}

class _LaunchpadTabs extends StatelessWidget {
  const _LaunchpadTabs({required this.activeTab, required this.onChanged});

  final _LaunchpadTab activeTab;
  final ValueChanged<_LaunchpadTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      key: LaunchpadPage.tabsKey,
      spacing: AppSpacing.x3,
      runSpacing: AppSpacing.x3,
      children: [
        for (final tab in _LaunchpadTab.values)
          InkWell(
            key: LaunchpadPage.tabKey(tab.id),
            onTap: () => onChanged(tab),
            borderRadius: AppRadii.inputRadius,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 160),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x4,
                vertical: AppSpacing.x3,
              ),
              decoration: BoxDecoration(
                color: tab == activeTab
                    ? AppColors.primary12
                    : AppColors.surface2,
                border: Border.all(
                  color: tab == activeTab
                      ? AppColors.primary30
                      : AppColors.cardBorder,
                ),
                borderRadius: AppRadii.inputRadius,
              ),
              child: Text(
                tab.label,
                style: AppTextStyles.caption.copyWith(
                  color: tab == activeTab ? AppColors.primary : AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final typeStyle = _typeStyle(project.type);
    final statusStyle = _statusStyle(project.status);
    return VitCard(
      key: LaunchpadPage.projectKey(project.id),
      radius: VitCardRadius.md,
      clip: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => context.go(AppRoutePaths.launchpadSample),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.x4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProjectAvatar(project: project),
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
                                  project.name,
                                  style: AppTextStyles.baseMedium.copyWith(
                                    fontWeight: AppTextStyles.bold,
                                    height: 1.15,
                                  ),
                                ),
                                _MiniPill(
                                  label: typeStyle.label,
                                  color: typeStyle.color,
                                  background: typeStyle.background,
                                ),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.x1),
                            _InlineIconLabel(
                              icon: Icons.circle,
                              label: statusStyle.label,
                              color: statusStyle.color,
                            ),
                          ],
                        ),
                      ),
                      if (project.roi != null) ...[
                        const SizedBox(width: AppSpacing.x2),
                        _RoiBadge(value: project.roi!),
                      ],
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x4),
                  Text(
                    project.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  Wrap(
                    spacing: AppSpacing.x2,
                    runSpacing: AppSpacing.x2,
                    children: [
                      for (final tag in project.tags)
                        _SoftChip(label: tag, color: AppColors.text2),
                      _SoftChip(label: project.chain, color: project.accent),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.x3),
                  _ProjectInfoGrid(project: project),
                  if (project.status != LaunchpadProjectStatus.upcoming) ...[
                    const SizedBox(height: AppSpacing.x4),
                    _ProjectProgress(project: project),
                  ],
                  const SizedBox(height: AppSpacing.x3),
                  _TimelineLine(project: project),
                  const SizedBox(height: AppSpacing.x3),
                  _ProjectBadges(project: project),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.x4,
              0,
              AppSpacing.x4,
              AppSpacing.x4,
            ),
            child: _ProjectActions(project: project),
          ),
        ],
      ),
    );
  }
}

class _ProjectAvatar extends StatelessWidget {
  const _ProjectAvatar({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x7,
      height: AppSpacing.x7,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: project.accent.withValues(alpha: .12),
        border: Border.all(color: project.accent.withValues(alpha: .35)),
        borderRadius: AppRadii.lgRadius,
      ),
      child: Text(
        project.logo,
        style: AppTextStyles.baseMedium.copyWith(
          color: project.accent,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ProjectInfoGrid extends StatelessWidget {
  const _ProjectInfoGrid({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Giá token', '\$${_formatPrice(project.price)} ${project.priceUnit}'),
      ('Hard Cap', project.hardCap),
      ('Đã huy động', project.totalRaise),
      (
        'Người tham gia',
        project.participants == 0 ? '—' : _formatInt(project.participants),
      ),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: rows[0].$1, value: rows[0].$2),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _InfoTile(label: rows[1].$1, value: rows[1].$2),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        Row(
          children: [
            Expanded(
              child: _InfoTile(label: rows[2].$1, value: rows[2].$2),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: _InfoTile(label: rows[3].$1, value: rows[3].$2),
            ),
          ],
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
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
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectProgress extends StatelessWidget {
  const _ProjectProgress({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    final complete = project.progress >= 100;
    final color = complete ? AppColors.buy : project.accent;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tiến trình',
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              '${project.progress}%',
              style: AppTextStyles.micro.copyWith(
                color: complete ? AppColors.buy : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x2),
        ClipRRect(
          borderRadius: AppRadii.xsRadius,
          child: SizedBox(
            height: AppSpacing.x2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                const ColoredBox(color: AppColors.surface3),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: (project.progress / 100).clamp(0.0, 1.0),
                  child: ColoredBox(color: color),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TimelineLine extends StatelessWidget {
  const _TimelineLine({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    if (project.status == LaunchpadProjectStatus.upcoming) {
      return const _InlineIconLabel(
        icon: Icons.schedule_rounded,
        label: 'Bắt đầu sau',
        color: AppColors.warn,
      );
    }
    if (project.status == LaunchpadProjectStatus.active) {
      return const _InlineIconLabel(
        icon: Icons.check_circle_outline_rounded,
        label: 'Đã kết thúc',
        color: AppColors.buy,
      );
    }
    return _InlineIconLabel(
      icon: Icons.schedule_rounded,
      label: 'Đã kết thúc: ${project.endDate}',
      color: AppColors.text3,
    );
  }
}

class _ProjectBadges extends StatelessWidget {
  const _ProjectBadges({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.x2,
      runSpacing: AppSpacing.x2,
      children: [
        if (project.kyc)
          _Badge(
            icon: Icons.verified_user_outlined,
            label: 'KYC cấp ${project.kycLevel}',
            color: AppColors.buy,
            background: AppColors.buy10,
          ),
        if (project.whitelist)
          const _Badge(
            icon: Icons.workspace_premium_outlined,
            label: 'Whitelist',
            color: AppColors.warn,
            background: AppColors.warn10,
          ),
        if (project.auditStatus == LaunchpadAuditStatus.passed)
          _Badge(
            icon: Icons.military_tech_outlined,
            label: project.audit,
            color: AppColors.primary,
            background: AppColors.primary12,
          ),
      ],
    );
  }
}

class _ProjectActions extends StatelessWidget {
  const _ProjectActions({required this.project});

  final LaunchpadProjectDraft project;

  @override
  Widget build(BuildContext context) {
    if (project.status == LaunchpadProjectStatus.active) {
      return Row(
        children: [
          Expanded(
            child: _GhostButton(
              label: 'Chi tiết',
              icon: Icons.chevron_right_rounded,
              onTap: () => context.go(AppRoutePaths.launchpadSample),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitCtaButton(
              key: LaunchpadPage.joinKey(project.id),
              onPressed: HapticFeedback.selectionClick,
              leading: const Icon(Icons.rocket_launch_outlined),
              child: const Text('Tham gia'),
            ),
          ),
        ],
      );
    }

    final isUpcoming = project.status == LaunchpadProjectStatus.upcoming;
    return _GhostButton(
      label: 'Xem chi tiết',
      icon: isUpcoming ? Icons.schedule_rounded : Icons.chevron_right_rounded,
      onTap: () => context.go(AppRoutePaths.launchpadSample),
      color: isUpcoming ? AppColors.warn : AppColors.text2,
      background: isUpcoming ? AppColors.warn08 : AppColors.surface2,
      border: isUpcoming ? AppColors.warningBorder : AppColors.cardBorder,
    );
  }
}

class _StakingEntry extends StatelessWidget {
  const _StakingEntry({required this.route});

  final String route;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: LaunchpadPage.stakingKey,
      radius: VitCardRadius.md,
      borderColor: AppColors.buy20,
      onTap: () => context.go(route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.buy10,
              borderRadius: AppRadii.lgRadius,
            ),
            child: const Icon(
              Icons.savings_outlined,
              color: AppColors.buy,
              size: AppSpacing.iconMd,
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Launchpool Staking',
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  'Stake token để nhận phần thưởng dự án mới',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconMd,
          ),
        ],
      ),
    );
  }
}

class _ToolSection extends StatelessWidget {
  const _ToolSection({super.key, required this.title, required this.tools});

  final String title;
  final List<LaunchpadToolDraft> tools;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: title,
      accentColor: AppModuleAccents.launchpad,
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: 1.72,
          padding: EdgeInsets.zero,
          children: [
            for (final tool in tools)
              _ToolTile(key: LaunchpadPage.toolKey(tool.id), tool: tool),
          ],
        ),
      ],
    );
  }
}

class _ToolTile extends StatelessWidget {
  const _ToolTile({super.key, required this.tool});

  final LaunchpadToolDraft tool;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.sm,
      borderColor: tool.accent.withValues(alpha: .18),
      onTap: () => context.go(tool.route),
      padding: const EdgeInsets.all(AppSpacing.x3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSpacing.x6,
            height: AppSpacing.x6,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: tool.accent.withValues(alpha: .12),
              borderRadius: AppRadii.mdRadius,
            ),
            child: Icon(
              _toolIcon(tool.iconKey),
              color: tool.accent,
              size: AppSpacing.iconMd,
            ),
          ),
          const Spacer(),
          Text(
            tool.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          Text(
            tool.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _SafetyWarning extends StatelessWidget {
  const _SafetyWarning();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: LaunchpadPage.safetyKey,
      padding: const EdgeInsets.all(AppSpacing.x4),
      decoration: BoxDecoration(
        color: AppColors.sell10,
        border: Border.all(color: AppColors.sell20),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: AppColors.sell,
            size: AppSpacing.iconMd,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảnh báo an toàn',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.sell,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'Chỉ tham gia qua app chính thức. Không gửi token cho bất kỳ ai yêu cầu. Kiểm tra contract address trước khi tương tác.',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _GhostButton extends StatelessWidget {
  const _GhostButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.color = AppColors.text2,
    this.background = AppColors.surface2,
    this.border = AppColors.cardBorder,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        height: AppSpacing.ctaHeight,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: border),
          borderRadius: AppRadii.inputRadius,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: AppSpacing.iconMd),
            const SizedBox(width: AppSpacing.x2),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1.1,
        ),
      ),
    );
  }
}

class _SoftChip extends StatelessWidget {
  const _SoftChip({required this.label, required this.color});

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
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(color: color, height: 1.25),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.lgRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: AppSpacing.iconSm),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.medium,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineIconLabel extends StatelessWidget {
  const _InlineIconLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: AppSpacing.iconSm),
        const SizedBox(width: AppSpacing.x2),
        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _RoiBadge extends StatelessWidget {
  const _RoiBadge({required this.value});

  final int value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x2,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '+$value%',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.buy,
              fontWeight: FontWeight.w800,
              fontFeatures: AppTextStyles.tabularFigures,
              height: 1,
            ),
          ),
          Text(
            'ROI',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }
}

enum _LaunchpadTab {
  all('all', 'Tất cả'),
  active('active', 'Đang mở'),
  upcoming('upcoming', 'Sắp tới'),
  ended('ended', 'Đã kết thúc');

  const _LaunchpadTab(this.id, this.label);

  final String id;
  final String label;
}

final class _LabelStyle {
  const _LabelStyle({
    required this.label,
    required this.color,
    required this.background,
  });

  final String label;
  final Color color;
  final Color background;
}

List<LaunchpadProjectDraft> _projectsFor(
  List<LaunchpadProjectDraft> projects,
  _LaunchpadTab tab,
) {
  final status = switch (tab) {
    _LaunchpadTab.all => null,
    _LaunchpadTab.active => LaunchpadProjectStatus.active,
    _LaunchpadTab.upcoming => LaunchpadProjectStatus.upcoming,
    _LaunchpadTab.ended => LaunchpadProjectStatus.ended,
  };
  if (status == null) return projects;
  return projects.where((project) => project.status == status).toList();
}

_LabelStyle _typeStyle(LaunchpadProjectType type) {
  return switch (type) {
    LaunchpadProjectType.ieo => const _LabelStyle(
      label: 'IEO',
      color: AppColors.primary,
      background: AppColors.primary12,
    ),
    LaunchpadProjectType.ido => const _LabelStyle(
      label: 'IDO',
      color: AppColors.accent,
      background: AppColors.accent12,
    ),
    LaunchpadProjectType.launchpool => const _LabelStyle(
      label: 'Launchpool',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
  };
}

_LabelStyle _statusStyle(LaunchpadProjectStatus status) {
  return switch (status) {
    LaunchpadProjectStatus.upcoming => const _LabelStyle(
      label: 'Sắp diễn ra',
      color: AppColors.warn,
      background: AppColors.warn10,
    ),
    LaunchpadProjectStatus.active => const _LabelStyle(
      label: 'Đang diễn ra',
      color: AppColors.buy,
      background: AppColors.buy10,
    ),
    LaunchpadProjectStatus.ended => const _LabelStyle(
      label: 'Đã kết thúc',
      color: AppColors.text2,
      background: AppColors.surface2,
    ),
  };
}

IconData _toolIcon(String key) {
  return switch (key) {
    'bell' => Icons.notifications_none_rounded,
    'event' => Icons.receipt_long_outlined,
    'compare' => Icons.compare_arrows_rounded,
    'book' => Icons.menu_book_outlined,
    'webhook' => Icons.hub_outlined,
    'fuel' => Icons.local_gas_station_outlined,
    'pie' => Icons.donut_large_rounded,
    'lock' => Icons.lock_outline_rounded,
    'swap' => Icons.swap_horiz_rounded,
    'clock' => Icons.schedule_rounded,
    'money' => Icons.attach_money_rounded,
    'shield' => Icons.shield_outlined,
    _ => Icons.apps_rounded,
  };
}

String _formatPrice(double value) {
  if (value < 0.01) return value.toStringAsFixed(3);
  return value.toStringAsFixed(2);
}

String _formatInt(int value) {
  final raw = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i++) {
    final fromEnd = raw.length - i;
    buffer.write(raw[i]);
    if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write(',');
  }
  return buffer.toString();
}
