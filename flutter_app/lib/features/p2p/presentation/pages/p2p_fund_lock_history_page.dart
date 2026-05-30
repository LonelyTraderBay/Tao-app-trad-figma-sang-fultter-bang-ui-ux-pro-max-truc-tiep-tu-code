import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_header.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/providers/p2p_controller_providers.dart';

class P2PFundLockHistoryPage extends ConsumerWidget {
  const P2PFundLockHistoryPage({
    super.key,
    this.walletHistoryAlias = false,
    this.shellRenderMode,
  });

  static const heroKey = Key('sc262_p2p_fund_lock_hero');
  static const listKey = Key('sc262_p2p_fund_lock_list');

  static Key recordKey(String id) => Key('sc262_p2p_fund_lock_record_$id');

  final bool walletHistoryAlias;
  final ShellRenderMode? shellRenderMode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshot = ref.watch(p2pFundLockHistoryProvider(walletHistoryAlias));
    final mode = shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x5
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: walletHistoryAlias
          ? 'SC-263 P2PFundLockHistoryPage'
          : 'SC-262 P2PFundLockHistoryPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
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
                      _FundLockHero(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x5),
                      _FundLockList(records: snapshot.records),
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

class _FundLockHero extends StatelessWidget {
  const _FundLockHero({required this.snapshot});

  final P2PFundLockHistorySnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      key: P2PFundLockHistoryPage.heroKey,
      decoration: BoxDecoration(
        color: AppModuleAccents.p2p,
        borderRadius: AppRadii.cardLargeRadius,
        border: Border.all(color: AppModuleAccents.p2p),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.x4),
        child: Row(
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.onAccent.withValues(alpha: .20),
                borderRadius: AppRadii.lgRadius,
              ),
              child: const SizedBox(
                width: AppSpacing.inputHeight,
                height: AppSpacing.inputHeight,
                child: Icon(
                  Icons.lock_outline_rounded,
                  color: AppColors.onAccent,
                  size: AppSpacing.iconMd,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.x4),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.heroTitle,
                    style: AppTextStyles.sectionTitle.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x1),
                  Text(
                    '${snapshot.records.length} giao dịch gần đây',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onAccent.withValues(alpha: .88),
                      fontWeight: AppTextStyles.medium,
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

class _FundLockList extends StatelessWidget {
  const _FundLockList({required this.records});

  final List<P2PFundLockRecordDraft> records;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: P2PFundLockHistoryPage.listKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < records.length; index++) ...[
          _FundLockRecordCard(record: records[index]),
          if (index != records.length - 1)
            const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _FundLockRecordCard extends StatelessWidget {
  const _FundLockRecordCard({required this.record});

  final P2PFundLockRecordDraft record;

  @override
  Widget build(BuildContext context) {
    final isLock = record.type == 'lock';
    final color = isLock ? AppColors.warn : AppColors.buy;

    return VitCard(
      key: P2PFundLockHistoryPage.recordKey(record.id),
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: color.withValues(alpha: .14),
              borderRadius: AppRadii.lgRadius,
            ),
            child: SizedBox(
              width: AppSpacing.inputHeight,
              height: AppSpacing.inputHeight,
              child: Icon(
                isLock ? Icons.lock_outline_rounded : Icons.lock_open_rounded,
                color: color,
                size: AppSpacing.iconSm,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        '${_formatFundLockAmount(record.amount, record.asset)} ${record.asset}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.baseMedium.copyWith(
                          fontWeight: AppTextStyles.bold,
                          fontFeatures: AppTextStyles.tabularFigures,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.x2),
                    _StatusPill(label: isLock ? 'Khóa' : 'Mở', color: color),
                  ],
                ),
                const SizedBox(height: AppSpacing.x2),
                Text(
                  record.reason,
                  style: AppTextStyles.caption.copyWith(color: AppColors.text2),
                ),
                const SizedBox(height: AppSpacing.x1),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: AppColors.text3,
                      size: 12,
                    ),
                    const SizedBox(width: AppSpacing.x1),
                    Text(
                      record.timestamp,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontFeatures: AppTextStyles.tabularFigures,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.x2),
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.text3,
            size: AppSpacing.iconSm,
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
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.smRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatFundLockAmount(double value, String asset) {
  if (asset == 'VND') {
    return _withDotThousands(value.toStringAsFixed(0));
  }
  if (asset == 'BTC') {
    return value.toStringAsFixed(8);
  }
  return _withCommaThousands(value.toStringAsFixed(2));
}

String _withDotThousands(String value) {
  final buffer = StringBuffer();
  for (var i = 0; i < value.length; i++) {
    final remaining = value.length - i;
    buffer.write(value[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return buffer.toString();
}

String _withCommaThousands(String value) {
  final parts = value.split('.');
  final whole = parts.first;
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    final remaining = whole.length - i;
    buffer.write(whole[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write(',');
    }
  }
  if (parts.length > 1) {
    buffer.write('.');
    buffer.write(parts[1]);
  }
  return buffer.toString();
}
