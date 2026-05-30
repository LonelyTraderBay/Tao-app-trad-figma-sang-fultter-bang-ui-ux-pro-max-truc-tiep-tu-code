import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/app/providers/trade_controller_providers.dart';
import 'package:vit_trade_flutter/features/trade/presentation/controllers/trade_controller.dart';

const _termsBackground = AppColors.bg;
const _termsPanel = AppColors.surface;
const _termsPanel2 = AppColors.surface2;
const _termsPrimary = AppColors.primary;
const _termsAmber = AppColors.caution;
const _termsRed = AppColors.sell;

class BotTermsOfServicePage extends ConsumerStatefulWidget {
  const BotTermsOfServicePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc117_bot_terms_content');
  static const termsScrollKey = Key('sc117_bot_terms_inner_scroll');
  static const agreementKey = Key('sc117_bot_terms_agreement');
  static const ctaKey = Key('sc117_bot_terms_cta');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotTermsOfServicePage> createState() =>
      _BotTermsOfServicePageState();
}

class _BotTermsOfServicePageState extends ConsumerState<BotTermsOfServicePage> {
  final ScrollController _termsController = ScrollController();
  bool _readToEnd = false;
  bool _agreed = false;

  @override
  void initState() {
    super.initState();
    _termsController.addListener(_markReadAtBottom);
  }

  @override
  void dispose() {
    _termsController
      ..removeListener(_markReadAtBottom)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getBotTermsOfService();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 58
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-117 BotTermsOfServicePage',
      child: Material(
        color: _termsBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Trading Bots Terms',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotTermsOfServicePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _InfoBanner(snapshot: snapshot),
                    const SizedBox(height: 18),
                    _TermsCard(
                      snapshot: snapshot,
                      controller: _termsController,
                    ),
                    const SizedBox(height: 18),
                    _SectionLabel(snapshot.acceptSectionLabel),
                    const SizedBox(height: 12),
                    if (!_readToEnd) ...[
                      _ScrollWarning(snapshot: snapshot),
                      const SizedBox(height: 20),
                    ],
                    _AgreementCard(
                      snapshot: snapshot,
                      enabled: _readToEnd,
                      agreed: _agreed,
                      onTap: _toggleAgreement,
                    ),
                    const SizedBox(height: 16),
                    _TermsCta(
                      snapshot: snapshot,
                      agreed: _agreed,
                      onPressed: _acceptTerms,
                    ),
                    const SizedBox(height: 16),
                    _ComplianceNote(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markReadAtBottom() {
    if (_readToEnd || !_termsController.hasClients) return;
    final position = _termsController.position;
    if (position.pixels + position.viewportDimension >=
        position.maxScrollExtent - 50) {
      setState(() => _readToEnd = true);
    }
  }

  void _toggleAgreement() {
    if (!_readToEnd) return;
    setState(() => _agreed = !_agreed);
  }

  void _acceptTerms() {
    if (!_agreed) return;
    context.go(AppRoutePaths.tradeBots);
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 96),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _termsPrimary.withValues(alpha: .08),
        border: Border.all(
          color: _termsPrimary.withValues(alpha: .24),
          width: 1.5,
        ),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3),
            child: Icon(
              Icons.description_outlined,
              color: _termsPrimary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.infoTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.infoDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.55,
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

class _TermsCard extends StatelessWidget {
  const _TermsCard({required this.snapshot, required this.controller});

  final TradeBotTermsSnapshot snapshot;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 575,
      decoration: BoxDecoration(
        color: _termsPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.cardRadius,
        child: SingleChildScrollView(
          key: BotTermsOfServicePage.termsScrollKey,
          controller: controller,
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontSize: 21,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 22),
              Text(
                snapshot.lastUpdatedLabel,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text3,
                  fontSize: 12,
                  height: 1,
                ),
              ),
              const SizedBox(height: 30),
              for (final section in snapshot.sections) ...[
                _TermsSection(section: section),
                if (section != snapshot.sections.last)
                  const SizedBox(height: 26),
              ],
              const Divider(color: AppColors.borderSolid, height: 32),
              Center(
                child: Text(
                  '-- End of Terms --',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsSection extends StatelessWidget {
  const _TermsSection({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          section.title,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontSize: 16,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 14),
        if (section.warningTitle != null && section.warningBody != null) ...[
          _CriticalWarning(section: section),
          const SizedBox(height: 16),
        ],
        for (final paragraph in section.paragraphs) ...[
          Text(
            paragraph,
            style: AppTextStyles.body.copyWith(
              color: AppColors.text2,
              fontSize: 13,
              height: 1.68,
            ),
          ),
          if (paragraph != section.paragraphs.last) const SizedBox(height: 12),
        ],
        if (section.bullets.isNotEmpty) ...[
          const SizedBox(height: 12),
          for (final bullet in section.bullets)
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 8),
              child: Text(
                '- $bullet',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.text2,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
            ),
        ],
      ],
    );
  }
}

class _CriticalWarning extends StatelessWidget {
  const _CriticalWarning({required this.section});

  final TradeBotTermsSection section;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(13, 14, 13, 13),
      decoration: BoxDecoration(
        color: _termsRed.withValues(alpha: .10),
        border: Border.all(color: _termsRed.withValues(alpha: .35)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _termsRed,
              size: 17,
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.caption.copyWith(
                  color: _termsRed,
                  fontFamily: 'Roboto',
                  fontSize: 12,
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '${section.warningTitle} ',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  TextSpan(text: section.warningBody),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollWarning extends StatelessWidget {
  const _ScrollWarning({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 45),
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: _termsAmber.withValues(alpha: .08),
        border: Border.all(color: _termsAmber.withValues(alpha: .32)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _termsAmber, size: 16),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              snapshot.scrollWarning,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AgreementCard extends StatelessWidget {
  const _AgreementCard({
    required this.snapshot,
    required this.enabled,
    required this.agreed,
    required this.onTap,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool enabled;
  final bool agreed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: enabled ? 1 : .5,
      child: InkWell(
        key: BotTermsOfServicePage.agreementKey,
        onTap: enabled ? onTap : null,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          constraints: const BoxConstraints(minHeight: 122),
          padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
          decoration: BoxDecoration(
            color: enabled ? _termsPanel2 : _termsPanel,
            borderRadius: AppRadii.inputRadius,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: agreed ? AppColors.primary : AppColors.transparent,
                  border: Border.all(
                    color: agreed ? AppColors.primary : AppColors.borderSolid,
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: agreed
                    ? const Icon(
                        Icons.check_circle_outline_rounded,
                        color: AppColors.onAccent,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.agreementTitle,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontSize: 13,
                        fontWeight: AppTextStyles.bold,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      snapshot.agreementDescription,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text3,
                        fontSize: 12,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TermsCta extends StatelessWidget {
  const _TermsCta({
    required this.snapshot,
    required this.agreed,
    required this.onPressed,
  });

  final TradeBotTermsSnapshot snapshot;
  final bool agreed;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: BotTermsOfServicePage.ctaKey,
      height: 44,
      child: FilledButton(
        onPressed: agreed ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: agreed ? AppColors.primary : _termsPanel2,
          disabledBackgroundColor: _termsPanel2,
          disabledForegroundColor: AppColors.text3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        child: Text(
          agreed ? snapshot.enabledCta : snapshot.disabledCta,
          style: AppTextStyles.body.copyWith(
            color: agreed ? AppColors.onAccent : AppColors.text3,
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ComplianceNote extends StatelessWidget {
  const _ComplianceNote({required this.snapshot});

  final TradeBotTermsSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _termsPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.shield_outlined,
              color: AppColors.text3,
              size: 17,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.complianceTitle,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.complianceDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
                    fontSize: 12,
                    height: 1.55,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 15,
          decoration: BoxDecoration(
            color: _termsPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}
