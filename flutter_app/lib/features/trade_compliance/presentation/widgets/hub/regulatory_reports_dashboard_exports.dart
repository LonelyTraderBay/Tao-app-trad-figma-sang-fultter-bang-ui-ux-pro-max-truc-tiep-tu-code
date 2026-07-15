part of '../../pages/hub/regulatory_reports_dashboard_page.dart';

class _ExportsTab extends StatelessWidget {
  const _ExportsTab({required this.onNotice});

  final ValueChanged<String> onNotice;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Export Reports',
      density: VitDensity.compact,
      children: [
        _ExportCard(
          title: 'ISO 20022 XML Export',
          subtitle: 'Standard regulatory format',
          icon: Icons.description_outlined,
          color: _dashPrimary,
          onTap: () => onNotice('XML export queued'),
        ),
        _ExportCard(
          title: 'Compliance Report (PDF)',
          subtitle: 'Executive summary',
          icon: Icons.bar_chart_rounded,
          color: _dashGreen,
          onTap: () => onNotice('PDF export queued'),
        ),
        _ExportCard(
          title: 'Raw Data Export (CSV)',
          subtitle: 'All fields, all reports',
          icon: Icons.storage_outlined,
          color: _dashAmber,
          onTap: () => onNotice('CSV export queued'),
        ),
      ],
    );
  }
}

class _ExportCard extends StatelessWidget {
  const _ExportCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeBotInnerPanelPadding,
      borderColor: _dashBorder.withValues(alpha: .7),
      onTap: onTap,
      child: Row(
        children: [
          // card-tile: allow-start — fixed surface, not horizontal strip tile
          VitCard(
            variant: VitCardVariant.ghost,
            width: TradeSpacingTokens.tradeBotQuestionIconBox,
            height: TradeSpacingTokens.tradeBotQuestionIconBox,
            alignment: Alignment.center,
            borderColor: color.withValues(alpha: .18),
            child: Icon(
              icon,
              color: color,
              size: TradeSpacingTokens.tradeBotActionIcon,
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: VitPageContent(
              rhythm: VitPageRhythm.standard,
              padding: VitContentPadding.none,
              density: VitDensity.compact,
              children: [
                Text(
                  title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.download_rounded,
            color: AppColors.text3,
            size: TradeSpacingTokens.tradeBotActionIcon,
          ),
        ],
      ),
    );
  }
}
