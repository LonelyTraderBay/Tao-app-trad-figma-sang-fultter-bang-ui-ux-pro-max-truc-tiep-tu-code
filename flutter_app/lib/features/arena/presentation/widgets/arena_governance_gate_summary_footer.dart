part of '../pages/arena_governance_gate_page.dart';

class _GovernanceSummary extends StatelessWidget {
  const _GovernanceSummary({
    required this.result,
    required this.privacy,
    required this.resolutionSource,
  });

  final _GovernanceResult result;
  final String privacy;
  final String resolutionSource;

  @override
  Widget build(BuildContext context) {
    final privacyLabel = privacy == 'public'
        ? 'Công khai'
        : privacy == 'private'
        ? 'Riêng tư'
        : 'Unlisted';
    return VitCard(
      borderColor: AppColors.accent20,
      padding: AppSpacing.arenaGovernanceCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _MiniHeader(
            icon: Icons.summarize_outlined,
            label: 'Governance Summary',
            pill: 'TỰ SINH',
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryRow(label: 'Rule clarity', value: '${result.clarity} / 100'),
          _SummaryRow(
            label: 'Publish eligibility',
            value: _tierLabel(result.tier),
          ),
          _SummaryRow(label: 'Risk tier', value: result.risk),
          _SummaryRow(
            label: 'Resolution method',
            value: resolutionSource.isEmpty ? '-' : resolutionSource,
          ),
          _SummaryRow(label: 'Privacy', value: privacyLabel),
          const SizedBox(height: AppSpacing.x3),
          VitCard(
            variant: VitCardVariant.inner,
            borderColor: AppColors.warningBorder,
            padding: AppSpacing.arenaGovernanceInnerPadding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: AppColors.warn,
                  size: AppSpacing.arenaGovernanceIcon,
                ),
                const SizedBox(width: AppSpacing.x2),
                Expanded(
                  child: Text(
                    result.tier == _EligibilityTier.green
                        ? 'Rule đủ rõ để tiếp tục.'
                        : 'Nên chuyển sang Private hoặc Unlisted cho đến khi rule rõ ràng hơn.',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      height: AppSpacing.arenaGovernanceBodyLineHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.x2),
          _NextActionChip(text: result.nextAction),
        ],
      ),
    );
  }
}

class _GovernanceFooter extends StatelessWidget {
  const _GovernanceFooter({
    required this.canContinue,
    required this.result,
    required this.statusLabel,
    required this.onBack,
    required this.onSave,
    required this.onContinue,
  });

  final bool canContinue;
  final _GovernanceResult result;
  final String? statusLabel;
  final VoidCallback onBack;
  final VoidCallback onSave;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final color = _tierColor(result.tier);
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.bg,
        shape: Border(top: BorderSide(color: AppColors.borderSolid)),
      ),
      child: Padding(
        padding: AppSpacing.arenaGovernanceFooterPadding,
        child: Column(
          children: [
            Row(
              children: [
                VitCard(
                  variant: VitCardVariant.inner,
                  width: AppSpacing.ctaHeight,
                  height: AppSpacing.ctaHeight,
                  onTap: onBack,
                  child: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.text2,
                    size: AppSpacing.arenaGovernanceFooterIcon,
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: VitCtaButton(
                    key: ArenaGovernanceGatePage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Tiếp tục'),
                        const SizedBox(width: AppSpacing.x1),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: canContinue
                              ? AppColors.onAccent
                              : AppColors.text3,
                          size: AppSpacing.arenaGovernanceIcon,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x2),
            Row(
              children: [
                VitCard(
                  key: ArenaGovernanceGatePage.saveKey,
                  variant: VitCardVariant.ghost,
                  padding: AppSpacing.arenaGovernanceSavePadding,
                  onTap: onSave,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.save_outlined,
                        color: AppColors.text3,
                        size: AppSpacing.arenaGovernanceSmallIcon,
                      ),
                      const SizedBox(width: AppSpacing.x1),
                      Text(
                        'Lưu nháp',
                        style: AppTextStyles.micro.copyWith(
                          color: AppColors.text3,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    statusLabel ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ),
                _StatusPill(label: _tierLabel(result.tier), color: color),
                const SizedBox(width: AppSpacing.x2),
                Text(
                  'Bước 3 / 6',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
