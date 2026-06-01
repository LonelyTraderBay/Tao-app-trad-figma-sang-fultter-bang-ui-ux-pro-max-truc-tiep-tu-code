part of '../pages/provider_application_page.dart';

class _RequirementsStep extends StatelessWidget {
  const _RequirementsStep({
    required this.draft,
    required this.onChanged,
    required this.monthsController,
  });

  final TradeProviderApplicationDraft draft;
  final ValueChanged<TradeProviderApplicationDraft> onChanged;
  final TextEditingController monthsController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: 'Kiểm tra điều kiện'),
        _TogglePanel(
          key: ProviderApplicationPage.kycKey,
          icon: Icons.shield_outlined,
          title: 'KYC Level 2',
          description:
              'Provider phải hoàn thành KYC Level 2 (ID + Selfie + Proof of address)',
          active: draft.hasKyc,
          activeLabel: 'Đã hoàn thành KYC',
          inactiveLabel: 'Hoàn thành KYC ngay',
          onTap: () => onChanged(draft.copyWith(hasKyc: !draft.hasKyc)),
        ),
        const SizedBox(height: 12),
        _NumberPanel(
          title: 'Trading History',
          description: 'Tài khoản phải có lịch sử giao dịch ít nhất 6 tháng',
          label: 'Số tháng giao dịch',
          controller: monthsController,
          onChanged: (value) => onChanged(draft.copyWith(tradingMonths: value)),
        ),
      ],
    );
  }
}

class _DisclosureStep extends StatelessWidget {
  const _DisclosureStep({required this.draft, required this.onChanged});

  final TradeProviderApplicationDraft draft;
  final ValueChanged<TradeProviderApplicationDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: 'Nghĩa vụ công khai'),
        _ConsentTile(
          tileKey: ProviderApplicationPage.disclosureKey,
          checked: draft.agreedToDisclosure,
          text:
              'Tôi cam kết công khai hiệu suất, thay đổi chiến lược, phí và mọi xung đột lợi ích.',
          onTap: () => onChanged(
            draft.copyWith(agreedToDisclosure: !draft.agreedToDisclosure),
          ),
        ),
        const SizedBox(height: 12),
        _ConsentTile(
          tileKey: ProviderApplicationPage.fiduciaryKey,
          checked: draft.agreedToFiduciary,
          text:
              'Tôi hiểu hành động của tôi ảnh hưởng trực tiếp đến tài sản của copiers và cam kết trách nhiệm phù hợp.',
          onTap: () => onChanged(
            draft.copyWith(agreedToFiduciary: !draft.agreedToFiduciary),
          ),
        ),
      ],
    );
  }
}

class _FeesStep extends StatelessWidget {
  const _FeesStep({
    required this.draft,
    required this.onChanged,
    required this.strategyController,
  });

  final TradeProviderApplicationDraft draft;
  final ValueChanged<TradeProviderApplicationDraft> onChanged;
  final TextEditingController strategyController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: 'Cấu trúc phí'),
        _InfoPanel(
          icon: Icons.attach_money_rounded,
          title: 'Performance Fee',
          description:
              'Bạn nhận ${draft.performanceFee}% từ lợi nhuận của copiers, chỉ khi copier có lời theo high-water mark.',
        ),
        const SizedBox(height: 12),
        TextField(
          key: ProviderApplicationPage.strategyFieldKey,
          controller: strategyController,
          minLines: 6,
          maxLines: 6,
          onChanged: (value) =>
              onChanged(draft.copyWith(strategyDescription: value)),
          style: AppTextStyles.caption.copyWith(color: AppColors.text1),
          decoration: _inputDecoration('Mô tả chiến lược tối thiểu 100 ký tự'),
        ),
        const SizedBox(height: 6),
        Text(
          '${draft.strategyDescription.length}/100 ký tự',
          style: AppTextStyles.caption.copyWith(
            color: draft.strategyDescription.length >= 100
                ? _providerGreen
                : AppColors.text3,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _ReviewStep extends StatelessWidget {
  const _ReviewStep({required this.draft, required this.onChanged});

  final TradeProviderApplicationDraft draft;
  final ValueChanged<TradeProviderApplicationDraft> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StepTitle(title: 'Xem lại đơn đăng ký'),
        _InfoPanel(
          icon: Icons.fact_check_outlined,
          title: 'Thông tin cơ bản',
          description:
              'Trading history ${draft.tradingMonths} tháng, vốn \$${draft.minCapital}, performance fee ${draft.performanceFee}%.',
        ),
        const SizedBox(height: 12),
        _ConsentTile(
          tileKey: ProviderApplicationPage.termsKey,
          checked: draft.agreedToTerms,
          text:
              'Tôi đã đọc và đồng ý với Điều khoản Provider, Code of Conduct và Disclosure Requirements.',
          onTap: () =>
              onChanged(draft.copyWith(agreedToTerms: !draft.agreedToTerms)),
        ),
      ],
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    required this.step,
    required this.enabled,
    required this.onPressed,
  });

  final TradeProviderApplicationStep step;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final submit = step == TradeProviderApplicationStep.review;
    return SizedBox(
      height: AppSpacing.inputHeight,
      child: FilledButton.icon(
        key: submit
            ? ProviderApplicationPage.submitKey
            : ProviderApplicationPage.nextKey,
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: submit ? _providerGreen : _providerPrimary,
          disabledBackgroundColor: _providerPrimary.withValues(alpha: .42),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.cardRadius),
        ),
        icon: Icon(
          submit ? Icons.workspace_premium_outlined : Icons.chevron_right,
          size: 17,
          color: AppColors.onAccent,
        ),
        label: Text(
          submit ? 'Gửi đơn đăng ký' : 'Tiếp tục',
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.onAccent,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
