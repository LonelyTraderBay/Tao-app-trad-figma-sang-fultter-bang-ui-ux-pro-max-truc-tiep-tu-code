part of '../pages/two_fa_setup_page.dart';

class _BackupCodesStep extends StatelessWidget {
  const _BackupCodesStep({
    required this.saved,
    required this.error,
    required this.onSavedChanged,
  });

  final bool saved;
  final String error;
  final VoidCallback onSavedChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.square(
          dimension: AppSpacing.authHeroIconBoxSm,
          child: Material(
            color: AppColors.buy10,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadii.cardRadius,
              side: BorderSide(color: AppColors.buy20),
            ),
            child: const Icon(
              Icons.file_download_outlined,
              color: AppColors.buy,
              size: AppSpacing.authHeroIconMd,
            ),
          ),
        ),
        const Padding(padding: AppSpacing.authTwoFaHeroTopPadding),
        Text(
          'Bước 3: Mã dự phòng',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle,
        ),
        const Padding(padding: AppSpacing.authTopGapX3),
        Text(
          'Lưu các mã này ở nơi an toàn. Dùng khi mất thiết bị xác thực.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: AppSpacing.authFooterLineHeight,
          ),
        ),
        const Padding(padding: AppSpacing.authTwoFaSectionTopPadding),
        _BackupCodeList(codes: _backupCodes),
        const Padding(padding: AppSpacing.authTwoFaSectionTopPadding),
        const _WarningBanner(text: 'Mỗi mã chỉ dùng được 1 lần.'),
        const Padding(padding: AppSpacing.authTwoFaBackupActionTopPadding),
        _BackupSavedRow(saved: saved, onTap: onSavedChanged),
        if (error.isNotEmpty) ...[
          const Padding(padding: AppSpacing.authTopGapX4),
          _ErrorBanner(error: error),
        ],
      ],
    );
  }
}

class _BackupCodeList extends StatelessWidget {
  const _BackupCodeList({required this.codes});

  final List<String> codes;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      variant: VitCardVariant.inner,
      borderColor: AppColors.borderSolid,
      child: Column(
        children: [
          for (var index = 0; index < codes.length; index++) ...[
            if (index > 0) const Padding(padding: AppSpacing.authTopGapX3),
            Row(
              children: [
                SizedBox.square(
                  dimension: AppSpacing.authTwoFaBackupIndexSize,
                  child: Material(
                    color: _authPrimary20,
                    shape: const CircleBorder(),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: AppTextStyles.micro.copyWith(
                          color: _authPrimary,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: SelectableText(
                    codes[index],
                    style: AppTextStyles.body.copyWith(
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _BackupSavedRow extends StatelessWidget {
  const _BackupSavedRow({required this.saved, required this.onTap});

  final bool saved;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      checked: saved,
      label: 'Tôi đã lưu các mã dự phòng',
      child: InkWell(
        key: TwoFASetupPage.backupSavedKey,
        onTap: onTap,
        borderRadius: AppRadii.mdRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: AppSpacing.authTwoFaBackupCheckMargin,
              child: SizedBox.square(
                dimension: AppSpacing.authTwoFaBackupCheckSize,
                child: Material(
                  color: saved ? _authPrimary : AppColors.transparent,
                  shape: CircleBorder(
                    side: BorderSide(
                      color: saved ? _authPrimary : AppColors.borderSolid,
                      width: AppSpacing.authTwoFaBackupCheckBorder,
                    ),
                  ),
                  child: saved
                      ? const Icon(
                          Icons.check_rounded,
                          color: AppColors.onAccent,
                          size: AppSpacing.authTwoFaBackupCheckIcon,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Text(
                'Tôi đã lưu các mã dự phòng',
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
