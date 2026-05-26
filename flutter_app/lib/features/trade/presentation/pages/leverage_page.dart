import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
import 'package:vit_trade_flutter/app/theme/app_colors.dart';
import 'package:vit_trade_flutter/app/theme/app_radii.dart';
import 'package:vit_trade_flutter/app/theme/app_text_styles.dart';
import 'package:vit_trade_flutter/app/theme/device_metrics.dart';
import 'package:vit_trade_flutter/shared/layout/shell_render_mode.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_layout.dart';
import 'package:vit_trade_flutter/features/trade/data/trade_repository.dart';

const _tradePrimary = AppColors.primary;
const _tradePrimaryDark = AppColors.primaryDark;
const _panelBackground = AppColors.surface;
const _chipBackground = AppColors.surface2;

class LeveragePage extends ConsumerStatefulWidget {
  const LeveragePage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc058_leverage_scroll_content');
  static const backKey = Key('sc058_back');
  static const sliderKey = Key('sc058_slider');
  static const confirmKey = Key('sc058_confirm');

  static Key stopKey(int leverage) => Key('sc058_stop_$leverage');
  static Key presetKey(int leverage) => Key('sc058_preset_$leverage');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<LeveragePage> createState() => _LeveragePageState();
}

class _LeveragePageState extends ConsumerState<LeveragePage> {
  late int _leverage;

  @override
  void initState() {
    super.initState();
    final snapshot = ref
        .read(tradeRepositoryProvider)
        .getFuturesLeverage(pairId: widget.pairId);
    _leverage = snapshot.currentLeverage;
  }

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(tradeRepositoryProvider);
    final snapshot = repo.getFuturesLeverage(pairId: widget.pairId);
    final request = TradeFuturesLeverageRequest(
      pairId: widget.pairId,
      leverage: _leverage,
      exampleMargin: snapshot.exampleMargin,
    );
    final preview = repo.previewFuturesLeverage(request);
    final riskColor = Color(preview.riskColorHex);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 34 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-058 LeveragePage',
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          key: LeveragePage.contentKey,
          padding: EdgeInsets.only(bottom: bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: _LeverageHeader(
                  currentLeverage: snapshot.currentLeverage,
                  onBack: _returnToFutures,
                ),
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, thickness: 1, color: AppColors.divider),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _LeverageHero(preview: preview, riskColor: riskColor),
                    const SizedBox(height: 20),
                    _RiskMeter(preview: preview, riskColor: riskColor),
                    const SizedBox(height: 19),
                    _LeverageSlider(
                      leverage: _leverage,
                      stops: snapshot.sliderStops,
                      riskColor: riskColor,
                      onChanged: _setLeverage,
                    ),
                    const SizedBox(height: 19),
                    _PresetGrid(
                      presets: snapshot.presets,
                      active: _leverage,
                      onChanged: _setLeverage,
                    ),
                    const SizedBox(height: 20),
                    _ImpactCard(
                      margin: snapshot.exampleMargin,
                      preview: preview,
                    ),
                    const SizedBox(height: 20),
                    _WarningCard(preview: preview),
                    if (preview.showRiskTips) ...[
                      const SizedBox(height: 12),
                      const _RiskTipsCard(),
                    ],
                    const SizedBox(height: 38),
                    _ConfirmButton(
                      leverage: _leverage,
                      onPressed: () => _confirm(request),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _setLeverage(int leverage) {
    setState(() => _leverage = leverage.clamp(1, 100).toInt());
  }

  void _confirm(TradeFuturesLeverageRequest request) {
    ref.read(tradeRepositoryProvider).submitFuturesLeverage(request);
    _returnToFutures();
  }

  void _returnToFutures() {
    context.go(AppRoutePaths.tradeFutures(widget.pairId));
  }
}

class _LeverageHeader extends StatelessWidget {
  const _LeverageHeader({required this.currentLeverage, required this.onBack});

  final int currentLeverage;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          InkWell(
            key: LeveragePage.backKey,
            onTap: onBack,
            borderRadius: AppRadii.cardRadius,
            child: const SizedBox(
              width: 36,
              height: 36,
              child: Icon(
                Icons.chevron_left_rounded,
                color: AppColors.text1,
                size: 26,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Điều chỉnh đòn bẩy',
                  style: AppTextStyles.sectionTitle.copyWith(
                    fontSize: 18,
                    height: 1.12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hiện tại: ${currentLeverage}x',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1,
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

class _LeverageHero extends StatelessWidget {
  const _LeverageHero({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 178,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
      decoration: BoxDecoration(
        color: riskColor.withValues(alpha: .08),
        borderRadius: AppRadii.lgRadius,
        border: Border.all(color: riskColor.withValues(alpha: .32), width: 1.5),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            riskColor.withValues(alpha: .10),
            riskColor.withValues(alpha: .04),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.bolt_rounded, color: riskColor, size: 21),
              const SizedBox(width: 8),
              Text(
                'Đòn bẩy',
                style: AppTextStyles.caption.copyWith(fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${preview.leverage}x',
            style: AppTextStyles.display.copyWith(
              color: riskColor,
              fontSize: 56,
              height: 1,
              fontWeight: FontWeight.w900,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: riskColor.withValues(alpha: .13),
              borderRadius: AppRadii.xlRadius,
              border: Border.all(color: riskColor.withValues(alpha: .32)),
            ),
            child: Text(
              'Rủi ro: ${preview.riskLabel}',
              style: AppTextStyles.caption.copyWith(
                color: riskColor,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskMeter extends StatelessWidget {
  const _RiskMeter({required this.preview, required this.riskColor});

  final TradeFuturesLeveragePreview preview;
  final Color riskColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Mức rủi ro',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
            Text(
              preview.riskLabel,
              style: AppTextStyles.caption.copyWith(
                color: riskColor,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var level = 1; level <= 6; level++) ...[
              Expanded(
                child: Container(
                  height: 7,
                  decoration: BoxDecoration(
                    color: level <= preview.riskLevel
                        ? _segmentColor(level)
                        : _chipBackground,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              if (level != 6) const SizedBox(width: 5),
            ],
          ],
        ),
      ],
    );
  }

  Color _segmentColor(int level) {
    if (level <= 2) return const Color(0xFF10B981);
    if (level <= 4) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }
}

class _LeverageSlider extends StatelessWidget {
  const _LeverageSlider({
    required this.leverage,
    required this.stops,
    required this.riskColor,
    required this.onChanged,
  });

  final int leverage;
  final List<int> stops;
  final Color riskColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Kéo để điều chỉnh',
          style: AppTextStyles.caption.copyWith(
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 4,
            activeTrackColor: riskColor,
            inactiveTrackColor: const Color(0xFF9CA3AF),
            thumbColor: riskColor,
            overlayColor: riskColor.withValues(alpha: .12),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 18),
          ),
          child: Slider(
            key: LeveragePage.sliderKey,
            min: 1,
            max: 100,
            divisions: 99,
            value: leverage.toDouble(),
            onChanged: (value) => onChanged(value.round()),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            for (final stop in stops) ...[
              Expanded(
                child: _StopButton(
                  leverage: stop,
                  active: leverage == stop,
                  onTap: () => onChanged(stop),
                ),
              ),
              if (stop != stops.last) const SizedBox(width: 9),
            ],
          ],
        ),
      ],
    );
  }
}

class _StopButton extends StatelessWidget {
  const _StopButton({
    required this.leverage,
    required this.active,
    required this.onTap,
  });

  final int leverage;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LeveragePage.stopKey(leverage),
      onTap: onTap,
      borderRadius: AppRadii.xlRadius,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _tradePrimary : _chipBackground,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: active ? _tradePrimary : AppColors.borderSolid,
          ),
        ),
        child: Text(
          '${leverage}x',
          style: AppTextStyles.caption.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontSize: 12,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _PresetGrid extends StatelessWidget {
  const _PresetGrid({
    required this.presets,
    required this.active,
    required this.onChanged,
  });

  final List<int> presets;
  final int active;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Chọn nhanh',
          style: AppTextStyles.caption.copyWith(
            fontSize: 12,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: presets.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 9,
            mainAxisSpacing: 10,
            childAspectRatio: 1.78,
          ),
          itemBuilder: (context, index) {
            final leverage = presets[index];
            return _PresetButton(
              leverage: leverage,
              active: leverage == active,
              onTap: () => onChanged(leverage),
            );
          },
        ),
      ],
    );
  }
}

class _PresetButton extends StatelessWidget {
  const _PresetButton({
    required this.leverage,
    required this.active,
    required this.onTap,
  });

  final int leverage;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LeveragePage.presetKey(leverage),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? null : _chipBackground,
          gradient: active
              ? const LinearGradient(
                  colors: [_tradePrimary, _tradePrimaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(
            color: active ? Colors.transparent : AppColors.borderSolid,
          ),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: _tradePrimary.withValues(alpha: .26),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          '${leverage}x',
          style: AppTextStyles.caption.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontSize: 14,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.margin, required this.preview});

  final double margin;
  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    final rows = [
      (
        'Giá trị hợp đồng',
        '\$${_formatWholeNumber(preview.positionSize)}',
        AppColors.text1,
      ),
      (
        'Thanh lý cách giá vào',
        '~${preview.liquidationDistancePct.toStringAsFixed(1)}%',
        AppColors.sell,
      ),
      (
        'Phí mở vị thế (0.02%)',
        '\$${preview.openFee.toStringAsFixed(4)}',
        AppColors.warn,
      ),
      (
        'Lợi nhuận nếu +1%',
        '+\$${preview.profitAtOnePct.toStringAsFixed(2)}',
        AppColors.buy,
      ),
      (
        'Lỗ nếu -1%',
        '-\$${preview.lossAtOnePct.toStringAsFixed(2)}',
        AppColors.sell,
      ),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 15, 16, 13),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline_rounded,
                color: _tradePrimary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Ước tính tác động',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Với ký quỹ \$${_formatWholeNumber(margin)} USDT',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 11),
          for (final row in rows)
            _ImpactRow(label: row.$1, value: row.$2, valueColor: row.$3),
        ],
      ),
    );
  }
}

class _ImpactRow extends StatelessWidget {
  const _ImpactRow({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.divider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
                height: 1.15,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor,
              fontSize: 12,
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningCard extends StatelessWidget {
  const _WarningCard({required this.preview});

  final TradeFuturesLeveragePreview preview;

  @override
  Widget build(BuildContext context) {
    final danger = preview.leverage > 20;
    final color = danger ? AppColors.sell : AppColors.warn;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: color, size: 16),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              preview.warningText,
              style: AppTextStyles.caption.copyWith(
                color: color,
                fontSize: 12,
                height: 1.6,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskTipsCard extends StatelessWidget {
  const _RiskTipsCard();

  static const _tips = [
    'Luôn đặt Stop Loss để giới hạn lỗ',
    'Không sử dụng quá 5% tổng vốn cho 1 lệnh',
    'Theo dõi vị thế thường xuyên',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.sell.withValues(alpha: .22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(
                Icons.shield_outlined,
                color: AppColors.sell,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Lưu ý quan trọng',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.sell,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          for (final tip in _tips) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 3),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.sell,
                    size: 13,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    tip,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
            if (tip != _tips.last) const SizedBox(height: 8),
          ],
        ],
      ),
    );
  }
}

class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.leverage, required this.onPressed});

  final int leverage;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: LeveragePage.confirmKey,
      onTap: onPressed,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_tradePrimary, _tradePrimaryDark],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: AppRadii.cardRadius,
          boxShadow: [
            BoxShadow(
              color: _tradePrimary.withValues(alpha: .25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(
          'Xác nhận đòn bẩy ${leverage}x',
          style: AppTextStyles.baseMedium.copyWith(
            color: Colors.white,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

String _formatWholeNumber(double value) {
  final text = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}
