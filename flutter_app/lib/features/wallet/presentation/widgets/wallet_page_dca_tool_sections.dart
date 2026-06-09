part of 'wallet_page_sections.dart';

class WalletDcaCard extends StatelessWidget {
  const WalletDcaCard({super.key, required this.dca});

  final WalletDcaSnapshot dca;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.standard,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      borderColor: AppColors.cardBorder,
      child: Column(
        children: [
          Row(
            children: [
              _IconCircle(
                icon: Icons.sync_alt_rounded,
                color: _walletPurple,
                size: 37,
              ),
              const SizedBox(width: 13),
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
                              fontSize: 18,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 9),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _walletGreen.withValues(alpha: .12),
                            borderRadius: AppRadii.mdRadius,
                          ),
                          child: Text(
                            dca.returnLabel,
                            style: AppTextStyles.micro.copyWith(
                              color: _walletGreen,
                              fontSize: 11,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dca.subtitle,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontSize: 11,
                        height: 1,
                      ),
                    ),
                  ],
                ),
              ),
              const _IconCircle(
                icon: Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: 34,
                muted: true,
              ),
            ],
          ),
          const SizedBox(height: 24),
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
              const SizedBox(width: 12),
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
          const SizedBox(height: 12),
          Container(
            height: 70,
            padding: const EdgeInsets.fromLTRB(14, 9, 14, 9),
            decoration: BoxDecoration(
              color: _walletPanel,
              border: Border.all(
                color: AppColors.onAccent.withValues(alpha: .24),
              ),
              borderRadius: AppRadii.cardRadius,
            ),
            child: Row(
              children: [
                _IconCircle(
                  icon: Icons.schedule_rounded,
                  color: _walletAmber,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        'Giao dịch tiếp theo',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        dca.nextTrade,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text1,
                          fontSize: 13,
                          fontWeight: AppTextStyles.bold,
                          fontFamily: 'Roboto',
                          height: 1,
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
      height: 72,
      padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: AppColors.borderSolid,
      child: Row(
        children: [
          _IconCircle(icon: icon, color: iconColor, size: 35),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 15,
                    fontWeight: AppTextStyles.bold,
                    fontFamily: 'Roboto',
                    height: 1,
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
                if (col == 0) const SizedBox(width: 8),
              ],
            ],
          ),
          if (row == 0) const SizedBox(height: 8),
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
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.cardBorder,
      child: Row(
        children: [
          Icon(_toolIcon(tool.iconKey), color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tool.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                fontSize: 11,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
