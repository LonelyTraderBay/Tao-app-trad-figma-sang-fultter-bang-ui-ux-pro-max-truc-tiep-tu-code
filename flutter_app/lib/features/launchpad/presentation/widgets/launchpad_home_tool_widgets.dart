part of '../pages/launchpad_page.dart';

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
