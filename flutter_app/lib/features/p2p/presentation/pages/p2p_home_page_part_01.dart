part of 'p2p_home_page.dart';

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
    final snapshot = ref.watch(
      p2pHomeProvider((tradeType: _tradeType, asset: _asset, fiat: _fiat)),
    );
    final ads = _filteredAds(snapshot.ads);
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomInset =
        (mode.usesVisualQaFrame
            ? DeviceMetrics.bottomChrome + AppSpacing.x6
            : DeviceMetrics.nativeBottomChrome + AppSpacing.x4) +
        MediaQuery.paddingOf(context).bottom;
    final showOfflineWithCache =
        snapshot.currentState == P2PScreenState.offline &&
        snapshot.ads.isNotEmpty;
    final offlineDetail = snapshot.lastUpdatedLabel.isEmpty
        ? 'C\u1EADp nh\u1EADt l\u1EA7n cu\u1ED1i: d\u1EEF li\u1EC7u g\u1EA7n nh\u1EA5t'
        : 'C\u1EADp nh\u1EADt l\u1EA7n cu\u1ED1i: ${snapshot.lastUpdatedLabel}';

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-282 P2PHomePage',
      child: Material(
        type: MaterialType.transparency,
        child: VitAutoHideHeaderScaffold(
          header: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox.shrink() /*
                key: P2PHomePage.offlineKey,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.contentPad,
                  AppSpacing.x3,
                  AppSpacing.contentPad,
                  AppSpacing.x2,
                ),
                child: const SizedBox.shrink(
                  message: 'Mất kết nối. Đang hiển thị dữ liệu gần nhất.',
                  detail: 'Cập nhật lần cuối: 2 phút trước',
                ),
              ),
              */,
              VitTopChrome(
                type: VitTopChromeType.rootModule,
                title: snapshot.title,
                subtitle: snapshot.subtitle,
                showBack: true,
                onBack: () => context.go(AppRoutePaths.home),
                actions: [
                  VitHeaderActionItem(
                    key: P2PHomePage.createKey,
                    type: VitHeaderActionType.add,
                    tooltip: 'Đăng offer',
                    onPressed: () => context.go(snapshot.createRoute),
                  ),
                  VitHeaderActionItem(
                    key: P2PHomePage.myOrdersKey,
                    type: VitHeaderActionType.history,
                    tooltip: 'Đơn P2P của tôi',
                    onPressed: () => context.go(snapshot.myOrdersRoute),
                  ),
                ],
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
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
                        if (showOfflineWithCache) ...[
                          Padding(
                            key: P2PHomePage.offlineKey,
                            padding: const EdgeInsets.only(
                              bottom: AppSpacing.x4,
                            ),
                            child: VitOfflineBanner(
                              message:
                                  'M\u1EA5t k\u1EBFt n\u1ED1i. \u0110ang hi\u1EC3n th\u1ECB d\u1EEF li\u1EC7u g\u1EA7n nh\u1EA5t.',
                              detail: offlineDetail,
                            ),
                          ),
                        ],
                        _QuickHub(snapshot: snapshot),
                        const SizedBox(height: AppSpacing.x4),
                        if (snapshot.highRiskContractId != null) ...[
                          VitHighRiskStatePanel(
                            state: VitHighRiskUiState.riskReview,
                            title: 'Escrow trade states active',
                            message:
                                'KYC, payment readiness, preview, confirmation, order status, dispute and support states are bound to one P2P contract.',
                            contractId: snapshot.highRiskContractId,
                          ),
                          const SizedBox(height: AppSpacing.x4),
                        ],
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
        color: active ? color : AppColors.transparent,
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
                color: active ? AppColors.onAccent : AppColors.text3,
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
