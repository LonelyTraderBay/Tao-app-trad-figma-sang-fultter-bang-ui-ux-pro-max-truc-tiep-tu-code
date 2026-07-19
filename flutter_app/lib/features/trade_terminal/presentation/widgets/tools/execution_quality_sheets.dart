import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/features/trade_terminal/presentation/widgets/tools/execution_quality_common.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';
import 'package:vit_trade_flutter/app/theme/spacing/trade_spacing_tokens.dart';
import 'package:vit_trade_flutter/features/trade_terminal/domain/entities/trade_terminal_entities.dart';

class ExecutionQualitySlippageSheet extends StatefulWidget {
  const ExecutionQualitySlippageSheet({required this.settings, super.key});

  final TradeSlippageSettings settings;

  @override
  State<ExecutionQualitySlippageSheet> createState() =>
      _ExecutionQualitySlippageSheetState();
}

class ExecutionQualityExecutionSheet extends StatelessWidget {
  const ExecutionQualityExecutionSheet({required this.report, super.key});

  final TradeExecutionReport report;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Execution Report',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _executionSheetRow(
            label: 'Order ID',
            value: report.orderId,
            isCode: true,
          ),
          _executionSheetRow(label: 'Symbol', value: report.symbol),
          _executionSheetRow(
            label: 'Average fill',
            value: '\$${formatExecutionQualityMoney(report.averageFillPrice)}',
          ),
          _executionSheetRow(
            label: 'Execution time',
            value: '${report.executionTimeMs}ms',
          ),
          _executionSheetRow(
            label: 'Savings',
            value: '\$${report.savingsVsSingleVenue.toStringAsFixed(2)}',
          ),
          const SizedBox(height: TradeSpacingTokens.tradeToolIconGap),
          for (final fill in report.fills) ...[
            _FillTile(fill: fill),
            if (fill != report.fills.last)
              const SizedBox(height: TradeSpacingTokens.tradeToolInlineGap),
          ],
        ],
      ),
    );
  }
}

class ExecutionQualityAmendmentSheet extends StatelessWidget {
  const ExecutionQualityAmendmentSheet({required this.order, super.key});

  final TradeExecutionOpenOrder order;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Modify Order',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _executionSheetRow(label: 'Order ID', value: order.id, isCode: true),
          _executionSheetRow(label: 'Symbol', value: order.symbol),
          _executionSheetRow(
            label: 'Current price',
            value: '\$${formatExecutionQualityMoney(order.price)}',
          ),
          _executionSheetRow(
            label: 'Queue position',
            value: '#${order.queuePosition} / ${order.totalInQueue}',
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ExecutionQualityGradientButton(
            key: executionQualityAmendmentSaveKey,
            label: 'Modify Order',
            icon: Icons.check_rounded,
            colors: const [AppColors.accent, AppColors.accentDark],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _ExecutionQualitySlippageSheetState
    extends State<ExecutionQualitySlippageSheet> {
  late double _tolerance = widget.settings.tolerancePct;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Slippage Protection',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Set max slippage tolerance before the order is rejected.',
            style: AppTextStyles.caption.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: TradeSpacingTokens.tradeToolPageTopGap),
          Row(
            children: [
              for (final value in const [.1, .5, 1.0]) ...[
                Expanded(
                  child: _ToleranceChip(
                    value: value,
                    active: _tolerance == value,
                    onTap: () => setState(() => _tolerance = value),
                  ),
                ),
                if (value != 1.0)
                  const SizedBox(width: TradeSpacingTokens.tradeToolInlineGap),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          ExecutionQualityGradientButton(
            key: executionQualitySlippageSaveKey,
            label: 'Save Slippage Settings',
            icon: Icons.check_rounded,
            colors: const [AppColors.buy, AppColors.buyDark],
            onTap: () => Navigator.pop(
              context,
              TradeSlippageSettings(
                tolerancePct: _tolerance,
                rejectOnExceed: true,
                partialFillAllowed: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: title,
      child: SingleChildScrollView(child: child),
    );
  }
}

class _ToleranceChip extends StatelessWidget {
  const _ToleranceChip({
    required this.value,
    required this.active,
    required this.onTap,
  });

  final double value;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // card-tile: allow-start — fixed surface, not horizontal strip tile
    return VitCard(
      key: executionQualityToleranceKey(value),
      height: TradeSpacingTokens.tradeToolRiskTabHeight,
      alignment: Alignment.center,
      radius: VitCardRadius.tight,
      onTap: onTap,
      variant: active ? VitCardVariant.standard : VitCardVariant.inner,
      borderColor: active ? AppColors.buy : AppColors.cardBorder,
      child: Text(
        '${value.toStringAsFixed(1)}%',
        style: AppTextStyles.caption.copyWith(
          color: active ? AppColors.buy : AppColors.text2,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _FillTile extends StatelessWidget {
  const _FillTile({required this.fill});

  final TradeExecutionFill fill;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: TradeSpacingTokens.tradeToolMetricRowPadding,
      variant: VitCardVariant.inner,
      radius: VitCardRadius.tight,
      child: Row(
        children: [
          Expanded(
            child: Text(
              fill.venue,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '${fill.amount.toStringAsFixed(1)} BTC @ \$${formatExecutionQualityMoney(fill.price)}',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

Widget _executionSheetRow({
  required String label,
  required String value,
  bool isCode = false,
}) {
  return VitKeyValueRow(
    label: label,
    value: value,
    padding: TradeSpacingTokens.tradeToolSheetRowPadding,
    valueOverflow: TextOverflow.ellipsis,
    valueStyle: (isCode ? AppTextStyles.monoCode : AppTextStyles.caption)
        .copyWith(
          fontWeight: AppTextStyles.bold,
          fontFeatures: isCode ? null : AppTextStyles.tabularFigures,
        ),
  );
}
