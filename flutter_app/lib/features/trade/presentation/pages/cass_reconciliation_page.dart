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
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _cassBackground = AppColors.bg;
const _cassPanel = AppColors.surface;
const _cassPanel2 = AppColors.surface2;
const _cassBorder = AppColors.borderSolid;
const _cassPrimary = AppColors.primary;
const _cassGreen = Color(0xFF10B981);
const _cassAmber = Color(0xFFF59E0B);
const _cassRed = Color(0xFFEF4444);

class CassReconciliationPage extends ConsumerStatefulWidget {
  const CassReconciliationPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc103_cass_content');
  static const exportKey = Key('sc103_cass_export');
  static Key tabKey(String id) => Key('sc103_cass_tab_$id');
  static Key recordKey(String id) => Key('sc103_cass_record_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<CassReconciliationPage> createState() =>
      _CassReconciliationPageState();
}

class _CassReconciliationPageState
    extends ConsumerState<CassReconciliationPage> {
  String _tab = 'recent';

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getCassReconciliation();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + 70
            : DeviceMetrics.nativeBottomChrome + 28) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-103 CASSReconciliationPage',
      child: Material(
        color: _cassBackground,
        child: Column(
          children: [
            VitHeader(
              title: 'CASS Reconciliation',
              subtitle: 'Daily Client Money Matching',
              showBack: true,
              onBack: () =>
                  context.go(AppRoutePaths.tradeCopyClientMoneyProtection),
            ),
            Expanded(
              child: SingleChildScrollView(
                key: CassReconciliationPage.contentKey,
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SummaryGrid(snapshot: snapshot),
                    const SizedBox(height: 25),
                    _Tabs(activeId: _tab, onChanged: _setTab),
                    const SizedBox(height: 24),
                    const _SectionLabel('Reconciliation Records'),
                    const SizedBox(height: 12),
                    for (final record in snapshot.records) ...[
                      _RecordCard(record: record),
                      if (record != snapshot.records.last)
                        const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 23),
                    const _ExportButton(),
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.snapshot});

  final TradeCassReconciliationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            label: 'Reconciled',
            value: '${snapshot.reconciledCount}',
            caption: 'Last 7 days',
            captionColor: _cassGreen,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Resolved',
            value: '${snapshot.resolvedCount}',
            caption: 'Discrepancies',
            captionColor: AppColors.text3,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            label: 'Outstanding',
            value: '${snapshot.outstandingCount}',
            caption: 'None',
            captionColor: _cassGreen,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.captionColor,
  });

  final String label;
  final String value;
  final String caption;
  final Color captionColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 89,
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
      decoration: BoxDecoration(
        color: _cassPanel,
        border: Border.all(color: _cassBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
              height: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.heroNumber.copyWith(
              color: AppColors.text1,
              fontSize: 21,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            caption,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: captionColor,
              fontSize: 9,
              height: 1,
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
    const tabs = [('recent', 'Recent (7 Days)'), ('history', 'History')];
    return Container(
      height: 53,
      color: _cassPanel,
      child: Row(
        children: [
          for (final tab in tabs)
            Expanded(
              child: InkWell(
                key: CassReconciliationPage.tabKey(tab.$1),
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
                                ? _cassPrimary
                                : AppColors.text3,
                            fontSize: 12,
                            fontWeight: AppTextStyles.bold,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: activeId == tab.$1 ? 161 : 0,
                      height: 2,
                      color: _cassPrimary,
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

class _RecordCard extends StatelessWidget {
  const _RecordCard({required this.record});

  final TradeCassReconciliationRecord record;

  @override
  Widget build(BuildContext context) {
    final tone = _toneFor(record.status);
    return Container(
      key: CassReconciliationPage.recordKey(record.id),
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 16),
      decoration: BoxDecoration(
        color: _cassPanel,
        border: Border.all(color: _cassBorder.withValues(alpha: .72)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: tone.color.withValues(alpha: .13),
                  borderRadius: AppRadii.inputRadius,
                ),
                child: Icon(tone.icon, color: tone.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              record.displayDate,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.text1,
                                fontSize: 13,
                                fontWeight: AppTextStyles.bold,
                                height: 1,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _StatusPill(label: tone.label, color: tone.color),
                        ],
                      ),
                      if (record.notes != null) ...[
                        const SizedBox(height: 9),
                        Text(
                          record.notes!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.text3,
                            fontSize: 10,
                            height: 1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: _MetricBox(
                  label: 'Client Ledger',
                  value: _formatUsd(record.clientLedger),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Bank Balance',
                  value: _formatUsd(record.bankBalance),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _MetricBox(
                  label: 'Difference',
                  value: _formatUsd(record.difference.abs()),
                  valueColor: record.difference == 0 ? _cassGreen : tone.color,
                  background: record.difference == 0
                      ? _cassGreen.withValues(alpha: .13)
                      : tone.color.withValues(alpha: .13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricBox extends StatelessWidget {
  const _MetricBox({
    required this.label,
    required this.value,
    this.valueColor = AppColors.text1,
    this.background = _cassPanel2,
  });

  final String label;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 47,
      padding: const EdgeInsets.fromLTRB(8, 9, 8, 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 9,
              height: 1,
            ),
          ),
          const Spacer(),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _ExportButton extends StatelessWidget {
  const _ExportButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        key: CassReconciliationPage.exportKey,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text1,
          side: BorderSide(color: _cassBorder.withValues(alpha: .72)),
          backgroundColor: _cassPanel2,
          shape: RoundedRectangleBorder(borderRadius: AppRadii.inputRadius),
        ),
        onPressed: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded, size: 16),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Export Reconciliation Report (CSV)',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
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
            color: _cassPrimary,
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

_RecordTone _toneFor(TradeCassReconciliationStatus status) {
  return switch (status) {
    TradeCassReconciliationStatus.matched => const _RecordTone(
      label: 'Matched',
      color: _cassGreen,
      icon: Icons.check_circle_outline_rounded,
    ),
    TradeCassReconciliationStatus.discrepancyResolved => const _RecordTone(
      label: 'Resolved',
      color: _cassAmber,
      icon: Icons.check_circle_outline_rounded,
    ),
    TradeCassReconciliationStatus.discrepancy => const _RecordTone(
      label: 'Discrepancy',
      color: _cassRed,
      icon: Icons.warning_amber_rounded,
    ),
  };
}

final class _RecordTone {
  const _RecordTone({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;
}

String _formatUsd(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var index = 0; index < whole.length; index += 1) {
    if (index > 0 && (whole.length - index) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(whole[index]);
  }
  return '\$${buffer.toString()}.${parts.last}';
}
