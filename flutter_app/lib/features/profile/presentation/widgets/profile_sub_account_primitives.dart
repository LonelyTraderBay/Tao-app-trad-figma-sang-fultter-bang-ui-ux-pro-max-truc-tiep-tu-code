part of '../pages/sub_account_page.dart';

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text2,
        fontWeight: AppTextStyles.bold,
        height: 1.1,
      ),
    );
  }
}

class _AccountAvatar extends StatelessWidget {
  const _AccountAvatar({required this.initial, required this.color});

  final String initial;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: AppRadii.cardRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

class _SmallPill extends StatelessWidget {
  const _SmallPill({
    required this.label,
    required this.foreground,
    required this.background,
    required this.border,
  });

  final String label;
  final Color foreground;
  final Color background;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.smRadius,
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyles.micro.copyWith(
          color: foreground,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SubAccountInfoNote extends StatelessWidget {
  const _SubAccountInfoNote();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(14, 13, 14, 13),
      borderColor: AppColors.primary20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.primary,
            size: 16,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'M\u1ED7i t\u00E0i kho\u1EA3n ph\u1EE5 c\u00F3 v\u00ED v\u00E0 API ri\u00EAng bi\u1EC7t. B\u1EA1n c\u00F3 th\u1EC3 t\u1EA1o t\u1ED1i \u0111a 20 t\u00E0i kho\u1EA3n ph\u1EE5. T\u00E0i kho\u1EA3n ph\u1EE5 th\u1EEBa h\u01B0\u1EDFng m\u1EE9c VIP c\u1EE7a t\u00E0i kho\u1EA3n ch\u00EDnh.',
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
