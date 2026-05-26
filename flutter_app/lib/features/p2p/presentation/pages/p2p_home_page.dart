import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vit_trade_flutter/app/router/app_router.dart';
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
import 'package:vit_trade_flutter/features/p2p/data/p2p_repository.dart';

class P2PHomePage extends ConsumerStatefulWidget {
  const P2PHomePage({super.key, this.shellRenderMode});

  static const contentKey = Key('sc282_p2p_home_content');
  static const offlineKey = Key('sc282_p2p_home_offline');
  static const quickHubKey = Key('sc282_p2p_home_quick_hub');
  static const tradeTabsKey = Key('sc282_p2p_home_trade_tabs');
  static const assetRailKey = Key('sc282_p2p_home_asset_rail');
  static const searchKey = Key('sc282_p2p_home_search');
  static const filterKey = Key('sc282_p2p_home_filter');
  static const myOrdersKey = Key('sc282_p2p_home_my_orders');
  static const createKey = Key('sc282_p2p_home_create');
  static const emptyKey = Key('sc282_p2p_home_empty');

  static Key tradeTabKey(P2PTradeType type) =>
      Key('sc282_p2p_home_tab_${type.name}');
  static Key assetKey(String asset) => Key('sc282_p2p_home_asset_$asset');
  static Key fiatKey(String fiat) => Key('sc282_p2p_home_fiat_$fiat');
  static Key actionKey(String id) => Key('sc282_p2p_home_action_$id');
  static Key adKey(String id) => Key('sc282_p2p_home_ad_$id');
  static Key adMenuKey(String id) => Key('sc282_p2p_home_ad_menu_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<P2PHomePage> createState() => _P2PHomePageState();
}

class _P2PHomePageState extends ConsumerState<P2PHomePage> {
  final TextEditingController _searchController = TextEditingController();
  P2PTradeType _tradeType = P2PTradeType.buy;
  String _asset = 'USDT';
  String _fiat = 'VND';
  String _query = '';
  bool _filtersOpen = false;
  String _merchantFilter = 'all';
  String _paymentFilter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(p2pRepositoryProvider)
        .getHome(tradeType: _tradeType, asset: _asset, fiat: _fiat);
    final ads = _filteredAds(snapshot.ads);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-282 P2PHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            Padding(
              key: P2PHomePage.offlineKey,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.contentPad,
                AppSpacing.x3,
                AppSpacing.contentPad,
                AppSpacing.x2,
              ),
              child: const VitOfflineBanner(
                message: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
                detail: 'Cập nhật lần cuối: 2 phút trước',
              ),
            ),
            VitHeader(
              title: snapshot.title,
              subtitle: snapshot.subtitle,
              showBack: true,
              onBack: () => context.go(AppRoutePaths.home),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  VitIconButton(
                    key: P2PHomePage.createKey,
                    icon: Icons.add_rounded,
                    tooltip: 'Đăng offer',
                    variant: VitIconButtonVariant.defaultAction,
                    onPressed: () => context.go(snapshot.createRoute),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                  VitIconButton(
                    key: P2PHomePage.myOrdersKey,
                    icon: Icons.history_rounded,
                    tooltip: 'Đơn P2P của tôi',
                    variant: VitIconButtonVariant.defaultAction,
                    onPressed: () => context.go(snapshot.myOrdersRoute),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: P2PHomePage.contentKey,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    AppSpacing.contentPad,
                    AppSpacing.x3,
                    AppSpacing.contentPad,
                    bottomInset,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _QuickHub(snapshot: snapshot),
                      const SizedBox(height: AppSpacing.x4),
                      _TradeTabs(
                        active: _tradeType,
                        onChanged: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _tradeType = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      _AssetFiatRail(
                        snapshot: snapshot,
                        selectedAsset: _asset,
                        selectedFiat: _fiat,
                        onAsset: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _asset = value);
                        },
                        onFiat: (value) {
                          HapticFeedback.selectionClick();
                          setState(() => _fiat = value);
                        },
                      ),
                      const SizedBox(height: AppSpacing.x4),
                      VitSearchBar(
                        key: P2PHomePage.searchKey,
                        controller: _searchController,
                        placeholder: snapshot.searchHint,
                        variant: VitSearchBarVariant.compact,
                        filterActive: _filtersOpen,
                        onFilterTap: () {
                          HapticFeedback.selectionClick();
                          setState(() => _filtersOpen = !_filtersOpen);
                        },
                        onChanged: (value) => setState(() => _query = value),
                      ),
                      if (_filtersOpen) ...[
                        const SizedBox(height: AppSpacing.x3),
                        _FilterPanel(
                          merchantFilter: _merchantFilter,
                          paymentFilter: _paymentFilter,
                          paymentMethods: _paymentMethods(snapshot.ads),
                          onMerchant: (value) =>
                              setState(() => _merchantFilter = value),
                          onPayment: (value) =>
                              setState(() => _paymentFilter = value),
                          onClear: () => setState(() {
                            _merchantFilter = 'all';
                            _paymentFilter = '';
                          }),
                        ),
                      ],
                      const SizedBox(height: AppSpacing.x4),
                      _ResultsHeader(count: ads.length),
                      const SizedBox(height: AppSpacing.x3),
                      if (ads.isEmpty)
                        _EmptyOffers(snapshot: snapshot)
                      else
                        for (final ad in ads) ...[
                          _OfferCard(
                            ad: ad,
                            tradeType: _tradeType,
                            onOpen: () =>
                                context.go(AppRoutePaths.p2pAd(ad.id)),
                            onMerchant: () => context.go(
                              AppRoutePaths.p2pMerchant(ad.merchantId),
                            ),
                            onReport: () => context.go(
                              AppRoutePaths.p2pReport(ad.merchantId),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.x3),
                        ],
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

  List<P2PAdDraft> _filteredAds(List<P2PAdDraft> ads) {
    final query = _query.trim().toLowerCase();
    return ads.where((ad) {
      if (query.isNotEmpty && !ad.merchant.toLowerCase().contains(query)) {
        return false;
      }
      if (_paymentFilter.isNotEmpty &&
          !ad.paymentMethods.contains(_paymentFilter)) {
        return false;
      }
      if (_merchantFilter == 'elite' && ad.merchantBadge != 'elite') {
        return false;
      }
      if (_merchantFilter == 'pro' && ad.merchantBadge != 'pro') {
        return false;
      }
      if (_merchantFilter == 'verified' && !ad.merchantVerified) {
        return false;
      }
      return true;
    }).toList();
  }

  List<String> _paymentMethods(List<P2PAdDraft> ads) {
    final methods = <String>{};
    for (final ad in ads) {
      methods.addAll(ad.paymentMethods);
    }
    return methods.toList();
  }
}

class _QuickHub extends StatelessWidget {
  const _QuickHub({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final stats = snapshot.platformStats;
    return VitCard(
      key: P2PHomePage.quickHubKey,
      radius: VitCardRadius.lg,
      borderColor: AppModuleAccents.p2p.withValues(alpha: .22),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          Row(
            children: [
              _AccentIcon(
                icon: Icons.auto_awesome_rounded,
                color: AppModuleAccents.p2p,
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Text(
                  'Thao tác nhanh',
                  style: AppTextStyles.baseMedium.copyWith(
                    fontSize: 14,
                    color: AppColors.text1,
                  ),
                ),
              ),
              const _LivePill(),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              for (
                var index = 0;
                index < snapshot.quickActions.length;
                index++
              ) ...[
                Expanded(
                  child: _QuickActionCard(action: snapshot.quickActions[index]),
                ),
                if (index != snapshot.quickActions.length - 1)
                  const SizedBox(width: AppSpacing.x3),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: _HubStat(
                  icon: Icons.show_chart_rounded,
                  label: 'Volume 24h',
                  value: _compactVnd(stats.volume24h),
                  caption: '+${stats.volume24hChange.toStringAsFixed(2)}%',
                  color: AppColors.buy,
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _HubStat(
                  icon: Icons.group_outlined,
                  label: 'Online',
                  value: _formatInt(stats.onlineTraders),
                  caption: 'traders',
                  color: AppColors.buy,
                ),
              ),
              const _VerticalDivider(),
              Expanded(
                child: _HubStat(
                  icon: Icons.trending_up_rounded,
                  label: 'Completion',
                  value: '${stats.avgCompletionRate.toStringAsFixed(1)}%',
                  caption: 'avg ${stats.avgCompletionTime}',
                  color: AppColors.warn,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              _SmallIconBox(
                icon: Icons.bar_chart_rounded,
                color: AppColors.accent,
              ),
              const SizedBox(width: AppSpacing.x2),
              Expanded(
                child: Text(
                  '${_formatInt(stats.totalTrades24h)} trades · '
                  '${stats.activeMerchants} merchants',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              _EscrowPill(
                label: '${_compactVnd(stats.escrowProtected)} Escrow',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.action});

  final P2PHomeQuickActionDraft action;

  @override
  Widget build(BuildContext context) {
    final color = action.toneKey == 'buy' ? AppColors.buy : AppColors.primary;
    final icon = action.iconKey == 'bolt'
        ? Icons.bolt_rounded
        : Icons.add_rounded;
    return VitCard(
      key: P2PHomePage.actionKey(action.id),
      variant: VitCardVariant.inner,
      radius: VitCardRadius.md,
      borderColor: color.withValues(alpha: .28),
      onTap: () => context.go(action.route),
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          _ActionIcon(icon: icon, color: color),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  action.subtitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: color, size: 14),
        ],
      ),
    );
  }
}

class _TradeTabs extends StatelessWidget {
  const _TradeTabs({required this.active, required this.onChanged});

  final P2PTradeType active;
  final ValueChanged<P2PTradeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PHomePage.tradeTabsKey,
      radius: VitCardRadius.lg,
      padding: const EdgeInsets.all(AppSpacing.x1),
      child: Row(
        children: [
          _TradeTab(
            type: P2PTradeType.buy,
            label: 'MUA',
            active: active == P2PTradeType.buy,
            onTap: () => onChanged(P2PTradeType.buy),
          ),
          _TradeTab(
            type: P2PTradeType.sell,
            label: 'BÁN',
            active: active == P2PTradeType.sell,
            onTap: () => onChanged(P2PTradeType.sell),
          ),
        ],
      ),
    );
  }
}

class _TradeTab extends StatelessWidget {
  const _TradeTab({
    required this.type,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final P2PTradeType type;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = type == P2PTradeType.buy ? AppColors.buy : AppColors.sell;
    return Expanded(
      child: Material(
        key: P2PHomePage.tradeTabKey(type),
        color: active ? color : Colors.transparent,
        borderRadius: AppRadii.cardRadius,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.cardRadius,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.x4),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: AppTextStyles.caption.copyWith(
                color: active ? Colors.white : AppColors.text3,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AssetFiatRail extends StatelessWidget {
  const _AssetFiatRail({
    required this.snapshot,
    required this.selectedAsset,
    required this.selectedFiat,
    required this.onAsset,
    required this.onFiat,
  });

  final P2PHomeSnapshot snapshot;
  final String selectedAsset;
  final String selectedFiat;
  final ValueChanged<String> onAsset;
  final ValueChanged<String> onFiat;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: P2PHomePage.assetRailKey,
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                for (final asset in snapshot.assets) ...[
                  _ChipButton(
                    key: P2PHomePage.assetKey(asset),
                    label: asset,
                    active: asset == selectedAsset,
                    onTap: () => onAsset(asset),
                  ),
                  const SizedBox(width: AppSpacing.x2),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.x2),
        for (final fiat in snapshot.fiatCurrencies) ...[
          _ChipButton(
            key: P2PHomePage.fiatKey(fiat),
            label: fiat,
            active: fiat == selectedFiat,
            onTap: () => onFiat(fiat),
          ),
          const SizedBox(width: AppSpacing.x1),
        ],
      ],
    );
  }
}

class _FilterPanel extends StatelessWidget {
  const _FilterPanel({
    required this.merchantFilter,
    required this.paymentFilter,
    required this.paymentMethods,
    required this.onMerchant,
    required this.onPayment,
    required this.onClear,
  });

  final String merchantFilter;
  final String paymentFilter;
  final List<String> paymentMethods;
  final ValueChanged<String> onMerchant;
  final ValueChanged<String> onPayment;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: P2PHomePage.filterKey,
      radius: VitCardRadius.md,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Loại merchant',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _ChipButton(
                label: 'Tất cả',
                active: merchantFilter == 'all',
                onTap: () => onMerchant('all'),
              ),
              _ChipButton(
                label: 'Elite',
                active: merchantFilter == 'elite',
                onTap: () => onMerchant('elite'),
              ),
              _ChipButton(
                label: 'Pro',
                active: merchantFilter == 'pro',
                onTap: () => onMerchant('pro'),
              ),
              _ChipButton(
                label: 'Xác minh',
                active: merchantFilter == 'verified',
                onTap: () => onMerchant('verified'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            'Thanh toán',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text2,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              _ChipButton(
                label: 'Tất cả',
                active: paymentFilter.isEmpty,
                onTap: () => onPayment(''),
              ),
              for (final method in paymentMethods)
                _ChipButton(
                  label: method,
                  active: paymentFilter == method,
                  onTap: () => onPayment(method),
                ),
            ],
          ),
          if (merchantFilter != 'all' || paymentFilter.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.x3),
            TextButton.icon(
              onPressed: onClear,
              icon: const Icon(Icons.close_rounded, size: 14),
              label: const Text('Xóa bộ lọc'),
            ),
          ],
        ],
      ),
    );
  }
}

class _ResultsHeader extends StatelessWidget {
  const _ResultsHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$count offer',
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
        ),
        const _EscrowPill(label: 'Escrow'),
      ],
    );
  }
}

class _OfferCard extends StatelessWidget {
  const _OfferCard({
    required this.ad,
    required this.tradeType,
    required this.onOpen,
    required this.onMerchant,
    required this.onReport,
  });

  final P2PAdDraft ad;
  final P2PTradeType tradeType;
  final VoidCallback onOpen;
  final VoidCallback onMerchant;
  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final actionColor = tradeType == P2PTradeType.buy
        ? AppColors.buy
        : AppColors.sell;
    final badge = ad.merchantBadge;
    return VitCard(
      key: P2PHomePage.adKey(ad.id),
      radius: VitCardRadius.lg,
      onTap: onOpen,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _MerchantAvatar(ad: ad),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            ad.merchant,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text1,
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        if (ad.merchantVerified) ...[
                          const SizedBox(width: AppSpacing.x1),
                          const Icon(
                            Icons.verified_rounded,
                            color: AppModuleAccents.p2p,
                            size: 13,
                          ),
                        ],
                        if (badge != null) ...[
                          const SizedBox(width: AppSpacing.x2),
                          _Badge(label: badge == 'elite' ? 'Elite' : 'Pro'),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      '${ad.completedOrders} đơn · '
                      '${ad.completionRate.toStringAsFixed(1)}% · '
                      '${ad.merchantRating?.toStringAsFixed(1) ?? '-'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                        fontWeight: AppTextStyles.medium,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                key: P2PHomePage.adMenuKey(ad.id),
                tooltip: 'Tùy chọn offer',
                color: AppColors.surface2,
                icon: const Icon(
                  Icons.more_horiz_rounded,
                  color: AppColors.text2,
                ),
                onSelected: (value) {
                  if (value == 'merchant') onMerchant();
                  if (value == 'report') onReport();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'merchant', child: Text('Xem merchant')),
                  PopupMenuItem(value: 'report', child: Text('Báo cáo offer')),
                ],
              ),
              const SizedBox(width: AppSpacing.x2),
              _ActionButton(
                label: tradeType == P2PTradeType.buy ? 'Mua' : 'Bán',
                color: actionColor,
                onTap: onOpen,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _formatVnd(ad.price),
                style: AppTextStyles.sectionTitle.copyWith(
                  color: AppColors.text1,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                child: Text(
                  ad.currency,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.x1),
                child: Text(
                  _priceDelta(ad),
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.buy,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              if (ad.priceType == 'floating') ...[
                const SizedBox(width: AppSpacing.x2),
                const _Badge(label: 'Thả nổi', color: AppColors.accent),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giới hạn ${_formatVnd(ad.minLimit)} - ${_formatVnd(ad.maxLimit)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ),
              Text(
                '${_formatAmount(ad.available)} ${ad.asset}',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.text2,
                  fontWeight: AppTextStyles.bold,
                  fontFeatures: AppTextStyles.tabularFigures,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  spacing: AppSpacing.x2,
                  runSpacing: AppSpacing.x2,
                  children: [
                    for (final method in ad.paymentMethods.take(3))
                      _PaymentPill(label: method),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.x2),
              Icon(Icons.schedule_rounded, color: AppColors.text3, size: 12),
              const SizedBox(width: AppSpacing.x1),
              Text(
                ad.avgResponseTime,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ],
          ),
          if (ad.isNewMerchant) ...[
            const SizedBox(height: AppSpacing.x3),
            const VitBanner(
              variant: VitBannerVariant.warning,
              icon: Icons.warning_amber_rounded,
              message: 'Merchant mới - kiểm tra kỹ trước khi giao dịch',
            ),
          ],
        ],
      ),
    );
  }

  String _priceDelta(P2PAdDraft ad) {
    final margin = ((ad.price - 25300) / 25300) * 100;
    return '${margin >= 0 ? '+' : ''}${margin.toStringAsFixed(2)}%';
  }
}

class _EmptyOffers extends StatelessWidget {
  const _EmptyOffers({required this.snapshot});

  final P2PHomeSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      key: P2PHomePage.emptyKey,
      icon: Icons.search_off_rounded,
      title: snapshot.emptyTitle,
      message: snapshot.emptySubtitle,
    );
  }
}

class _ChipButton extends StatelessWidget {
  const _ChipButton({
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
    return Material(
      color: active ? AppColors.primary12 : Colors.transparent,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: active ? AppColors.primary30 : Colors.transparent,
            ),
            borderRadius: AppRadii.inputRadius,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.primary : AppColors.text3,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadii.inputRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.inputRadius,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x3,
          ),
          child: Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class _MerchantAvatar extends StatelessWidget {
  const _MerchantAvatar({required this.ad});

  final P2PAdDraft ad;

  @override
  Widget build(BuildContext context) {
    final color = ad.merchantBadge == 'elite'
        ? AppColors.warn
        : ad.merchantBadge == 'pro'
        ? AppColors.accent
        : AppModuleAccents.p2p;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: AppSpacing.buttonCompact,
          height: AppSpacing.buttonCompact,
          decoration: BoxDecoration(
            color: color.withValues(alpha: .95),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            ad.merchant.characters.first,
            style: AppTextStyles.baseMedium.copyWith(
              color: Colors.white,
              height: 1,
            ),
          ),
        ),
        Positioned(
          right: -1,
          bottom: -1,
          child: Container(
            width: AppSpacing.x3,
            height: AppSpacing.x3,
            decoration: BoxDecoration(
              color: ad.isOnline ? AppColors.buy : AppColors.text3,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.surface, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

class _HubStat extends StatelessWidget {
  const _HubStat({
    required this.icon,
    required this.label,
    required this.value,
    required this.caption,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final String caption;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 11),
            const SizedBox(width: AppSpacing.x1),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.micro.copyWith(color: AppColors.text3),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x1),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontWeight: AppTextStyles.bold,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
        Text(
          caption,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: color,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _AccentIcon extends StatelessWidget {
  const _AccentIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.iconLg,
      height: AppSpacing.iconLg,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 17),
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.buttonCompact,
      height: AppSpacing.buttonCompact,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .18),
        borderRadius: AppRadii.mdRadius,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }
}

class _SmallIconBox extends StatelessWidget {
  const _SmallIconBox({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.x5,
      height: AppSpacing.x5,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .14),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Icon(icon, color: color, size: 12),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: AppSpacing.x7,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x2),
    );
  }
}

class _LivePill extends StatelessWidget {
  const _LivePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Text(
        'Live',
        style: AppTextStyles.micro.copyWith(
          color: AppColors.buy,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _EscrowPill extends StatelessWidget {
  const _EscrowPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x3,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: AppColors.buy10,
        border: Border.all(color: AppColors.buy20),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.buy, size: 11),
          const SizedBox(width: AppSpacing.x1),
          Text(
            label,
            style: AppTextStyles.micro.copyWith(
              color: AppColors.buy,
              fontWeight: AppTextStyles.bold,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.label, this.color = AppColors.warn});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.x2,
        vertical: AppSpacing.x1,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .16),
        borderRadius: AppRadii.xsRadius,
      ),
      child: Text(
        label,
        style: AppTextStyles.micro.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _PaymentPill extends StatelessWidget {
  const _PaymentPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        borderRadius: AppRadii.xsRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.x2,
          vertical: AppSpacing.x1,
        ),
        child: Text(
          label,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
            height: 1,
          ),
        ),
      ),
    );
  }
}

String _formatVnd(num value) {
  final whole = value.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write('.');
    buffer.write(whole[i]);
  }
  return buffer.toString();
}

String _formatInt(int value) => _formatVnd(value);

String _compactVnd(int value) {
  if (value >= 1000000000) {
    return '₫${(value / 1000000000).toStringAsFixed(2)}B';
  }
  if (value >= 1000000) return '₫${(value / 1000000).toStringAsFixed(2)}M';
  return '₫${_formatVnd(value)}';
}

String _formatAmount(double value) {
  if (value == value.roundToDouble()) {
    return _formatVnd(value.round());
  }
  return value.toStringAsFixed(4);
}
