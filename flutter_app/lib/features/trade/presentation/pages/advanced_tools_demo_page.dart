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

const _toolsPrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;

enum _ToolsTab { ladder, bulk, shortcuts }

class AdvancedToolsDemoPage extends ConsumerStatefulWidget {
  const AdvancedToolsDemoPage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc062_advanced_tools_scroll_content');
  static const ladderButtonKey = Key('sc062_open_ladder');
  static const bulkButtonKey = Key('sc062_open_bulk');
  static const shortcutsButtonKey = Key('sc062_open_shortcuts');
  static const ladderSubmitKey = Key('sc062_submit_ladder');
  static const bulkCancelKey = Key('sc062_bulk_cancel');
  static const shortcutTriggerKey = Key('sc062_shortcut_trigger');

  static Key tabKey(String id) => Key('sc062_tab_$id');
  static Key featureKey(String id) => Key('sc062_feature_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<AdvancedToolsDemoPage> createState() =>
      _AdvancedToolsDemoPageState();
}

class _AdvancedToolsDemoPageState extends ConsumerState<AdvancedToolsDemoPage> {
  _ToolsTab _tab = _ToolsTab.ladder;
  String? _successMessage;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getAdvancedTools();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 104 : 24);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-062 AdvancedToolsDemoPage',
      child: Stack(
        children: [
          Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                VitHeader(
                  title: 'Advanced Trading Tools',
                  showBack: true,
                  onBack: () => context.go(AppRoutePaths.trade),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    key: AdvancedToolsDemoPage.contentKey,
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
                        const _SpeedCard(),
                        const SizedBox(height: 12),
                        const _BenefitsCard(),
                        const SizedBox(height: 12),
                        _ProgressCard(items: snapshot.statusItems),
                        const SizedBox(height: 18),
                        _ToolsTabs(
                          active: _tab,
                          onChanged: (tab) => setState(() => _tab = tab),
                        ),
                        const SizedBox(height: 14),
                        if (_tab == _ToolsTab.ladder)
                          _ActionTab(
                            description:
                                'Click any price level on the order book to place instant orders',
                            buttonKey: AdvancedToolsDemoPage.ladderButtonKey,
                            label: 'Open Ladder Trading',
                            icon: Icons.track_changes_rounded,
                            colors: const [
                              Color(0xFF10B981),
                              Color(0xFF059669),
                            ],
                            onOpen: _openLadderSheet,
                          )
                        else if (_tab == _ToolsTab.bulk)
                          _ActionTab(
                            description:
                                'Select multiple orders and perform batch actions',
                            buttonKey: AdvancedToolsDemoPage.bulkButtonKey,
                            label: 'Open Bulk Operations',
                            icon: Icons.check_box_rounded,
                            colors: const [
                              Color(0xFFF59E0B),
                              Color(0xFFD97706),
                            ],
                            onOpen: _openBulkSheet,
                          )
                        else
                          _ActionTab(
                            description:
                                'View all keyboard shortcuts and customize key bindings',
                            buttonKey: AdvancedToolsDemoPage.shortcutsButtonKey,
                            label: 'View Shortcuts Reference',
                            icon: Icons.keyboard_rounded,
                            colors: const [
                              Color(0xFF8B5CF6),
                              Color(0xFF7C3AED),
                            ],
                            onOpen: _openShortcutsSheet,
                          ),
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

  void _onFeatureTap(TradeAdvancedToolFeature feature) {
    if (feature.id == 'bulk') {
      setState(() => _tab = _ToolsTab.bulk);
      _openBulkSheet();
      return;
    }
    if (feature.id == 'shortcuts') {
      setState(() => _tab = _ToolsTab.shortcuts);
      _openShortcutsSheet();
      return;
    }
    setState(() => _tab = _ToolsTab.ladder);
    _openLadderSheet();
  }

  Future<void> _openLadderSheet() async {
    final placed = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _LadderSheet(
        orders: ref
            .read(tradeRepositoryProvider)
            .getAdvancedTools()
            .ladderOrders,
      ),
    );
    if (placed != true || !mounted) return;
    ref
        .read(tradeRepositoryProvider)
        .submitAdvancedToolAction(
          const TradeAdvancedToolActionRequest(
            toolId: 'ladder',
            action: 'place-order',
          ),
        );
    setState(() => _successMessage = 'Buy Order Placed · 0.5 BTC');
  }

  Future<void> _openBulkSheet() async {
    final orderIds = ref
        .read(tradeRepositoryProvider)
        .getAdvancedTools()
        .bulkOrders
        .map((order) => order.id)
        .toList(growable: false);
    final cancelled = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _BulkSheet(
        orders: ref.read(tradeRepositoryProvider).getAdvancedTools().bulkOrders,
      ),
    );
    if (cancelled != true || !mounted) return;
    final result = ref
        .read(tradeRepositoryProvider)
        .submitAdvancedToolAction(
          TradeAdvancedToolActionRequest(
            toolId: 'bulk',
            action: 'cancel',
            orderIds: orderIds,
          ),
        );
    setState(
      () => _successMessage = '${result.affectedCount} orders cancelled',
    );
  }

  Future<void> _openShortcutsSheet() async {
    final triggered = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ShortcutsSheet(
        shortcuts: ref
            .read(tradeRepositoryProvider)
            .getAdvancedTools()
            .shortcuts,
      ),
    );
    if (triggered != true || !mounted) return;
    ref
        .read(tradeRepositoryProvider)
        .submitAdvancedToolAction(
          const TradeAdvancedToolActionRequest(
            toolId: 'shortcuts',
            action: 'trigger',
          ),
        );
    setState(() => _successMessage = 'Shortcut triggered · Quick Buy');
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: _toolsPrimary.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _IconTile(icon: Icons.bolt_rounded, color: _toolsPrimary, size: 40),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Phase 3: Advanced Trading Tools',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '3 công cụ nâng cao cho pro traders: trade nhanh hơn với ladder, quản lý nhiều lệnh cùng lúc, và shortcuts để tăng tốc 3x.',
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

  final TradeAdvancedToolFeature feature;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = Color(feature.colorHex);
    return InkWell(
      key: AdvancedToolsDemoPage.featureKey(feature.id),
      onTap: onTap,
      borderRadius: AppRadii.cardRadius,
      child: _Panel(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _IconTile(icon: _iconFor(feature.id), color: color, size: 48),
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

  IconData _iconFor(String id) {
    return switch (id) {
      'bulk' => Icons.check_box_rounded,
      'shortcuts' => Icons.keyboard_rounded,
      _ => Icons.track_changes_rounded,
    };
  }
}

class _SpeedCard extends StatelessWidget {
  const _SpeedCard();

  @override
  Widget build(BuildContext context) {
    return _Panel(
      borderColor: AppColors.buy.withValues(alpha: .30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.trending_up_rounded, color: AppColors.buy, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trading Speed: 3x Faster',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.buy,
                    fontSize: 14,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pro traders sử dụng Phase 3 tools đặt lệnh trung bình 3-5 giây thay vì 10-15 giây. Master shortcuts để trade nhanh như market makers.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text3,
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

class _BenefitsCard extends StatelessWidget {
  const _BenefitsCard();

  static const _items = [
    (
      Icons.flash_on_rounded,
      'Ladder: 1-click orders',
      'Không cần nhập giá, click trực tiếp trên DOM',
    ),
    (
      Icons.inventory_2_rounded,
      'Bulk: Manage 100+ orders',
      'Select all -> Cancel/Modify hàng loạt',
    ),
    (
      Icons.keyboard_rounded,
      'Shortcuts: Muscle memory',
      'F1/F2 để buy/sell, ESC panic close',
    ),
    (
      Icons.track_changes_rounded,
      'Precision + Speed',
      'Vừa nhanh vừa chính xác, như pro traders',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Advanced Tools Benefits',
            style: AppTextStyles.caption.copyWith(
              fontSize: 14,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 12),
          for (final item in _items) ...[
            _BenefitItem(icon: item.$1, title: item.$2, description: item.$3),
            if (item != _items.last) const SizedBox(height: 12),
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
        Icon(icon, color: _toolsPrimary, size: 18),
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

class _ProgressCard extends StatelessWidget {
  const _ProgressCard({required this.items});

  final List<TradeRiskStatusItem> items;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Phase 3 Progress',
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

class _ToolsTabs extends StatelessWidget {
  const _ToolsTabs({required this.active, required this.onChanged});

  final _ToolsTab active;
  final ValueChanged<_ToolsTab> onChanged;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      (_ToolsTab.ladder, 'Ladder'),
      (_ToolsTab.bulk, 'Bulk Ops'),
      (_ToolsTab.shortcuts, 'Shortcuts'),
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
                key: AdvancedToolsDemoPage.tabKey(tabs[i].$1.name),
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

class _ActionTab extends StatelessWidget {
  const _ActionTab({
    required this.description,
    required this.buttonKey,
    required this.label,
    required this.icon,
    required this.colors,
    required this.onOpen,
  });

  final String description;
  final Key buttonKey;
  final String label;
  final IconData icon;
  final List<Color> colors;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          description,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text3,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 12),
        _GradientButton(
          key: buttonKey,
          label: label,
          icon: icon,
          colors: colors,
          onTap: onOpen,
        ),
      ],
    );
  }
}

class _LadderSheet extends StatelessWidget {
  const _LadderSheet({required this.orders});

  final List<TradeLadderOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Ladder Trading',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'BTC/USDT DOM · click price level to place instant order.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          for (final offset in const [150, 100, 50, 0, -50, -100]) ...[
            _LadderLevel(price: 69000 + offset),
            const SizedBox(height: 6),
          ],
          const SizedBox(height: 8),
          for (final order in orders) ...[
            _SheetRow(
              label: '${order.side.name.toUpperCase()} ${order.id}',
              value:
                  '${order.amount.toStringAsFixed(1)} BTC @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.ladderSubmitKey,
            label: 'Place Buy Order',
            icon: Icons.check_rounded,
            colors: const [Color(0xFF10B981), Color(0xFF059669)],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _BulkSheet extends StatelessWidget {
  const _BulkSheet({required this.orders});

  final List<TradeBulkOrder> orders;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Bulk Operations',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${orders.length} open orders selected for batch action.',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text3,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 12),
          for (final order in orders) ...[
            _SheetRow(
              label: '${order.symbol} ${order.side.name.toUpperCase()}',
              value:
                  '${order.remaining.toStringAsFixed(1)} @ \$${_formatMoney(order.price)}',
            ),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.bulkCancelKey,
            label: 'Cancel Selected Orders',
            icon: Icons.close_rounded,
            colors: const [Color(0xFFF59E0B), Color(0xFFD97706)],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _ShortcutsSheet extends StatelessWidget {
  const _ShortcutsSheet({required this.shortcuts});

  final List<TradeShortcut> shortcuts;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      title: 'Keyboard Shortcuts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final shortcut in shortcuts) ...[
            _SheetRow(label: shortcut.keys, value: shortcut.label),
          ],
          const SizedBox(height: 14),
          _GradientButton(
            key: AdvancedToolsDemoPage.shortcutTriggerKey,
            label: 'Trigger Quick Buy',
            icon: Icons.keyboard_rounded,
            colors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            onTap: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }
}

class _LadderLevel extends StatelessWidget {
  const _LadderLevel({required this.price});

  final int price;

  @override
  Widget build(BuildContext context) {
    final isAsk = price > 69000;
    final color = isAsk ? AppColors.sell : AppColors.buy;
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              isAsk ? 'SELL' : 'BUY',
              style: AppTextStyles.micro.copyWith(
                color: color,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ),
          Text(
            '\$${_formatMoney(price.toDouble())}',
            style: AppTextStyles.caption.copyWith(
              fontFamily: 'monospace',
              fontWeight: AppTextStyles.bold,
            ),
          ),
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
          color: active ? _toolsPrimary : Colors.transparent,
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

class _Panel extends StatelessWidget {
  const _Panel({
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.borderColor = AppColors.cardBorder,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: borderColor),
        borderRadius: AppRadii.cardRadius,
      ),
      child: child,
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.title, required this.child});

  final String title;
  final Widget child;

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _SheetHandle(),
              const SizedBox(height: 18),
              Text(
                title,
                style: AppTextStyles.sectionTitle.copyWith(fontSize: 20),
              ),
              const SizedBox(height: 12),
              child,
            ],
          ),
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
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                fontWeight: AppTextStyles.bold,
                fontFamily: 'monospace',
              ),
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
