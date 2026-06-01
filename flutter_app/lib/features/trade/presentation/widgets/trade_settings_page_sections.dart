part of '../pages/trade_settings_page.dart';

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
