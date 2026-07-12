part of '../pages/smart_alert_center.dart';

class _SmartAlertCard extends StatelessWidget {
  const _SmartAlertCard({required this.alert});

  final SmartAlertDraft alert;

  @override
  Widget build(BuildContext context) {
    final module = _moduleVisual(alert.module);

    return VitCard(
      padding: CrossModuleSpacingTokens.crossModuleCardPadding,
      radius: VitCardRadius.large,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CrossModuleIconBadge(
                icon: module.icon,
                color: module.color,
                background: module.background,
              ),
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
                          alert.type,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        _StatusBadge(status: alert.status),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      alert.moduleName,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x3),
              CrossModuleIconAction(
                icon: Icons.edit_outlined,
                color: AppColors.text3,
                background: AppColors.surface2,
                onTap: HapticFeedback.selectionClick,
              ),
              const SizedBox(width: AppSpacing.x2),
              CrossModuleIconAction(
                icon: Icons.delete_outline_rounded,
                color: AppColors.sell,
                background: AppColors.sell10,
                onTap: HapticFeedback.selectionClick,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          _DetailBlock(label: 'Condition', value: alert.condition),
          const SizedBox(height: AppSpacing.pageRhythmStandardInnerGap),
          _DetailBlock(label: 'Action', value: alert.action),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Row(
            children: [
              Expanded(
                child: _DetailBlock(
                  label: 'Triggered',
                  value: '${alert.triggerCount} times',
                  emphasize: true,
                ),
              ),
              if (alert.lastTriggeredLabel != null)
                Expanded(
                  child: _DetailBlock(
                    label: 'Last Trigger',
                    value: alert.lastTriggeredLabel!,
                    emphasize: true,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SmartAlertStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      SmartAlertStatus.active => AppColors.buy,
      SmartAlertStatus.paused => AppColors.text3,
      SmartAlertStatus.triggered => AppColors.primary,
    };
    final background = switch (status) {
      SmartAlertStatus.active => AppColors.buy10,
      SmartAlertStatus.paused => AppColors.surface3,
      SmartAlertStatus.triggered => AppColors.primary12,
    };

    return DecoratedBox(
      decoration: ShapeDecoration(
        color: background,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xlRadius),
      ),
      child: Padding(
        padding: CrossModuleSpacingTokens.crossModulePillPadding,
        child: Text(
          status.name.toUpperCase(),
          style: AppTextStyles.chartLabelTiny.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _DetailBlock extends StatelessWidget {
  const _DetailBlock({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: emphasize ? AppTextStyles.bold : AppTextStyles.medium,
          ),
        ),
      ],
    );
  }
}

class _CreateAlertButton extends StatelessWidget {
  const _CreateAlertButton();

  @override
  Widget build(BuildContext context) {
    return VitCtaButton(
      key: SmartAlertCenter.createButtonKey,
      onPressed: HapticFeedback.selectionClick,
      leading: const Icon(Icons.add_rounded),
      child: const Text('Create Alert'),
    );
  }
}
