part of '../pages/security_page.dart';

class _AntiPhishingCard extends StatelessWidget {
  const _AntiPhishingCard({
    required this.controller,
    required this.saving,
    required this.onSave,
  });

  final TextEditingController controller;
  final bool saving;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSpacing.buttonHero + AppSpacing.inputHeight,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: _cardDecoration(radius: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: _securityPrimary,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'M\u00E3 ch\u1ED1ng l\u1EEBa \u0111\u1EA3o',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            '\u0110\u1EB7t m\u00E3 c\u00E1 nh\u00E2n. Email t\u1EEB VitTrade s\u1EBD lu\u00F4n hi\u1EC3n th\u1ECB m\u00E3 n\u00E0y.',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: AppSpacing.inputHeight,
            decoration: BoxDecoration(
              color: _securityPanel2,
              borderRadius: AppRadii.cardLargeRadius,
              border: Border.all(color: AppColors.borderSolid),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: SecurityPage.antiPhishingFieldKey,
                    controller: controller,
                    maxLength: 8,
                    cursorColor: _securityPrimary,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      height: 1,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      isCollapsed: true,
                      contentPadding: const EdgeInsets.only(left: 17),
                      hintText: 'Nh\u1EADp m\u00E3 4\u20138 k\u00FD t\u1EF1',
                      hintStyle: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  key: SecurityPage.antiPhishingSaveKey,
                  onTap: saving ? null : onSave,
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    width: 50,
                    height: 30,
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      color: _securityPrimary,
                      borderRadius: AppRadii.cardRadius,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      saving ? '...' : 'L\u01B0u',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.onAccent,
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
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

BoxDecoration _cardDecoration({required double radius}) {
  return BoxDecoration(
    color: _securityPanel,
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(color: _securityBorder),
  );
}

IconData _iconFor(String key) {
  return switch (key) {
    'phone' => Icons.phone_android_rounded,
    'key' => Icons.key_rounded,
    'shield' => Icons.shield_outlined,
    'laptop' => Icons.laptop_mac_rounded,
    'activity' => Icons.monitor_heart_outlined,
    _ => Icons.circle_outlined,
  };
}
