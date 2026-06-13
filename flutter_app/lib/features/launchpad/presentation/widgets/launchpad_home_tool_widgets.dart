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
            width: AppSpacing.launchpadBox48,
            height: AppSpacing.launchpadBox48,
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
          crossAxisCount: AppSpacing.launchpadGridColumns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.x3,
          crossAxisSpacing: AppSpacing.x3,
          childAspectRatio: AppSpacing.launchpadGridAspectTile,
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
              height: AppSpacing.launchpadLineHeightShort,
            ),
          ),
          Text(
            tool.description,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.chartLabelXs.copyWith(
              color: AppColors.text3,
              height: AppSpacing.launchpadLineHeightShort,
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
                    height: AppSpacing.launchpadLineHeightReadable,
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
