import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _providerBlue = Color(0xFF3B82F6);
const _providerGreen = Color(0xFF10B981);
const _providerWarning = Color(0xFFF59E0B);
const _providerPanel = Color(0xFF1B2132);
const _providerField = Color(0xFF22283A);

class ProviderApplicationPage extends ConsumerStatefulWidget {
  const ProviderApplicationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc069_provider_application_scroll_content');
  static const nextKey = Key('sc069_provider_application_next');
  static const submitKey = Key('sc069_provider_application_submit');
  static const kycKey = Key('sc069_provider_application_kyc');
  static const disclosureKey = Key('sc069_provider_application_disclosure');
  static const fiduciaryKey = Key('sc069_provider_application_fiduciary');
  static const termsKey = Key('sc069_provider_application_terms');
  static const monthsFieldKey = Key('sc069_provider_application_months');
  static const strategyFieldKey = Key('sc069_provider_application_strategy');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<ProviderApplicationPage> createState() =>
      _ProviderApplicationPageState();
}

class _ProviderApplicationPageState
    extends ConsumerState<ProviderApplicationPage> {
  TradeProviderApplicationStep? _step;
  TradeProviderApplicationDraft? _draft;
  late final TextEditingController _monthsController;
  late final TextEditingController _strategyController;
  bool _controllersReady = false;

  @override
  void dispose() {
    if (_controllersReady) {
      _monthsController.dispose();
      _strategyController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repository = ref.watch(tradeRepositoryProvider);
    final snapshot = repository.getProviderApplication();
    _step ??= snapshot.defaultStep;
    _draft ??= snapshot.defaultDraft;
    if (!_controllersReady) {
      _monthsController = TextEditingController(
        text: _draft!.tradingMonths.toString(),
      );
      _strategyController = TextEditingController(
        text: _draft!.strategyDescription,
      );
      _controllersReady = true;
    }

    final step = _step!;
    final draft = _draft!;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-069 ProviderApplicationPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Đăng ký Provider',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: ProviderApplicationPage.contentKey,
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProgressBars(steps: snapshot.steps, activeStep: step),
                    const SizedBox(height: 58),
                    switch (step) {
                      TradeProviderApplicationStep.intro => _IntroStep(
                        snapshot: snapshot,
                      ),
                      TradeProviderApplicationStep.requirements =>
                        _RequirementsStep(
                          draft: draft,
                          onChanged: _updateDraft,
                          monthsController: _monthsController,
                        ),
                      TradeProviderApplicationStep.disclosure =>
                        _DisclosureStep(draft: draft, onChanged: _updateDraft),
                      TradeProviderApplicationStep.fees => _FeesStep(
                        draft: draft,
                        onChanged: _updateDraft,
                        strategyController: _strategyController,
                      ),
                      TradeProviderApplicationStep.review => _ReviewStep(
                        draft: draft,
                        onChanged: _updateDraft,
                      ),
                    },
                  ],
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: DeviceMetrics.nativeBottomChrome + 20,
                ),
                child: VitStickyFooter(
                  backgroundColor: AppColors.bg,
                  child: _FooterButton(
                    step: step,
                    enabled: _canProceed(step, draft),
                    onPressed: () => _handlePrimaryAction(repository),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateDraft(TradeProviderApplicationDraft draft) {
    setState(() => _draft = draft);
  }

  bool _canProceed(
    TradeProviderApplicationStep step,
    TradeProviderApplicationDraft draft,
  ) {
    return switch (step) {
      TradeProviderApplicationStep.intro => true,
      TradeProviderApplicationStep.requirements =>
        draft.hasKyc && draft.tradingMonths >= 6 && draft.minCapital >= 10000,
      TradeProviderApplicationStep.disclosure =>
        draft.agreedToDisclosure && draft.agreedToFiduciary,
      TradeProviderApplicationStep.fees =>
        draft.performanceFee >= 0 &&
            draft.performanceFee <= 30 &&
            draft.strategyDescription.length >= 100,
      TradeProviderApplicationStep.review => draft.agreedToTerms,
    };
  }

  void _handlePrimaryAction(TradeRepository repository) {
    final step = _step!;
    final draft = _draft!;
    if (!_canProceed(step, draft)) return;

    switch (step) {
      case TradeProviderApplicationStep.intro:
        setState(() => _step = TradeProviderApplicationStep.requirements);
      case TradeProviderApplicationStep.requirements:
        setState(() => _step = TradeProviderApplicationStep.disclosure);
      case TradeProviderApplicationStep.disclosure:
        setState(() => _step = TradeProviderApplicationStep.fees);
      case TradeProviderApplicationStep.fees:
        setState(() => _step = TradeProviderApplicationStep.review);
      case TradeProviderApplicationStep.review:
        repository.submitProviderApplication(draft);
        context.go(AppRoutePaths.tradeCopyTrading);
    }
  }
}

class _ProgressBars extends StatelessWidget {
  const _ProgressBars({required this.steps, required this.activeStep});

  final List<TradeProviderApplicationStep> steps;
  final TradeProviderApplicationStep activeStep;

  @override
  Widget build(BuildContext context) {
    final activeIndex = steps.indexOf(activeStep);
    return Row(
      children: [
        for (var index = 0; index < steps.length; index++) ...[
          Expanded(
            child: Container(
              height: 4,
              decoration: BoxDecoration(
                color: activeIndex >= index
                    ? _providerBlue
                    : AppColors.surface3,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          if (index != steps.length - 1) const SizedBox(width: 9),
        ],
      ],
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.snapshot});

  final TradeProviderApplicationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(Icons.groups_2_outlined, color: _providerBlue, size: 44),
        const SizedBox(height: 38),
        Text(
          'Trở thành Copy Trading Provider',
          textAlign: TextAlign.center,
          style: AppTextStyles.sectionTitle.copyWith(
            fontSize: 22,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Chia sẻ chiến lược giao dịch và kiếm performance fee từ những người copy bạn',
          textAlign: TextAlign.center,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 13,
            height: 1.42,
          ),
        ),
        const SizedBox(height: 42),
        _SectionLabel(label: 'Lợi ích', color: _providerGreen),
        const SizedBox(height: 10),
        for (final benefit in snapshot.benefits) ...[
          _BenefitCard(benefit: benefit),
          if (benefit != snapshot.benefits.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 18),
        _ResponsibilitiesCard(items: snapshot.responsibilities),
        const SizedBox(height: 14),
        _SectionLabel(label: 'Yêu cầu cơ bản', color: AppColors.text3),
        const SizedBox(height: 10),
        for (final requirement in snapshot.requirements) ...[
          _RequirementPreview(requirement: requirement),
          if (requirement != snapshot.requirements.last)
            const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _BenefitCard extends StatelessWidget {
  const _BenefitCard({required this.benefit});

  final TradeProviderBenefit benefit;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: _providerPanel,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFF0FDF4),
              shape: BoxShape.circle,
            ),
            child: Icon(_benefitIcon(benefit.iconName), color: _providerGreen),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  benefit.description,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.25,
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

class _ResponsibilitiesCard extends StatelessWidget {
  const _ResponsibilitiesCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF211712),
        border: Border.all(color: _providerWarning.withValues(alpha: .55)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: _providerWarning,
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trách nhiệm quan trọng',
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _providerWarning,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                for (final item in items)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                      '• $item',
                      style: AppTextStyles.caption.copyWith(
                        color: _providerWarning,
                        fontSize: 10,
                        height: 1.3,
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

class _RequirementPreview extends StatelessWidget {
  const _RequirementPreview({required this.requirement});

  final TradeProviderRequirement requirement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: _providerPanel,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              requirement.label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 11,
              ),
            ),
          ),
          Icon(
            requirement.met
                ? Icons.check_circle_rounded
                : Icons.cancel_outlined,
            color: requirement.met ? _providerGreen : AppColors.text3,
            size: 14,
          ),
        ],
      ),
    );
  }
}

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
      height: 48,
      child: FilledButton.icon(
        key: submit
            ? ProviderApplicationPage.submitKey
            : ProviderApplicationPage.nextKey,
        onPressed: enabled ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: submit ? _providerGreen : _providerBlue,
          disabledBackgroundColor: _providerBlue.withValues(alpha: .42),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(
          submit ? Icons.workspace_premium_outlined : Icons.chevron_right,
          size: 17,
          color: Colors.white,
        ),
        label: Text(
          submit ? 'Gửi đơn đăng ký' : 'Tiếp tục',
          style: AppTextStyles.baseMedium.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _StepTitle extends StatelessWidget {
  const _StepTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: AppTextStyles.sectionTitle.copyWith(fontSize: 18),
      ),
    );
  }
}

class _TogglePanel extends StatelessWidget {
  const _TogglePanel({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.active,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool active;
  final String activeLabel;
  final String inactiveLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Panel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PanelHeader(icon: icon, title: title),
            const SizedBox(height: 8),
            Text(description, style: _panelDescriptionStyle),
            const SizedBox(height: 12),
            SizedBox(
              height: 40,
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: active ? _providerGreen : _providerBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(active ? activeLabel : inactiveLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberPanel extends StatelessWidget {
  const _NumberPanel({
    required this.title,
    required this.description,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final String title;
  final String description;
  final String label;
  final TextEditingController controller;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: Icons.schedule_rounded, title: title),
          const SizedBox(height: 8),
          Text(description, style: _panelDescriptionStyle),
          const SizedBox(height: 12),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            key: ProviderApplicationPage.monthsFieldKey,
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) => onChanged(int.tryParse(value) ?? 0),
            style: AppTextStyles.baseMedium.copyWith(color: AppColors.text1),
            decoration: _inputDecoration('0'),
          ),
        ],
      ),
    );
  }
}

class _ConsentTile extends StatelessWidget {
  const _ConsentTile({
    this.tileKey,
    required this.checked,
    required this.text,
    required this.onTap,
  });

  final Key? tileKey;
  final bool checked;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: tileKey,
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: checked
              ? _providerBlue.withValues(alpha: .14)
              : _providerPanel,
          border: Border.all(
            color: checked ? _providerBlue : AppColors.cardBorder,
            width: 1.5,
          ),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              checked
                  ? Icons.check_circle_rounded
                  : Icons.radio_button_unchecked_rounded,
              color: checked ? _providerBlue : AppColors.text3,
              size: 22,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 11,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoPanel extends StatelessWidget {
  const _InfoPanel({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _PanelHeader(icon: icon, title: title),
          const SizedBox(height: 8),
          Text(description, style: _panelDescriptionStyle),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: _providerBlue, size: 18),
        const SizedBox(width: 8),
        Text(
          title,
          style: AppTextStyles.baseMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

TextStyle get _panelDescriptionStyle => AppTextStyles.caption.copyWith(
  color: AppColors.text3,
  fontSize: 11,
  height: 1.45,
);

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: AppTextStyles.caption.copyWith(color: AppColors.text3),
    filled: true,
    fillColor: _providerField,
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(14),
    ),
  );
}

IconData _benefitIcon(String iconName) {
  return switch (iconName) {
    'dollar' => Icons.attach_money_rounded,
    'users' => Icons.groups_2_outlined,
    'trend' => Icons.trending_up_rounded,
    _ => Icons.check_rounded,
  };
}
