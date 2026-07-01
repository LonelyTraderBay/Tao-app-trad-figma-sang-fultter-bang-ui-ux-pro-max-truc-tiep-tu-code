part of '../pages/support_page.dart';

class _SupportContextCard extends StatelessWidget {
  const _SupportContextCard({required this.supportContext});

  final ProductSupportContext supportContext;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SupportPage.contextKey,
      radius: VitCardRadius.standard,
      borderColor: AppModuleAccents.support.withValues(alpha: .28),
      padding: AppSpacing.supportCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              SizedBox.square(
                dimension: AppSpacing.supportContextIconBox,
                child: Material(
                  color: AppModuleAccents.support.withValues(alpha: .12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadii.mdRadius,
                    side: BorderSide(
                      color: AppModuleAccents.support.withValues(alpha: .24),
                    ),
                  ),
                  child: const Icon(
                    Icons.assignment_outlined,
                    color: AppModuleAccents.support,
                    size: AppSpacing.supportContextIcon,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hồ sơ hỗ trợ',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.base.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.supportTinyGap),
                    Text(
                      supportContext.issueLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: AppSpacing.supportLineHeightTight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _ContextChip(
                label: supportContext.productArea,
                color: AppModuleAccents.support,
              ),
              _ContextChip(label: supportContext.module, color: AppColors.info),
              if (supportContext.referenceId != null)
                _ContextChip(
                  label: supportContext.referenceId!,
                  color: AppColors.warn,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          for (var i = 0; i < supportContext.timelineLabels.length; i++) ...[
            _TimelineRow(
              index: i + 1,
              label: supportContext.timelineLabels[i],
              isLast: i == supportContext.timelineLabels.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _ContextChip extends StatelessWidget {
  const _ContextChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return VitAccentPill(
      label: label,
      accentColor: color,
      size: VitStatusPillSize.sm,
    );
  }
}

class _TimelineRow extends StatelessWidget {
  const _TimelineRow({
    required this.index,
    required this.label,
    required this.isLast,
  });

  final int index;
  final String label;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: AppSpacing.supportTimelineRailWidth,
            child: Column(
              children: [
                SizedBox.square(
                  dimension: AppSpacing.supportTimelineDotSize,
                  child: Material(
                    color: AppColors.primary15,
                    shape: const CircleBorder(),
                    child: Center(
                      child: Text(
                        '$index',
                        style: AppTextStyles.numericMicro.copyWith(
                          color: AppColors.primary,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: SizedBox(
                      width: AppSpacing.supportTimelineLineWidth,
                      child: ColoredBox(color: AppColors.divider),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Padding(
              padding: AppSpacing.supportTimelineLabelPadding(isLast),
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: AppSpacing.supportLineHeightTight,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
