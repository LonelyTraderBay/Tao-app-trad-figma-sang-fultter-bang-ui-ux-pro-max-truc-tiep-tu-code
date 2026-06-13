part of 'wallet_page_sections.dart';

class WalletDcaCard extends StatelessWidget {
  const WalletDcaCard({super.key, required this.dca});

  final WalletDcaSnapshot dca;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.homeNextActionCardPadding),
      borderColor: _walletPurple.withValues(alpha: .28),
      child: Column(
        children: [
          Row(
            children: [
              _IconCircle(
                icon: Icons.sync_alt_rounded,
                color: _walletPurple,
                size: AppSpacing.homeNextActionIconContainer,
              ),
              const SizedBox(width: AppSpacing.homeCommandRowSpacing),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            dca.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              color: AppColors.text1,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x1),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.homeSectionHeaderChevronSize,
                            vertical: AppSpacing.x1,
                          ),
                          decoration: BoxDecoration(
                            color: _walletGreen.withValues(alpha: .12),
                            border: Border.all(
                              color: _walletGreen.withValues(alpha: .18),
                            ),
                            borderRadius: AppRadii.mdRadius,
                          ),
                          child: Text(
                            dca.returnLabel,
                            style: AppTextStyles.micro.copyWith(
                              color: _walletGreen,
                              fontFeatures: AppTextStyles.tabularFigures,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      dca.subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ),
              const _IconCircle(
                icon: Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconLg,
                muted: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.rowGapRegular),
          Row(
            children: [
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.sync_alt_rounded,
                  iconColor: _walletPurple,
                  label: 'Kế hoạch đang chạy',
                  value: dca.activePlans.toString(),
                ),
              ),
              const SizedBox(width: AppSpacing.rowGapRegular),
              Expanded(
                child: _DcaStatCard(
                  icon: Icons.trending_up_rounded,
                  iconColor: _walletPrimary,
                  label: 'Đã đầu tư',
                  value: _formatVnd(dca.invested),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            radius: VitCardRadius.md,
            padding: AppSpacing.cardPaddingCompact,
            borderColor: _walletAmber.withValues(alpha: .24),
            child: Row(
              children: [
                _IconCircle(
                  icon: Icons.schedule_rounded,
                  color: _walletAmber,
                  size: AppSpacing.iconLg,
                ),
                const SizedBox(width: AppSpacing.rowGapRegular),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Giao dịch tiếp theo',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.x1),
                      Text(
                        dca.nextTrade,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ],
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

class _DcaStatCard extends StatelessWidget {
  const _DcaStatCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.searchBarHorizontalPadding,
        vertical: AppSpacing.x1,
      ),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: iconColor.withValues(alpha: .18),
      child: Row(
        children: [
          _IconCircle(icon: icon, color: iconColor, size: AppSpacing.iconLg),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.numericMicro.copyWith(
                    color: AppColors.text3,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.amountSm.copyWith(
                    color: AppColors.text1,
                    fontFeatures: AppTextStyles.tabularFigures,
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

class _IconCircle extends StatelessWidget {
  const _IconCircle({
    required this.icon,
    required this.color,
    required this.size,
    this.muted = false,
  });

  final IconData icon;
  final Color color;
  final double size;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: muted
            ? AppColors.dynamicIslandBg.withValues(alpha: .16)
            : color.withValues(alpha: .12),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size * .56),
    );
  }
}

class WalletToolGrid extends StatelessWidget {
  const WalletToolGrid({
    super.key,
    required this.tools,
    required this.onNavigate,
  });

  final List<WalletTool> tools;
  final ValueChanged<String> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var row = 0; row < 2; row++) ...[
          Row(
            children: [
              for (var col = 0; col < 2; col++) ...[
                Expanded(
                  child: _ToolButton(
                    tool: tools[row * 2 + col],
                    onTap: () => onNavigate(tools[row * 2 + col].route),
                  ),
                ),
                if (col == 0) const SizedBox(width: AppSpacing.gridGap),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: AppSpacing.x2),
        ],
      ],
    );
  }
}

class _ToolButton extends StatelessWidget {
  const _ToolButton({required this.tool, required this.onTap});

  final WalletTool tool;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(tool.colorHex);
    return VitCard(
      onTap: onTap,
      height: AppSpacing.searchBarCompactHeight + AppSpacing.x2,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.searchBarHorizontalPadding,
      ),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: color.withValues(alpha: .22),
      child: Row(
        children: [
          Container(
            width: AppSpacing.iconLg,
            height: AppSpacing.iconLg,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _toolIcon(tool.iconKey),
              color: color,
              size: AppSpacing.iconSm,
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Text(
              tool.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
