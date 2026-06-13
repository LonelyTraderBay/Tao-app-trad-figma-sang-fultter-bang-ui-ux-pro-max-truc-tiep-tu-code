part of '../pages/support_page.dart';

class _SupportContextCard extends StatelessWidget {
  const _SupportContextCard({required this.supportContext});

  final ProductSupportContext supportContext;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: SupportPage.contextKey,
      radius: VitCardRadius.sm,
      borderColor: AppModuleAccents.support.withValues(alpha: .28),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppModuleAccents.support.withValues(alpha: .12),
                  borderRadius: AppRadii.mdRadius,
                  border: Border.all(
                    color: AppModuleAccents.support.withValues(alpha: .24),
                  ),
                ),
                child: const Icon(
                  Icons.assignment_outlined,
                  color: AppModuleAccents.support,
                  size: 19,
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
                    const SizedBox(height: 2),
                    Text(
                      supportContext.issueLabel,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.25,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
        border: Border.all(color: color.withValues(alpha: .22)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
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
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.primary15,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$index',
                    style: AppTextStyles.numericMicro.copyWith(
                      color: AppColors.primary,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: AppColors.divider),
                  ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.x3),
              child: Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  height: 1.25,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
