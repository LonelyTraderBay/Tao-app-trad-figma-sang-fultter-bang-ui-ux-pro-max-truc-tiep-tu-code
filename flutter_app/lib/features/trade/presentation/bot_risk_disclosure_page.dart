import 'package:flutter/material.dart';
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

const _botRiskBackground = AppColors.bg;
const _botRiskPanel = AppColors.surface;
const _botRiskPanel2 = AppColors.surface2;
const _botRiskRed = Color(0xFFEF4444);
const _botRiskAmber = Color(0xFFF59E0B);
const _botRiskPurple = Color(0xFF8B5CF6);
const _botRiskPrimary = AppColors.primary;
const _botRiskGreen = Color(0xFF10B981);

class BotRiskDisclosurePage extends ConsumerStatefulWidget {
  const BotRiskDisclosurePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc118_bot_risk_content');
  static const acknowledgmentKey = Key('sc118_bot_risk_acknowledgment');
  static const ctaKey = Key('sc118_bot_risk_cta');
  static Key categoryKey(String id) => Key('sc118_bot_risk_category_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<BotRiskDisclosurePage> createState() =>
      _BotRiskDisclosurePageState();
}

class _BotRiskDisclosurePageState extends ConsumerState<BotRiskDisclosurePage> {
  bool _acknowledged = false;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getBotRiskDisclosure();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 112
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-118 BotRiskDisclosurePage',
      child: Material(
        color: _botRiskBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'Risk Disclosure',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.tradeBots),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: BotRiskDisclosurePage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _HighRiskBanner(snapshot: snapshot),
                    const SizedBox(height: 18),
                    _PastPerformanceCard(snapshot: snapshot),
                    const SizedBox(height: 22),
                    _SectionLabel(snapshot.riskSectionLabel),
                    const SizedBox(height: 12),
                    for (final category in snapshot.categories) ...[
                      _RiskCategoryCard(category: category),
                      if (category != snapshot.categories.last)
                        const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 22),
                    _SectionLabel(snapshot.additionalWarningsLabel),
                    const SizedBox(height: 12),
                    _AdditionalWarningsCard(
                      warnings: snapshot.additionalWarnings,
                    ),
                    const SizedBox(height: 22),
                    _SectionLabel(snapshot.regulatoryNoticeLabel),
                    const SizedBox(height: 12),
                    _RegulatoryNoticeCard(snapshot: snapshot),
                    const SizedBox(height: 22),
                    _SectionLabel(snapshot.acknowledgmentLabel),
                    const SizedBox(height: 12),
                    _AcknowledgmentCard(
                      snapshot: snapshot,
                      acknowledged: _acknowledged,
                      onTap: () =>
                          setState(() => _acknowledged = !_acknowledged),
                    ),
                    const SizedBox(height: 16),
                    _RiskCta(
                      snapshot: snapshot,
                      acknowledged: _acknowledged,
                      onPressed: () => context.go(snapshot.nextPath),
                    ),
                    const SizedBox(height: 16),
                    _HelpCard(snapshot: snapshot),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighRiskBanner extends StatelessWidget {
  const _HighRiskBanner({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 153),
      padding: const EdgeInsets.fromLTRB(16, 19, 16, 17),
      decoration: BoxDecoration(
        color: _botRiskRed.withValues(alpha: .12),
        border: Border.all(color: _botRiskRed.withValues(alpha: .58), width: 2),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.warning_amber_rounded,
              color: _botRiskRed,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.highRiskTitle,
                  style: AppTextStyles.baseMedium.copyWith(
                    color: _botRiskRed,
                    fontSize: 16,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  snapshot.highRiskBody,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 13,
                    fontWeight: AppTextStyles.medium,
                    height: 1.7,
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

class _PastPerformanceCard extends StatelessWidget {
  const _PastPerformanceCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.trending_down_rounded,
              color: AppColors.text3,
              size: 21,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.pastPerformanceTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.pastPerformanceBody,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.62,
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

class _RiskCategoryCard extends StatelessWidget {
  const _RiskCategoryCard({required this.category});

  final TradeBotRiskCategory category;

  @override
  Widget build(BuildContext context) {
    final color = _colorForKind(category.kind);
    return _Card(
      key: BotRiskDisclosurePage.categoryKey(category.id),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: AppRadii.cardLargeRadius,
                ),
                child: Icon(
                  _iconForKind(category.kind),
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: AppTextStyles.body.copyWith(
                        color: color,
                        fontSize: 14,
                        fontWeight: AppTextStyles.bold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Text(
                      category.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'REAL EXAMPLES:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
          const SizedBox(height: 11),
          for (final example in category.examples) ...[
            _BulletText(example, color: AppColors.text2),
            if (example != category.examples.last) const SizedBox(height: 8),
          ],
          const SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 13),
            decoration: BoxDecoration(
              color: _botRiskPanel2,
              borderRadius: AppRadii.cardRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HOW TO MITIGATE:',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 10,
                    fontWeight: AppTextStyles.bold,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  category.mitigation,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.5,
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

class _AdditionalWarningsCard extends StatelessWidget {
  const _AdditionalWarningsCard({required this.warnings});

  final List<TradeBotRiskWarning> warnings;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 7),
      child: Column(
        children: [
          for (final warning in warnings) ...[
            _WarningBlock(warning: warning),
            if (warning != warnings.last)
              const Divider(color: AppColors.borderSolid, height: 19),
          ],
        ],
      ),
    );
  }
}

class _WarningBlock extends StatelessWidget {
  const _WarningBlock({required this.warning});

  final TradeBotRiskWarning warning;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _botRiskAmber,
                size: 14,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  warning.title,
                  style: AppTextStyles.caption.copyWith(
                    color: _botRiskRed,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                    height: 1.18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            warning.text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _RegulatoryNoticeCard extends StatelessWidget {
  const _RegulatoryNoticeCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return _Card(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.regulatoryTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 13,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            snapshot.regulatoryBody,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontSize: 12,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 12),
          for (final note in snapshot.regulatoryNotes) ...[
            _BulletText(note, color: AppColors.text3),
            if (note != snapshot.regulatoryNotes.last)
              const SizedBox(height: 7),
          ],
        ],
      ),
    );
  }
}

class _AcknowledgmentCard extends StatelessWidget {
  const _AcknowledgmentCard({
    required this.snapshot,
    required this.acknowledged,
    required this.onTap,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: BotRiskDisclosurePage.acknowledgmentKey,
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 101),
        padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
        decoration: BoxDecoration(
          color: _botRiskPanel2,
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
                color: acknowledged ? _botRiskRed : Colors.transparent,
                border: Border.all(
                  color: acknowledged ? _botRiskRed : AppColors.borderSolid,
                ),
                borderRadius: AppRadii.mdRadius,
              ),
              child: acknowledged
                  ? const Icon(
                      Icons.check_circle_outline_rounded,
                      color: Colors.white,
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
                    snapshot.acknowledgmentTitle,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text1,
                      fontSize: 13,
                      fontWeight: AppTextStyles.bold,
                      height: 1.28,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    snapshot.acknowledgmentDescription,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.38,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RiskCta extends StatelessWidget {
  const _RiskCta({
    required this.snapshot,
    required this.acknowledged,
    required this.onPressed,
  });

  final TradeBotRiskDisclosureSnapshot snapshot;
  final bool acknowledged;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: BotRiskDisclosurePage.ctaKey,
      height: 44,
      child: FilledButton(
        onPressed: acknowledged ? onPressed : null,
        style: FilledButton.styleFrom(
          backgroundColor: acknowledged ? _botRiskRed : _botRiskPanel2,
          disabledBackgroundColor: _botRiskPanel2,
          disabledForegroundColor: AppColors.text3,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        child: Text(
          acknowledged ? snapshot.enabledCta : snapshot.disabledCta,
          style: AppTextStyles.body.copyWith(
            color: acknowledged ? Colors.white : AppColors.text3,
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

class _HelpCard extends StatelessWidget {
  const _HelpCard({required this.snapshot});

  final TradeBotRiskDisclosureSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 15),
      decoration: BoxDecoration(
        color: _botRiskPanel2,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            snapshot.helpTitle,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            snapshot.helpDescription,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            snapshot.helpCta,
            style: AppTextStyles.caption.copyWith(
              color: _botRiskPrimary,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              height: 1,
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
            color: _botRiskPrimary,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 7),
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

class _BulletText extends StatelessWidget {
  const _BulletText(this.text, {required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '•',
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 12,
            height: 1.45,
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({super.key, required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _botRiskPanel,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

Color _colorForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => _botRiskRed,
    TradeBotRiskKind.leverage => _botRiskAmber,
    TradeBotRiskKind.liquidity => _botRiskPurple,
    TradeBotRiskKind.technical => _botRiskRed,
    TradeBotRiskKind.timing => _botRiskPrimary,
    TradeBotRiskKind.regulatory => _botRiskGreen,
  };
}

IconData _iconForKind(TradeBotRiskKind kind) {
  return switch (kind) {
    TradeBotRiskKind.market => Icons.trending_down_rounded,
    TradeBotRiskKind.leverage => Icons.bolt_rounded,
    TradeBotRiskKind.liquidity => Icons.attach_money_rounded,
    TradeBotRiskKind.technical => Icons.warning_amber_rounded,
    TradeBotRiskKind.timing => Icons.schedule_rounded,
    TradeBotRiskKind.regulatory => Icons.shield_outlined,
  };
}
