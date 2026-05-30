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

const _compBackground = AppColors.bg;
const _compPanel = AppColors.surface;
const _compPanel2 = AppColors.surface2;
const _compBorder = AppColors.borderSolid;
const _compPrimary = AppColors.primary;
const _compGreen = AppColors.buy;
const _compAmber = AppColors.caution;
const _compRed = AppColors.sell;

class InvestorCompensationPage extends ConsumerStatefulWidget {
  const InvestorCompensationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc104_investor_compensation_content');
  static const faqKey = Key('sc104_investor_compensation_faq');
  static Key tabKey(String id) => Key('sc104_investor_compensation_tab_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<InvestorCompensationPage> createState() =>
      _InvestorCompensationPageState();
}

class _InvestorCompensationPageState
    extends ConsumerState<InvestorCompensationPage> {
  String _tab = 'overview';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(tradeReadModelControllerProvider)
        .getInvestorCompensation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-104 InvestorCompensationPage',
      child: Material(
        color: _compBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Investor Compensation',
              subtitle: 'FSCS Protection',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeCopyTrading),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: InvestorCompensationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProtectionCard(snapshot: snapshot),
                    const SizedBox(height: 39),
                    _InfoNotice(snapshot: snapshot),
                    const SizedBox(height: 35),
                    _Tabs(activeId: _tab, onChanged: _setTab),
                    const SizedBox(height: 27),
                    if (_tab == 'overview')
                      _Overview(snapshot: snapshot)
                    else if (_tab == 'eligibility')
                      _Eligibility(snapshot: snapshot)
                    else
                      _ClaimGuide(snapshot: snapshot),
                    const SizedBox(height: 24),
                    const _FaqButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _setTab(String id) => setState(() => _tab = id);
}

class _ProtectionCard extends StatelessWidget {
  const _ProtectionCard({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 154),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _compPanel,
        border: Border.all(color: _compBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _compGreen.withValues(alpha: .13),
                  borderRadius: AppRadii.cardRadius,
                ),
                child: const Icon(
                  Icons.shield_outlined,
                  color: _compGreen,
                  size: 29,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Protected up to ${snapshot.coverageLimit}',
                        style: AppTextStyles.baseMedium.copyWith(
                          color: AppColors.text1,
                          fontSize: 16,
                          height: 1,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        snapshot.summary,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                          fontSize: 11,
                          height: 1.38,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.check_circle_outline,
                color: AppColors.text1,
                size: 15,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  snapshot.coveredMessage,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoNotice extends StatelessWidget {
  const _InfoNotice({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 6, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: AppColors.text1,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Automatic Protection',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 11,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.automaticProtection,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text1,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1.35,
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

class _Tabs extends StatelessWidget {
  const _Tabs({required this.activeId, required this.onChanged});

  final String activeId;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = [
      ('overview', 'Overview'),
      ('eligibility', 'Eligibility'),
      ('claim', 'How to Claim'),
    ];
    return Container(
      height: 53,
      color: _compPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: InvestorCompensationPage.tabKey(tab.$1),
                onTap: () => onChanged(tab.$1),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          tab.$2,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.caption.copyWith(
                            color: activeId == tab.$1
                                ? _compPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 100 : 0,
                      height: 2,
                      color: _compPrimary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('What Is FSCS?'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.overviewDescription,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text2,
                  fontSize: 11,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 8),
              for (final item in snapshot.overviewItems) ...[
                _InfoRow(item: item),
                if (item != snapshot.overviewItems.last)
                  const SizedBox(height: 11),
              ],
            ],
          ),
        ),
        const SizedBox(height: 26),
        const _SectionLabel('Coverage Limits'),
        const SizedBox(height: 12),
        _CoverageCard(snapshot: snapshot),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.item});

  final TradeInvestorCompensationInfo item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.check_circle_outline, color: _compGreen, size: 16),
        const SizedBox(width: 9),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.title,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                item.description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 10,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CoverageCard extends StatelessWidget {
  const _CoverageCard({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          for (final coverage in snapshot.coverageItems) ...[
            _CoverageBox(coverage: coverage),
            if (coverage != snapshot.coverageItems.last)
              const SizedBox(height: 12),
          ],
          const SizedBox(height: 13),
          _WarningBox(text: snapshot.warning),
        ],
      ),
    );
  }
}

class _CoverageBox extends StatelessWidget {
  const _CoverageBox({required this.coverage});

  final TradeInvestorCompensationCoverage coverage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 68,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 11),
      decoration: BoxDecoration(
        color: _compPanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  coverage.label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
                  ),
                ),
              ),
              Text(
                coverage.amount,
                style: AppTextStyles.baseMedium.copyWith(
                  color: coverage.emphasized ? _compGreen : AppColors.text1,
                  fontSize: 16,
                  height: 1,
                ),
              ),
            ],
          ),
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              coverage.caption,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 9,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBox extends StatelessWidget {
  const _WarningBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 10),
      decoration: BoxDecoration(
        color: _compAmber.withValues(alpha: .13),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline_rounded, color: _compAmber, size: 14),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _compAmber,
                fontSize: 10,
                fontWeight: AppTextStyles.bold,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Eligibility extends StatelessWidget {
  const _Eligibility({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('Who Is Eligible?'),
        const SizedBox(height: 12),
        _Card(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _EligibilityHeading('Eligible Customers:'),
              const SizedBox(height: 10),
              for (final item in snapshot.eligibleCustomers) ...[
                _Bullet(text: item, color: _compGreen),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 6),
              const _EligibilityHeading('Not Eligible:'),
              const SizedBox(height: 10),
              for (final item in snapshot.ineligibleCustomers) ...[
                _Bullet(text: item, color: _compRed),
                if (item != snapshot.ineligibleCustomers.last)
                  const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ClaimGuide extends StatelessWidget {
  const _ClaimGuide({required this.snapshot});

  final TradeInvestorCompensationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const _SectionLabel('How to Make a Claim'),
        const SizedBox(height: 12),
        for (final step in snapshot.claimSteps) ...[
          _ClaimStep(step: step),
          if (step != snapshot.claimSteps.last) const SizedBox(height: 12),
        ],
        const SizedBox(height: 12),
        SizedBox(
          height: 44,
          child: FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.open_in_new_rounded, size: 16),
            label: Text(
              'Visit FSCS Website',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.onAccent,
                fontSize: 13,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ClaimStep extends StatelessWidget {
  const _ClaimStep({required this.step});

  final TradeInvestorCompensationClaimStep step;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.all(13),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _compPrimary.withValues(alpha: .13),
              borderRadius: AppRadii.smRadius,
            ),
            alignment: Alignment.center,
            child: Text(
              '${step.step}',
              style: AppTextStyles.baseMedium.copyWith(
                color: _compPrimary,
                fontSize: 14,
                height: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  step.description,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    height: 1.35,
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

class _EligibilityHeading extends StatelessWidget {
  const _EligibilityHeading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.text1,
        fontSize: 12,
        fontWeight: AppTextStyles.bold,
        height: 1,
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  const _Bullet({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          color == _compGreen
              ? Icons.check_circle_outline
              : Icons.error_outline_rounded,
          color: color,
          size: 13,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqButton extends StatelessWidget {
  const _FaqButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        key: InvestorCompensationPage.faqKey,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          side: BorderSide(color: _compBorder.withValues(alpha: .72)),
          backgroundColor: _compPanel2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        onPressed: () {},
        child: Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: _compPrimary,
              size: 16,
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                'FSCS FAQs',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: _compPrimary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 7),
        Text(
          text,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _compPanel,
        border: Border.all(color: _compBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}
