part of '../pages/copy_trading_v2_page.dart';

class _TraderList extends StatelessWidget {
  const _TraderList({required this.traders, required this.onOpen});

  final List<TradeCopyTrader> traders;
  final ValueChanged<TradeCopyTrader> onOpen;

  static final _keys = CopyTradingListKeys(
    traderKey: CopyTradingV2Page.traderKey,
    detailKey: CopyTradingV2Page.detailKey,
    sortKey: CopyTradingV2Page.sortKey,
  );

  @override
  Widget build(BuildContext context) {
    return CopyTradingTraderList(
      traders: traders,
      onOpen: onOpen,
      keys: _keys,
      skin: CopyTradingListSkin.v2,
    );
  }
}

class _RiskWarningCard extends StatelessWidget {
  const _RiskWarningCard({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return CopyTradingRiskWarningCard(
      title: title,
      message: message,
      v2PreviewCopy: true,
    );
  }
}

class _SortChips extends StatelessWidget {
  const _SortChips({
    required this.options,
    required this.selected,
    required this.onChanged,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;

  static final _keys = CopyTradingListKeys(
    traderKey: CopyTradingV2Page.traderKey,
    detailKey: CopyTradingV2Page.detailKey,
    sortKey: CopyTradingV2Page.sortKey,
  );

  @override
  Widget build(BuildContext context) {
    return CopyTradingSortChips(
      options: options,
      selected: selected,
      onChanged: onChanged,
      keys: _keys,
      skin: CopyTradingListSkin.v2,
    );
  }
}
