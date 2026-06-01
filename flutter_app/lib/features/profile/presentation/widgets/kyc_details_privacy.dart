part of '../pages/kyc_page.dart';

class _DetailsBlock extends StatelessWidget {
  const _DetailsBlock({
    required this.title,
    required this.lines,
    this.done = true,
  });

  final String title;
  final List<String> lines;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        for (final line in lines) ...[
          Row(
            children: [
              if (title.startsWith('T')) ...[
                Icon(
                  Icons.check_circle_rounded,
                  color: done ? _kycGreen : AppColors.text3,
                  size: 12,
                ),
                const SizedBox(width: 8),
              ] else
                Text(
                  '\u2022 ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              Expanded(
                child: Text(
                  line,
                  style: AppTextStyles.caption.copyWith(
                    color: done ? AppColors.text1 : AppColors.text3,
                    fontSize: 13,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
        ],
      ],
    );
  }
}

class _PrivacyCard extends StatelessWidget {
  const _PrivacyCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      key: KYCPage.privacyCardKey,
      height: 95,
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.primary08,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: _kycPrimary.withValues(alpha: .24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _kycPrimary, size: 15),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'B\u1EA3o m\u1EADt th\u00F4ng tin c\u00E1 nh\u00E2n',
                  style: AppTextStyles.caption.copyWith(
                    color: _kycPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 10),
                Flexible(
                  child: Text(
                    'Th\u00F4ng tin KYC \u0111\u01B0\u1EE3c m\u00E3 h\u00F3a AES-256. Ch\u00FAng t\u00F4i kh\u00F4ng chia\n'
                    's\u1EBB v\u1EDBi b\u00EAn th\u1EE9 ba.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.38,
                    ),
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
