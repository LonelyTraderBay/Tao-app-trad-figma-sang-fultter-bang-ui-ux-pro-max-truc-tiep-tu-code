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

const _tradePrimary = AppColors.primary;
const _cardBackground = AppColors.surface2;
const _chipBackground = AppColors.surface2;

class TradeSettingsPage extends ConsumerStatefulWidget {
  const TradeSettingsPage({super.key, this.shellRenderMode});

  static const resetKey = Key('sc052_reset');
  static const confirmOrdersKey = Key('sc052_confirm_orders');
  static const skipConfirmSmallKey = Key('sc052_skip_confirm_small');
  static const soundOnFillKey = Key('sc052_sound_on_fill');
  static const hapticOnFillKey = Key('sc052_haptic_on_fill');
  static const showTpslKey = Key('sc052_show_tpsl');
  static const showOrderBookKey = Key('sc052_show_order_book');
  static const showRecentTradesKey = Key('sc052_show_recent_trades');
  static const defaultPctButtonsKey = Key('sc052_default_pct_buttons');

  static Key orderTypeKey(String id) => Key('sc052_order_type_$id');
  static Key slippageKey(double value) => Key('sc052_slippage_$value');
  static Key timeframeKey(String value) => Key('sc052_timeframe_$value');
  static Key decimalsKey(String value) => Key('sc052_decimals_$value');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeSettingsPage> createState() => _TradeSettingsPageState();
}

class _TradeSettingsPageState extends ConsumerState<TradeSettingsPage> {
  late TradeSettings _settings;

  @override
  void initState() {
    super.initState();
    _settings = ref
        .read(tradeReadModelControllerProvider)
        .getTradeSettings()
        .settings;
  }

  @override
  Widget build(BuildContext context) {
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-052 TradeSettingsPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Cài đặt giao dịch',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20, 14, 20, bottomChrome + 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _SettingsSection(
                      title: 'Mặc định lệnh',
                      child: _OrderDefaultsCard(
                        settings: _settings,
                        onChanged: _updateSettings,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SettingsSection(
                      title: 'Xác nhận lệnh',
                      child: _ConfirmationCard(
                        settings: _settings,
                        onChanged: _updateSettings,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SettingsSection(
                      title: 'Phản hồi',
                      child: _FeedbackCard(
                        settings: _settings,
                        onChanged: _updateSettings,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _SettingsSection(
                      title: 'Hiển thị',
                      child: _DisplayCard(
                        settings: _settings,
                        onChanged: _updateSettings,
                      ),
                    ),
                    const SizedBox(height: 26),
                    _ResetButton(onReset: _resetSettings),
                    const SizedBox(height: 24),
                    const _InfoNote(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateSettings(TradeSettings settings) {
    final updated = ref
        .read(tradeReadModelControllerProvider)
        .patchTradeSettings(settings);
    setState(() => _settings = updated);
  }

  void _resetSettings() {
    _updateSettings(
      ref.read(tradeReadModelControllerProvider).getTradeSettings().settings,
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 14,
              decoration: BoxDecoration(
                color: _tradePrimary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.textMutedLight,
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children, this.gap = 18});

  final List<Widget> children;
  final double gap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      decoration: BoxDecoration(
        color: _cardBackground,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) SizedBox(height: gap),
            children[i],
          ],
        ],
      ),
    );
  }
}

class _OrderDefaultsCard extends StatelessWidget {
  const _OrderDefaultsCard({required this.settings, required this.onChanged});

  final TradeSettings settings;
  final ValueChanged<TradeSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      gap: 18,
      children: [
        _ChoiceBlock(
          label: 'Loại lệnh mặc định',
          options: const [
            _ChoiceOption(id: 'market', label: 'Thị trường'),
            _ChoiceOption(id: 'limit', label: 'Giới hạn'),
            _ChoiceOption(id: 'stop', label: 'Dừng lỗ'),
          ],
          activeId: settings.defaultOrderType,
          keyBuilder: TradeSettingsPage.orderTypeKey,
          onChanged: (id) => onChanged(settings.copyWith(defaultOrderType: id)),
        ),
        _ChoiceBlock(
          label: 'Trượt giá tối đa (Market orders)',
          trailing: '${settings.defaultSlippage.toStringAsFixed(1)}%',
          options: const [
            _ChoiceOption(id: '0.1', label: '0.1%'),
            _ChoiceOption(id: '0.3', label: '0.3%'),
            _ChoiceOption(id: '0.5', label: '0.5%'),
            _ChoiceOption(id: '1.0', label: '1%'),
            _ChoiceOption(id: '2.0', label: '2%'),
          ],
          activeId: settings.defaultSlippage.toStringAsFixed(1),
          height: 30,
          keyBuilder: (id) => TradeSettingsPage.slippageKey(double.parse(id)),
          onChanged: (id) =>
              onChanged(settings.copyWith(defaultSlippage: double.parse(id))),
        ),
        _SettingRow(
          label: 'Mặc định mở TP/SL',
          description: 'Tự động mở form TP/SL khi đặt lệnh',
          trailing: _VitToggle(
            key: TradeSettingsPage.showTpslKey,
            on: settings.showTpsl,
            onToggle: () =>
                onChanged(settings.copyWith(showTpsl: !settings.showTpsl)),
          ),
        ),
        if (settings.showTpsl)
          _SettingRow(
            label: 'Bracket Order mặc định',
            description:
                'Bắt buộc cả TP và SL. Khi một lệnh khớp, lệnh còn lại tự hủy.',
            trailing: _VitToggle(
              on: settings.bracketMode,
              onToggle: () => onChanged(
                settings.copyWith(bracketMode: !settings.bracketMode),
              ),
            ),
          ),
      ],
    );
  }
}

class _ConfirmationCard extends StatelessWidget {
  const _ConfirmationCard({required this.settings, required this.onChanged});

  final TradeSettings settings;
  final ValueChanged<TradeSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingRow(
          label: 'Xác nhận trước khi đặt lệnh',
          description: 'Hiển thị bottom sheet xác nhận',
          trailing: _VitToggle(
            key: TradeSettingsPage.confirmOrdersKey,
            on: settings.confirmOrders,
            onToggle: () => onChanged(
              settings.copyWith(confirmOrders: !settings.confirmOrders),
            ),
          ),
        ),
        if (settings.confirmOrders)
          _SettingRow(
            label: 'Bỏ qua xác nhận cho lệnh nhỏ',
            description:
                'Lệnh < \$${settings.smallOrderThreshold.toStringAsFixed(0)} không cần xác nhận',
            trailing: _VitToggle(
              key: TradeSettingsPage.skipConfirmSmallKey,
              on: settings.skipConfirmSmall,
              onToggle: () => onChanged(
                settings.copyWith(skipConfirmSmall: !settings.skipConfirmSmall),
              ),
            ),
          ),
      ],
    );
  }
}

class _FeedbackCard extends StatelessWidget {
  const _FeedbackCard({required this.settings, required this.onChanged});

  final TradeSettings settings;
  final ValueChanged<TradeSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      children: [
        _SettingRow(
          label: 'Âm thanh khi khớp lệnh',
          trailing: _VitToggle(
            key: TradeSettingsPage.soundOnFillKey,
            on: settings.soundOnFill,
            onToggle: () => onChanged(
              settings.copyWith(soundOnFill: !settings.soundOnFill),
            ),
          ),
        ),
        _SettingRow(
          label: 'Rung khi khớp lệnh',
          trailing: _VitToggle(
            key: TradeSettingsPage.hapticOnFillKey,
            on: settings.hapticOnFill,
            onToggle: () => onChanged(
              settings.copyWith(hapticOnFill: !settings.hapticOnFill),
            ),
          ),
        ),
      ],
    );
  }
}

class _DisplayCard extends StatelessWidget {
  const _DisplayCard({required this.settings, required this.onChanged});

  final TradeSettings settings;
  final ValueChanged<TradeSettings> onChanged;

  @override
  Widget build(BuildContext context) {
    return _SettingsCard(
      gap: 18,
      children: [
        _SettingRow(
          label: 'Hiển thị Order Book',
          description: 'Trong màn hình giao dịch',
          trailing: _VitToggle(
            key: TradeSettingsPage.showOrderBookKey,
            on: settings.showOrderBook,
            onToggle: () => onChanged(
              settings.copyWith(showOrderBook: !settings.showOrderBook),
            ),
          ),
        ),
        _SettingRow(
          label: 'Hiển thị Giao dịch gần đây',
          description: 'Time & Sales feed',
          trailing: _VitToggle(
            key: TradeSettingsPage.showRecentTradesKey,
            on: settings.showRecentTrades,
            onToggle: () => onChanged(
              settings.copyWith(showRecentTrades: !settings.showRecentTrades),
            ),
          ),
        ),
        _SettingRow(
          label: 'Nút phần trăm nhanh',
          description: '25% / 50% / 75% / 100%',
          trailing: _VitToggle(
            key: TradeSettingsPage.defaultPctButtonsKey,
            on: settings.defaultPctButtons,
            onToggle: () => onChanged(
              settings.copyWith(defaultPctButtons: !settings.defaultPctButtons),
            ),
          ),
        ),
        _ChoiceBlock(
          label: 'Khung thời gian chart mặc định',
          options: const [
            _ChoiceOption(id: '1m', label: '1m'),
            _ChoiceOption(id: '5m', label: '5m'),
            _ChoiceOption(id: '15m', label: '15m'),
            _ChoiceOption(id: '1h', label: '1h'),
            _ChoiceOption(id: '4h', label: '4h'),
            _ChoiceOption(id: '1D', label: '1D'),
          ],
          activeId: settings.chartTimeframe,
          height: 30,
          keyBuilder: TradeSettingsPage.timeframeKey,
          onChanged: (id) => onChanged(settings.copyWith(chartTimeframe: id)),
        ),
        _ChoiceBlock(
          label: 'Chữ số thập phân giá',
          options: const [
            _ChoiceOption(id: 'auto', label: 'Tự động'),
            _ChoiceOption(id: '2', label: '2'),
            _ChoiceOption(id: '4', label: '4'),
            _ChoiceOption(id: '6', label: '6'),
          ],
          activeId: settings.priceDecimals,
          height: 30,
          keyBuilder: TradeSettingsPage.decimalsKey,
          onChanged: (id) => onChanged(settings.copyWith(priceDecimals: id)),
        ),
      ],
    );
  }
}

class _ChoiceOption {
  const _ChoiceOption({required this.id, required this.label});

  final String id;
  final String label;
}

class _ChoiceBlock extends StatelessWidget {
  const _ChoiceBlock({
    required this.label,
    required this.options,
    required this.activeId,
    required this.onChanged,
    required this.keyBuilder,
    this.trailing,
    this.height = 36,
  });

  final String label;
  final String? trailing;
  final List<_ChoiceOption> options;
  final String activeId;
  final ValueChanged<String> onChanged;
  final Key Function(String id) keyBuilder;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textMutedLight,
                  fontSize: 12,
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                ),
              ),
            ),
            if (trailing != null)
              Text(
                trailing!,
                style: AppTextStyles.caption.copyWith(
                  color: _tradePrimary,
                  fontFamily: 'monospace',
                  fontWeight: AppTextStyles.bold,
                  height: 1.2,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            for (var i = 0; i < options.length; i++) ...[
              Expanded(
                child: _ChoiceChipButton(
                  key: keyBuilder(options[i].id),
                  label: options[i].label,
                  active: activeId == options[i].id,
                  height: height,
                  onTap: () => onChanged(options[i].id),
                ),
              ),
              if (i < options.length - 1) const SizedBox(width: 8),
            ],
          ],
        ),
      ],
    );
  }
}

class _ChoiceChipButton extends StatelessWidget {
  const _ChoiceChipButton({
    super.key,
    required this.label,
    required this.active,
    required this.height,
    required this.onTap,
  });

  final String label;
  final bool active;
  final double height;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(height / 2),
      child: Container(
        height: height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active
              ? _tradePrimary.withValues(alpha: .14)
              : _chipBackground,
          border: Border.all(
            color: active ? _tradePrimary : AppColors.surface3,
          ),
          borderRadius: BorderRadius.circular(height / 2),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: active ? _tradePrimary : AppColors.textMutedLight,
            fontSize: height < 32 ? 11 : 12,
            fontWeight: active ? AppTextStyles.bold : AppTextStyles.medium,
            height: 1,
          ),
        ),
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  const _SettingRow({
    required this.label,
    this.description,
    required this.trailing,
  });

  final String label;
  final String? description;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontSize: 13,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
              if (description != null) ...[
                const SizedBox(height: 4),
                Text(
                  description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontSize: 11,
                    height: 1.25,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 12),
        trailing,
      ],
    );
  }
}

class _VitToggle extends StatelessWidget {
  const _VitToggle({super.key, required this.on, required this.onToggle});

  final bool on;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: on,
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          width: 44,
          height: 24,
          decoration: BoxDecoration(
            color: on ? AppColors.buy : AppColors.surface3,
            borderRadius: AppRadii.mdRadius,
          ),
          child: AnimatedAlign(
            duration: const Duration(milliseconds: 120),
            alignment: on ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                color: AppColors.onAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.overlayScrim,
                    blurRadius: 4,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ResetButton extends StatelessWidget {
  const _ResetButton({required this.onReset});

  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: OutlinedButton(
        key: TradeSettingsPage.resetKey,
        onPressed: onReset,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.sell,
          side: BorderSide(color: AppColors.sell.withValues(alpha: .28)),
          backgroundColor: AppColors.sell.withValues(alpha: .08),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.mdRadius),
          textStyle: AppTextStyles.caption.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        child: const Text('Đặt lại mặc định'),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  const _InfoNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: _tradePrimary.withValues(alpha: .06),
        border: Border.all(color: _tradePrimary.withValues(alpha: .12)),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2),
            child: Icon(
              Icons.info_outline_rounded,
              color: _tradePrimary,
              size: 14,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cài đặt được lưu cục bộ trên thiết bị và áp dụng ngay khi thay đổi. '
              'Đăng nhập trên thiết bị khác sẽ dùng cài đặt mặc định.',
              style: AppTextStyles.micro.copyWith(
                color: _tradePrimary,
                fontSize: 11,
                height: 1.45,
                fontWeight: AppTextStyles.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
