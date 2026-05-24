import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_module_accents.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/p2p_repository.dart';

class P2PContributionHistoryPage extends ConsumerStatefulWidget {
  const P2PContributionHistoryPage({super.key, this.shellRenderMode});

  static const summaryKey = Key('sc242_p2p_contribution_summary');
  static const exportKey = Key('sc242_p2p_contribution_export');
  static const groupsKey = Key('sc242_p2p_contribution_groups');
  static const feedbackKey = Key('sc242_p2p_contribution_feedback');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PContributionHistoryPage> createState() =>
      _P2PContributionHistoryPageState();
}

class _P2PContributionHistoryPageState
    extends ConsumerState<P2PContributionHistoryPage> {
  String? _feedback;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(p2pRepositoryProvider).getContributionHistory();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-242 P2PContributionHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Lịch sử đóng góp',
              subtitle: 'Bảo hiểm · P2P',
              showBack: true,
              onBack: () => context.go(snapshot.parentRoute),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x4,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _ContributionSummaryCard(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      VitCtaButton(
                        key: P2PContributionHistoryPage.exportKey,
                        variant: VitCtaButtonVariant.secondary,
                        leading: const Icon(Icons.download_rounded),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          setState(
                            () => _feedback =
                                'Đã chuẩn bị báo cáo CSV lịch sử đóng góp',
                          );
                        },
                        child: const Text('Xuất CSV'),
                      ),
                      if (_feedback != null) ...[
                        const SizedBox(height: AppSpacing.x4),
                        _FeedbackBanner(message: _feedback!),
                      ],
                      const SizedBox(height: AppSpacing.x5),
                      _MonthlyContributionGroups(
                        groups: snapshot.monthlyGroups,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ContributionSummaryCard extends StatelessWidget {
  const _ContributionSummaryCard({required this.snapshot});

  final P2PContributionHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PContributionHistoryPage.summaryKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.trending_up_rounded,
                color: AppColors.buy,
                size: AppSpacing.iconMd,
              ),
              const SizedBox(width: AppSpacing.x3),
              Text(
                'Tổng quan đóng góp',
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x5),
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Tổng đóng góp',
                  value: '${_formatVnd(snapshot.totalContributed)} đ',
                  valueColor: AppColors.buy,
                ),
              ),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: _SummaryMetric(
                  label: 'Số giao dịch',
                  value: '${snapshot.totalTrades}',
                  valueColor: AppModuleAccents.p2p,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x4),
          _SummaryLine(
            label: 'Trung bình/giao dịch',
            value: '${_formatVnd(snapshot.averagePerTrade)} đ',
          ),
          const SizedBox(height: AppSpacing.x3),
          _SummaryLine(
            label: 'Tỷ lệ phí',
            value: snapshot.contributionRateLabel,
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x1),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              color: valueColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.baseMedium.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _FeedbackBanner extends StatelessWidget {
  const _FeedbackBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PContributionHistoryPage.feedbackKey,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.sm,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline_rounded,
            color: AppColors.buy,
            size: 18,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text1,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthlyContributionGroups extends StatelessWidget {
  const _MonthlyContributionGroups({required this.groups});

  final List<P2PContributionMonthDraft> groups;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PContributionHistoryPage.groupsKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < groups.length; i++) ...[
          _MonthGroup(group: groups[i]),
          if (i != groups.length - 1) const SizedBox(height: AppSpacing.x6),
        ],
      ],
    );
  }
}

class _MonthGroup extends StatelessWidget {
  const _MonthGroup({required this.group});

  final P2PContributionMonthDraft group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.calendar_month_outlined,
              color: AppColors.text2,
              size: 18,
            ),
            const SizedBox(width: AppSpacing.x2),
            Expanded(
              child: Text(
                group.monthLabel,
                style: AppTextStyles.baseMedium.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${group.count} giao dịch',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
                Text(
                  '${_formatVnd(group.totalAmount)} đ',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final contribution in group.contributions) ...[
          _ContributionCard(contribution: contribution),
          if (contribution != group.contributions.last)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _ContributionCard extends StatelessWidget {
  const _ContributionCard({required this.contribution});

  final P2PContributionDraft contribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        contribution.orderId,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _CoinPill(label: contribution.coin),
                  ],
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  contribution.displayDate,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text3),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  'GD: ${_formatVnd(contribution.orderAmount)} đ',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x4),
          SizedBox(
            width: 112,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    '+${_formatVnd(contribution.contributionAmount)} đ',
                    textAlign: TextAlign.right,
                    style: AppTextStyles.baseMedium.copyWith(
                      color: AppColors.buy,
                      fontWeight: AppTextStyles.bold,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  '${contribution.feeRate.toStringAsFixed(1)}% phí',
                  textAlign: TextAlign.right,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface3,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(int value) {
  final digits = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}
