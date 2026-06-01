part of '../pages/arena_studio_page.dart';

class _StickyStudioFooter extends StatelessWidget {
  const _StickyStudioFooter({
    required this.step,
    required this.totalSteps,
    required this.canContinue,
    required this.onContinue,
    required this.onSave,
    required this.onExport,
    required this.onImport,
    this.onBack,
    this.statusLabel,
  });

  final int step;
  final int totalSteps;
  final bool canContinue;
  final VoidCallback onContinue;
  final VoidCallback onSave;
  final VoidCallback onExport;
  final VoidCallback onImport;
  final VoidCallback? onBack;
  final String? statusLabel;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.cardBorder)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.x5,
          AppSpacing.x4,
          AppSpacing.x5,
          AppSpacing.x3,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (onBack != null) ...[
                  SizedBox(
                    width: AppSpacing.ctaHeight,
                    height: AppSpacing.ctaHeight,
                    child: VitCtaButton(
                      key: ArenaStudioPage.backStepKey,
                      onPressed: onBack,
                      variant: VitCtaButtonVariant.secondary,
                      fullWidth: false,
                      padding: EdgeInsets.zero,
                      child: const Icon(Icons.chevron_left_rounded),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x3),
                ],
                Expanded(
                  child: VitCtaButton(
                    key: ArenaStudioPage.continueKey,
                    onPressed: canContinue ? onContinue : null,
                    fullWidth: true,
                    trailing: Icon(
                      step == totalSteps
                          ? Icons.send_outlined
                          : Icons.chevron_right_rounded,
                    ),
                    child: Text(step == totalSteps ? 'Mở phòng' : 'Tiếp tục'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                _FooterToolButton(
                  key: ArenaStudioPage.saveKey,
                  icon: Icons.save_outlined,
                  label: 'Lưu',
                  onTap: onSave,
                ),
                _FooterToolButton(
                  key: ArenaStudioPage.exportKey,
                  icon: Icons.download_outlined,
                  label: 'Xuất',
                  onTap: onExport,
                ),
                _FooterToolButton(
                  key: ArenaStudioPage.importKey,
                  icon: Icons.upload_outlined,
                  label: 'Nhập',
                  onTap: onImport,
                ),
                const Spacer(),
                if (statusLabel != null) ...[
                  Flexible(
                    child: Text(
                      statusLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.buy,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
                Text(
                  'Bước $step / $totalSteps',
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

class _FooterToolButton extends StatelessWidget {
  const _FooterToolButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.text3, size: AppSpacing.iconSm),
            const SizedBox(width: AppSpacing.x1),
            Text(
              label,
              style: AppTextStyles.micro.copyWith(color: AppColors.text3),
            ),
          ],
        ),
      ),
    );
  }
}
