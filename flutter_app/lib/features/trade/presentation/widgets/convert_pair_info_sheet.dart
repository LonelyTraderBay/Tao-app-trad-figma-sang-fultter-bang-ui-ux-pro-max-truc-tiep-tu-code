import 'package:flutter/material.dart';
import 'package:vit_trade_flutter/app/theme/app_density.dart';
import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_cta_button.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_info_row.dart';
import 'package:vit_trade_flutter/shared/widgets/vit_sheet_handle.dart';

class ConvertPairInfoSheet extends StatelessWidget {
  const ConvertPairInfoSheet({
    required this.fromSymbol,
    required this.toSymbol,
    required this.modeLabel,
    required this.quoteLabel,
    required this.countdownLabel,
    required this.minUsd,
    required this.maxUsd,
    required this.slippageLabel,
    this.pairId,
    this.onViewTokenInfo,
    super.key,
  });

  final String fromSymbol;
  final String toSymbol;
  final String modeLabel;
  final String quoteLabel;
  final String countdownLabel;
  final double minUsd;
  final double maxUsd;
  final String slippageLabel;
  final String? pairId;
  final VoidCallback? onViewTokenInfo;

  @override
  Widget build(BuildContext context) {
    return VitSheetPanel(
      title: 'Thông tin cặp',
      child: ListView(
        shrinkWrap: true,
        children: [
          VitInfoRow(
            label: 'Cặp',
            value: '$fromSymbol/$toSymbol',
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Chế độ',
            value: modeLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Tỷ giá',
            value: quoteLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Hết hạn sau',
            value: countdownLabel,
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Tối thiểu (USD)',
            value: '\$${minUsd.toStringAsFixed(0)}',
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Tối đa (USD)',
            value: '\$${maxUsd.toStringAsFixed(0)}',
            density: VitDensity.compact,
            showDivider: true,
          ),
          VitInfoRow(
            label: 'Độ trượt giá',
            value: slippageLabel,
            density: VitDensity.compact,
            showDivider: pairId != null && onViewTokenInfo != null,
          ),
          if (pairId != null && onViewTokenInfo != null) ...[
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              variant: VitCtaButtonVariant.ghost,
              onPressed: onViewTokenInfo,
              child: const Text('Xem thông tin token'),
            ),
          ],
        ],
      ),
    );
  }
}
