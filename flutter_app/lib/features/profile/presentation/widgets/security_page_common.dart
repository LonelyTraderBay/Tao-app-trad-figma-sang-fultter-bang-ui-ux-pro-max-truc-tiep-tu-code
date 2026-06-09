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
    return VitCard(
      height: AppSpacing.buttonHero + AppSpacing.inputHeight,
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      borderColor: _securityBorder,
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
          VitInput(
            fieldKey: SecurityPage.antiPhishingFieldKey,
            controller: controller,
            semanticLabel: 'Anti phishing code',
            hintText: 'Nh\u1EADp m\u00E3 4\u20138 k\u00FD t\u1EF1',
            inputFormatters: [LengthLimitingTextInputFormatter(8)],
            suffix: SizedBox(
              width: 58,
              child: VitCtaButton(
                key: SecurityPage.antiPhishingSaveKey,
                onPressed: saving ? null : onSave,
                loading: saving,
                height: 32,
                padding: EdgeInsets.zero,
                child: Text(saving ? '...' : 'L\u01B0u'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySupportCard extends StatelessWidget {
  const _SecuritySupportCard({required this.supportRoute});

  final String supportRoute;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: SecurityPage.supportKey,
      onTap: () => context.go(supportRoute),
      behavior: HitTestBehavior.opaque,
      child: VitCard(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        borderColor: _securityBorder,
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _securityPrimary.withValues(alpha: .13),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: _securityPrimary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hỗ trợ bảo mật',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mở hồ sơ hỗ trợ kèm ngữ cảnh tài khoản',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(
                      color: _securityMuted,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 19,
            ),
          ],
        ),
      ),
    );
  }
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
