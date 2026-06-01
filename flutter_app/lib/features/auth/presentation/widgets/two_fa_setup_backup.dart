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
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.buy10,
            borderRadius: AppRadii.cardRadius,
            border: Border.all(color: AppColors.buy20),
          ),
          child: const Icon(
            Icons.file_download_outlined,
            color: AppColors.buy,
            size: 34,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Bước 3: Mã dự phòng',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(fontSize: 22),
        ),
        const SizedBox(height: AppSpacing.x3),
        Text(
          'Lưu các mã này ở nơi an toàn. Dùng khi mất thiết bị xác thực.',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        _BackupCodeList(codes: _backupCodes),
        const SizedBox(height: 20),
        const _WarningBanner(text: 'Mỗi mã chỉ dùng được 1 lần.'),
        const SizedBox(height: 16),
        _BackupSavedRow(saved: saved, onTap: onSavedChanged),
        if (error.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.x4),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.inputRadius,
        border: Border.all(color: AppColors.borderSolid),
      ),
      child: Column(
        children: [
          for (var index = 0; index < codes.length; index++) ...[
            if (index > 0) const SizedBox(height: AppSpacing.x3),
            Row(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: _authPrimary20,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${index + 1}',
                    style: AppTextStyles.micro.copyWith(
                      color: _authPrimary,
                      fontWeight: AppTextStyles.bold,
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
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(top: 1),
              decoration: BoxDecoration(
                color: saved ? _authPrimary : AppColors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: saved ? _authPrimary : AppColors.borderSolid,
                  width: 1.4,
                ),
              ),
              child: saved
                  ? const Icon(
                      Icons.check_rounded,
                      color: AppColors.onAccent,
                      size: 15,
                    )
                  : null,
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
