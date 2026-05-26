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

const _riskPrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;

enum _RiskTab { oco, positions, calculator }

class RiskManagementDemoPage extends ConsumerStatefulWidget {
  const RiskManagementDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc060_risk_management_scroll_content');
  static const backKey = Key('sc060_back');
  static const ocoButtonKey = Key('sc060_open_oco');
  static const ocoSubmitKey = Key('sc060_submit_oco');
  static const calculatorButtonKey = Key('sc060_open_calculator');
  static const calculatorApplyKey = Key('sc060_apply_calculator');

  static Key tabKey(String id) => Key('sc060_tab_$id');
  static Key featureKey(String id) => Key('sc060_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<RiskManagementDemoPage> createState() =>
      _RiskManagementDemoPageState();
}

class _RiskManagementDemoPageState
    extends ConsumerState<RiskManagementDemoPage> {
  _RiskTab _tab = _RiskTab.oco;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getRiskManagement();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 97 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-060 RiskManagementDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Risk Management',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: RiskManagementDemoPage.contentKey,
                    padding: EdgeInsets.fromLTRB(20, 14, 20, bottomInset),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const _IntroCard(),
                        const SizedBox(height: 12),
                        for (final feature in snapshot.features) ...[
                          _FeatureCard(
                            feature: feature,
                            onTap: () => _onFeatureTap(feature),
                          ),
                          const SizedBox(height: 12),
                        ],
                        const _BenefitsCard(),
                        const SizedBox(height: 12),
                        _StatusCard(items: snapshot.statusItems),
                        const SizedBox(height: 18),
                        _RiskTabs(
                          active: _tab,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 14),
                        if (_tab == _RiskTab.oco)
                          _OcoTab(onOpen: _openOcoSheet)
                        else if (_tab == _RiskTab.positions)
                          _PositionsTab(positions: snapshot.positions)
                        else
                          _CalculatorTab(onOpen: _openCalculatorSheet),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_successMessage != null)
            Positioned(
              left: 20,
              right: 20,
              top: mode.usesVisualQaFrame ? 80 : 24,
              child: _SuccessToast(
                message: _successMessage!,
                onClose: () => setState(() => _successMessage = null),
              ),
            ),
        ],
      ),
    );
  }

  void _onFeatureTap(TradeRiskFeature feature) {
    if (feature.id == 'positions') {
      setState(() => _tab = _RiskTab.positions);
      return;
    }
    if (feature.id == 'calculator') {
      setState(() => _tab = _RiskTab.calculator);
      _openCalculatorSheet();
      return;
    }
    setState(() => _tab = _RiskTab.oco);
    _openOcoSheet();
  }

  Future<void> _openOcoSheet() async {
    final submitted = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _OcoSheet(),
    );
    if (submitted != true || !mounted) return;
    final result = ref
        .read(tradeRepositoryProvider)
        .submitOcoOrder(
          const TradeOcoOrderDraft(
            symbol: 'BTC/USDT',
            side: TradeOrderSide.buy,
            quantity: .015,
            limitPrice: 69000,
            takeProfitPrice: 72000,
            stopPrice: 66000,
          ),
        );
    setState(() => _successMessage = 'Đã đặt ${result.orderId}');
  }

  Future<void> _openCalculatorSheet() async {
    final applied = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CalculatorSheet(
        result: ref
            .read(tradeRepositoryProvider)
            .calculatePositionSize(
              const TradePositionSizeRequest(
                accountBalance: 50000,
                riskPct: 1,
                entryPrice: 69000,
                stopPrice: 67500,
              ),
            ),
      ),
    );
    if (applied != true || !mounted) return;
    setState(() => _successMessage = 'Đã áp dụng khối lượng đề xuất');
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: _riskPrimary.withValues(alpha: .30)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(icon: Icons.shield_rounded, color: _riskPrimary, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase 1: Risk Management Foundation',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3 công cụ quản lý rủi ro chuyên nghiệp giúp bảo vệ vốn và tối ưu hóa lợi nhuận. Đây là foundation quan trọng nhất cho enterprise trading platform.',
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

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature, required this.onTap});

  final TradeRiskFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return InkWell(
      key: RiskManagementDemoPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _cardBackground,
          border: Border.all(color: AppColors.cardBorder),
          borderRadius: AppRadii.cardRadius,
        ),
        child: Row(
          children: [
            _IconTile(icon: _iconForFeature(feature), color: color, size: 48),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feature.title,
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 14,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    feature.description,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text3,
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.text3,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconForFeature(TradeRiskFeature feature) {
    return switch (feature.id) {
      'positions' => Icons.check_circle_rounded,
      'calculator' => Icons.calculate_rounded,
      _ => Icons.trending_up_rounded,
    };
  }
}

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  static const _benefits = [
    (
      Icons.track_changes_rounded,
      'Quản lý rủi ro tốt hơn',
      'Không bị over-leverage, bảo vệ tài khoản',
    ),
    (
      Icons.bar_chart_rounded,
      'Theo dõi P&L real-time',
      'Biết đang lời hay lỗ mọi lúc',
    ),
    (
      Icons.balance_rounded,
      'R:R ratio tối ưu',
      'Đảm bảo tiềm năng lời > rủi ro',
    ),
    (
      Icons.security_rounded,
      'Stop loss tự động',
      'OCO orders bảo vệ vị thế 24/7',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Lợi ích chính',
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final benefit in _benefits) ...[
            _BenefitItem(
              icon: benefit.$1,
              title: benefit.$2,
              description: benefit.$3,
            ),
            if (benefit != _benefits.last) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _BenefitItem extends StatelessWidget {
  const _BenefitItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: _riskPrimary, size: 18),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text1,
                  fontSize: 12,
                  fontWeight: AppTextStyles.medium,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text3,
                  fontSize: 11,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.items});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Implementation Status',
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontSize: 12,
                    ),
                  ),
                ),
                _StatusPill(complete: item.complete),
              ],
            ),
            if (item != items.last) const SizedBox(height: 9),
          ],
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.complete});

  final bool complete;

  @override
  Widget build(BuildContext context) {
    final color = complete ? AppColors.buy : const Color(0xFFF59E0B);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        complete ? '✓ Complete' : '⏳ Pending',
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontSize: 10,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _RiskTabs extends StatelessWidget {
  const _RiskTabs({required this.active, required this.onChanged});

  final _RiskTab active;
  final ValueChanged<_RiskTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_RiskTab.oco, 'OCO Orders'),
      (_RiskTab.positions, 'Positions'),
      (_RiskTab.calculator, 'Calculator'),
    ];
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _chipBackground,
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++) ...[
            Expanded(
              child: _TabButton(
                key: RiskManagementDemoPage.tabKey(tabs[i].$1.name),
                label: tabs[i].$2,
                active: active == tabs[i].$1,
                onTap: () => onChanged(tabs[i].$1),
              ),
            ),
            if (i < tabs.length - 1) const SizedBox(width: 4),
          ],
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    super.key,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.smRadius,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? _riskPrimary : Colors.transparent,
          borderRadius: AppRadii.smRadius,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: active ? Colors.white : AppColors.text2,
            fontSize: 11,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ),
    );
  }
}

class _OcoTab extends StatelessWidget {
  const _OcoTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở form đặt lệnh OCO',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: RiskManagementDemoPage.ocoButtonKey,
          label: 'Mở OCO Order Form',
          icon: Icons.trending_up_rounded,
          colors: const [Color(0xFF10B981), Color(0xFF059669)],
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _CalculatorTab extends StatelessWidget {
  const _CalculatorTab({required this.onOpen});

  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Nhấn nút bên dưới để mở calculator',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: RiskManagementDemoPage.calculatorButtonKey,
          label: 'Mở Position Sizing Calculator',
          icon: Icons.calculate_rounded,
          colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _PositionsTab extends StatelessWidget {
  const _PositionsTab({required this.positions});

  final List<TradeRiskPosition> positions;

  @override
  Widget build(BuildContext context) {
    final total = positions.fold<double>(0, (sum, item) => sum + item.pnl);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cardBackground,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: AppRadii.cardRadius,
          ),
          child: Row(
            children: [
              Expanded(
                child: _MiniMetric(
                  label: 'Tổng P&L',
                  value: _formatSignedMoney(total),
                  color: total >= 0 ? AppColors.buy : AppColors.sell,
                ),
              ),
              Expanded(
                child: _MiniMetric(
                  label: 'Vị thế',
                  value: '${positions.length}',
                ),
              ),
              const Expanded(
                child: _MiniMetric(label: 'Risk mode', value: 'Active'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final position in positions) ...[
          _PositionTile(position: position),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.micro.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: 14,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _PositionTile extends StatelessWidget {
  const _PositionTile({required this.position});

  final TradeRiskPosition position;

  @override
  Widget build(BuildContext context) {
    final color = Color(position.logoColorHex);
    final pnlColor = position.pnl >= 0 ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Row(
        children: [
          _IconTile(
            icon: position.side == TradeRiskPositionSide.long
                ? Icons.north_east_rounded
                : Icons.south_east_rounded,
            color: color,
            size: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        position.symbol,
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 14,
                          fontWeight: AppTextStyles.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatSignedMoney(position.pnl),
                      style: AppTextStyles.caption.copyWith(
                        color: pnlColor,
                        fontFamily: 'monospace',
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  '${position.side.name.toUpperCase()} · ${position.amount.toStringAsFixed(position.amount >= 10 ? 0 : 2)} ${position.baseAsset} · Entry ${_formatMoney(position.entryPrice)}',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
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

class _GradientButton extends StatelessWidget {
  const _GradientButton({
    super.key,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadii.inputRadius,
      child: Container(
        constraints: const BoxConstraints(minHeight: 52),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: AppRadii.inputRadius,
          boxShadow: [
            BoxShadow(
              color: colors.first.withValues(alpha: .28),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 17),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({
    required this.icon,
    required this.color,
    required this.size,
  });

  final IconData icon;
  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: size * .5),
    );
  }
}

class _OcoSheet extends StatelessWidget {
  const _OcoSheet();

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            Text(
              'OCO Order Form',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            const _SheetRow(label: 'Cặp', value: 'BTC/USDT'),
            const _SheetRow(label: 'Side', value: 'Buy'),
            const _SheetRow(label: 'Limit', value: '\$69,000'),
            const _SheetRow(label: 'Take Profit', value: '\$72,000'),
            const _SheetRow(label: 'Stop Loss', value: '\$66,000'),
            const SizedBox(height: 16),
            _GradientButton(
              key: RiskManagementDemoPage.ocoSubmitKey,
              label: 'Đặt lệnh OCO',
              icon: Icons.check_rounded,
              colors: const [Color(0xFF10B981), Color(0xFF059669)],
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalculatorSheet extends StatelessWidget {
  const _CalculatorSheet({required this.result});

  final TradePositionSizeResult result;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SheetHandle(),
            const SizedBox(height: 18),
            Text(
              'Position Sizing Calculator',
              style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
            ),
            const SizedBox(height: 10),
            _SheetRow(
              label: 'Risk amount',
              value: '\$${_formatMoney(result.riskAmount)}',
            ),
            _SheetRow(
              label: 'Per-unit risk',
              value: '\$${_formatMoney(result.perUnitRisk)}',
            ),
            _SheetRow(
              label: 'Suggested amount',
              value: '${result.suggestedAmount.toStringAsFixed(6)} BTC',
            ),
            _SheetRow(
              label: 'Notional',
              value: '\$${_formatMoney(result.notional)}',
            ),
            const SizedBox(height: 16),
            _GradientButton(
              key: RiskManagementDemoPage.calculatorApplyKey,
              label: 'Áp dụng khối lượng',
              icon: Icons.check_rounded,
              colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
              onTap: () => Navigator.pop(context, true),
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 40,
        height: 4,
        decoration: BoxDecoration(
          color: AppColors.borderSolid,
          borderRadius: AppRadii.xsRadius,
        ),
      ),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text3,
                fontSize: 12,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessToast extends StatelessWidget {
  const _SuccessToast({required this.message, required this.onClose});

  final String message;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.buy10,
          borderRadius: AppRadii.cardRadius,
          border: Border.all(color: AppColors.buy.withValues(alpha: .38)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .22),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: AppColors.buy,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: AppTextStyles.caption.copyWith(
                  color: Colors.white,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ),
            InkWell(
              onTap: onClose,
              borderRadius: AppRadii.xsRadius,
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.text2,
                  size: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatSignedMoney(double value) {
  final sign = value >= 0 ? '+' : '-';
  return '$sign\$${_formatMoney(value.abs())}';
}

String _formatMoney(double value) {
  if (value >= 1000) {
    final fixed = value.toStringAsFixed(2);
    final parts = fixed.split('.');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.first.length; i++) {
      final remaining = parts.first.length - i;
      buffer.write(parts.first[i]);
      if (remaining > 1 && remaining % 3 == 1) buffer.write(',');
    }
    return '${buffer.toString()}.${parts.last}';
  }
  return value.toStringAsFixed(2);
}
