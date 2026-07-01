part of '../pages/convert_page.dart';

class _ConvertHeader extends StatelessWidget {
  const _ConvertHeader({required this.onBack, required this.onSettings});

  final VoidCallback onBack;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    return VitTopChrome(
      type: VitTopChromeType.detail,
      title: 'Convert / Swap',
      showBack: true,
      backKey: ConvertPage.backKey,
      onBack: onBack,
      actions: [
        VitHeaderActionItem(
          type: VitHeaderActionType.settings,
          tooltip: 'Cài đặt giao dịch',
          onPressed: onSettings,
        ),
      ],
    );
  }
}

class _ModeTabs extends StatelessWidget {
  const _ModeTabs({required this.mode, required this.onChanged});

  final _ConvertMode mode;
  final ValueChanged<_ConvertMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.convertModeTabHeight,
      child: VitSegmentedTabBar(
        activeKey: mode.name,
        onChanged: (key) => onChanged(
          _ConvertMode.values.firstWhere((mode) => mode.name == key),
        ),
        tabs: [
          VitTabItem(
            key: _ConvertMode.market.name,
            label: 'Market',
            icon: Icons.bolt_rounded,
            widgetKey: ConvertPage.modeKey('market'),
          ),
          VitTabItem(
            key: _ConvertMode.limit.name,
            label: 'Limit',
            icon: Icons.gps_fixed_rounded,
            widgetKey: ConvertPage.modeKey('limit'),
          ),
          VitTabItem(
            key: _ConvertMode.schedule.name,
            label: 'Tự động',
            icon: Icons.calendar_today_rounded,
            widgetKey: ConvertPage.modeKey('schedule'),
          ),
        ],
      ),
    );
  }
}
