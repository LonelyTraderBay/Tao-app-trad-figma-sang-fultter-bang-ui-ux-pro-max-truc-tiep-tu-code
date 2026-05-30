part of '../pages/launchpad_page.dart';

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
