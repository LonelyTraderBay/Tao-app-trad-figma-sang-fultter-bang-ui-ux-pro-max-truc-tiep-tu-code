import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_radii.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/theme/device_metrics.dart';
import '../../../shared/layout/shell_render_mode.dart';
import '../../../shared/layout/vit_header.dart';
import '../../../shared/layout/vit_page_content.dart';
import '../../../shared/layout/vit_page_layout.dart';
import '../../../shared/widgets/widgets.dart';
import '../data/market_repository.dart';

const _marketBlue = Color(0xFF3B82F6);

enum _TokenInfoTab { overview, onchain, project }

class TokenInfoPage extends ConsumerStatefulWidget {
  const TokenInfoPage({super.key, required this.pairId, this.shellRenderMode});

  static const contentKey = Key('sc045_token_info_content');
  static const overviewTabKey = Key('sc045_tab_overview');
  static const onchainTabKey = Key('sc045_tab_onchain');
  static const projectTabKey = Key('sc045_tab_project');
  static const chartButtonKey = Key('sc045_chart_button');

  final String pairId;
  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TokenInfoPage> createState() => _TokenInfoPageState();
}

class _TokenInfoPageState extends ConsumerState<TokenInfoPage> {
  _TokenInfoTab _tab = _TokenInfoTab.overview;

  @override
  Widget build(BuildContext context) {
    final snapshot = ref
        .watch(marketRepositoryProvider)
        .getTokenInfo(widget.pairId);
    final pair = snapshot.pair;
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;
    final bottomInset =
        bottomChrome +
        MediaQuery.paddingOf(context).bottom +
        (mode.usesVisualQaFrame ? 54 : 20);

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-045 TokenInfoPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: '${pair.baseAsset} - Thong tin',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.pairDetail(pair.id)),
            ),
            _TokenTabs(
              active: _tab,
              onChanged: (tab) => setState(() => _tab = tab),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: SingleChildScrollView(
                  key: TokenInfoPage.contentKey,
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: VitPageContent(
                    padding: VitContentPadding.relaxed,
                    customGap: 14,
                    children: [
                      if (_tab == _TokenInfoTab.overview)
                        _OverviewTab(snapshot: snapshot)
                      else if (_tab == _TokenInfoTab.onchain)
                        _OnchainTab(snapshot: snapshot)
                      else
                        _ProjectTab(snapshot: snapshot),
                      const _Disclaimer(),
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
}

class _TokenTabs extends StatelessWidget {
  const _TokenTabs({required this.active, required this.onChanged});

  final _TokenInfoTab active;
  final ValueChanged<_TokenInfoTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          _TabButton(
            key: TokenInfoPage.overviewTabKey,
            label: 'Tong quan',
            active: active == _TokenInfoTab.overview,
            onTap: () => onChanged(_TokenInfoTab.overview),
          ),
          _TabButton(
            key: TokenInfoPage.onchainTabKey,
            label: 'On-chain',
            active: active == _TokenInfoTab.onchain,
            onTap: () => onChanged(_TokenInfoTab.onchain),
          ),
          _TabButton(
            key: TokenInfoPage.projectTabKey,
            label: 'Du an',
            active: active == _TokenInfoTab.project,
            onTap: () => onChanged(_TokenInfoTab.project),
          ),
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
    return Expanded(
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: active ? _marketBlue : AppColors.text3,
                    fontWeight: active
                        ? AppTextStyles.bold
                        : AppTextStyles.medium,
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                height: 2,
                width: active ? 116 : 0,
                decoration: BoxDecoration(
                  color: _marketBlue,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    final supplyPct = fundamentals.maxSupply == null
        ? null
        : (fundamentals.circulatingSupply / fundamentals.maxSupply!) * 100;
    final athDropPct =
        ((pair.price - fundamentals.allTimeHigh) / fundamentals.allTimeHigh) *
        100;
    final atlGainPct =
        ((pair.price - fundamentals.allTimeLow) / fundamentals.allTimeLow) *
        100;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _HeroCard(snapshot: snapshot),
        const SizedBox(height: 14),
        _SectionHeader(
          label: 'Thong ke thi truong',
          accentColor: pair.logoColor,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: _marketBlue,
              label: 'Von hoa thi truong',
              value: _formatCompact(fundamentalsMarketCap(pair), prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: _formatCompact(
                fundamentals.fullyDilutedValuation,
                prefix: r'$',
              ),
            ),
            _InfoRowData(
              icon: Icons.show_chart_rounded,
              iconColor: AppColors.buy,
              label: 'Khoi luong 24h',
              value: _formatCompact(pair.volume24h, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.trending_up_rounded,
              iconColor: AppColors.warn,
              label: 'Vol/MCap',
              value:
                  '${((pair.volume24h / pair.marketCap) * 100).toStringAsFixed(2)}%',
            ),
            _InfoRowData(
              icon: Icons.arrow_outward_rounded,
              iconColor: AppColors.buy,
              label: 'ROI 1 nam',
              value: '+${fundamentals.roi1y.toStringAsFixed(2)}%',
              valueColor: AppColors.buy,
            ),
          ],
        ),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Cung token', accentColor: _marketBlue),
        _SupplyCard(fundamentals: fundamentals, supplyPct: supplyPct),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Phan bo cung',
          accentColor: AppColors.accent,
        ),
        _DistributionCard(distribution: fundamentals.supplyDistribution),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Ky luc gia', accentColor: AppColors.warn),
        _AthAtlCards(
          fundamentals: fundamentals,
          athDropPct: athDropPct,
          atlGainPct: atlGainPct,
        ),
        const SizedBox(height: 14),
        _ChartLink(pairId: pair.id),
      ],
    );
  }
}

double fundamentalsMarketCap(MarketPair pair) => pair.marketCap;

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final pair = snapshot.pair;
    final fundamentals = snapshot.fundamentals;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFF0D1833),
        border: Border.all(color: _marketBlue.withValues(alpha: 0.22)),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _TokenAvatar(symbol: pair.baseAsset, color: pair.logoColor),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        fundamentals.name,
                        style: AppTextStyles.sectionTitle.copyWith(
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        fundamentals.consensus,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    _formatPrice(pair.price),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.pageTitle.copyWith(
                      fontSize: 28,
                      fontFeatures: AppTextStyles.tabularFigures,
                    ),
                  ),
                ),
                _ChangePill(change: pair.change24h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TokenAvatar extends StatelessWidget {
  const _TokenAvatar({required this.symbol, required this.color});

  final String symbol;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.20),
        borderRadius: AppRadii.cardRadius,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
        ),
      ),
    );
  }
}

class _ChangePill extends StatelessWidget {
  const _ChangePill({required this.change});

  final double change;

  @override
  Widget build(BuildContext context) {
    final positive = change >= 0;
    final color = positive ? AppColors.buy : AppColors.sell;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: AppRadii.smRadius,
      ),
      child: Text(
        '${positive ? '+' : ''}${change.toStringAsFixed(2)}%',
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: AppTextStyles.bold,
          height: 1,
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.accentColor});

  final String label;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 14,
          decoration: BoxDecoration(
            color: accentColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontWeight: AppTextStyles.bold,
          ),
        ),
      ],
    );
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.rows});

  final List<_InfoRowData> rows;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i += 1)
            _InfoRow(row: rows[i], showDivider: i != rows.length - 1),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.row, required this.showDivider});

  final _InfoRowData row;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: showDivider
            ? const Border(bottom: BorderSide(color: AppColors.divider))
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: [
            Icon(row.icon, size: 13, color: row.iconColor),
            const SizedBox(width: 9),
            Expanded(
              child: Text(
                row.label,
                style: AppTextStyles.caption.copyWith(color: AppColors.text3),
              ),
            ),
            Text(
              row.value,
              textAlign: TextAlign.right,
              style: AppTextStyles.caption.copyWith(
                color: row.valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
                fontFeatures: AppTextStyles.tabularFigures,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SupplyCard extends StatelessWidget {
  const _SupplyCard({required this.fundamentals, required this.supplyPct});

  final TokenFundamentalsDraft fundamentals;
  final double? supplyPct;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _MetricLine(
            label: 'Luu hanh',
            value:
                '${_formatCompact(fundamentals.circulatingSupply)} ${fundamentals.symbol}',
          ),
          if (supplyPct != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      minHeight: 6,
                      value: (supplyPct! / 100).clamp(0, 1).toDouble(),
                      backgroundColor: AppColors.surface3,
                      valueColor: const AlwaysStoppedAnimation(
                        AppColors.primarySoft,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${supplyPct!.toStringAsFixed(1)}%',
                  style: AppTextStyles.micro.copyWith(
                    color: AppColors.text3,
                    fontFeatures: AppTextStyles.tabularFigures,
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          _MetricLine(
            label: 'Tong cung',
            value:
                '${_formatCompact(fundamentals.totalSupply)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Cung toi da',
            value:
                '${_formatCompact(fundamentals.maxSupply ?? 0)} ${fundamentals.symbol}',
            muted: true,
          ),
          _MetricLine(
            label: 'Ty le lam phat',
            value: '+${fundamentals.inflationRate.toStringAsFixed(2)}%',
            valueColor: AppColors.warn,
          ),
        ],
      ),
    );
  }
}

class _MetricLine extends StatelessWidget {
  const _MetricLine({
    required this.label,
    required this.value,
    this.muted = false,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool muted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.caption.copyWith(color: AppColors.text3),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: valueColor ?? (muted ? AppColors.text2 : AppColors.text1),
              fontWeight: muted ? AppTextStyles.medium : AppTextStyles.bold,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _DistributionCard extends StatelessWidget {
  const _DistributionCard({required this.distribution});

  final List<SupplyDistributionDraft> distribution;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CustomPaint(
            size: const Size.square(80),
            painter: _DonutPainter(distribution),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [
                for (final item in distribution)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: item.color,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.label,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.text2,
                            ),
                          ),
                        ),
                        Text(
                          '${item.percentage.toStringAsFixed(1)}%',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ],
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

class _DonutPainter extends CustomPainter {
  const _DonutPainter(this.distribution);

  final List<SupplyDistributionDraft> distribution;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.butt;
    for (final item in distribution) {
      final sweep = math.pi * 2 * (item.percentage / 100);
      canvas.drawArc(
        rect.deflate(9),
        start,
        sweep,
        false,
        paint..color = item.color,
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) {
    return oldDelegate.distribution != distribution;
  }
}

class _AthAtlCards extends StatelessWidget {
  const _AthAtlCards({
    required this.fundamentals,
    required this.athDropPct,
    required this.atlGainPct,
  });

  final TokenFundamentalsDraft fundamentals;
  final double athDropPct;
  final double atlGainPct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PriceRecordCard(
            label: 'ATH',
            icon: Icons.trending_up_rounded,
            color: AppColors.buy,
            value: _formatPrice(fundamentals.allTimeHigh),
            date: fundamentals.allTimeHighDate,
            delta: '${athDropPct.toStringAsFixed(1)}% so voi ATH',
            deltaColor: AppColors.sell,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _PriceRecordCard(
            label: 'ATL',
            icon: Icons.trending_down_rounded,
            color: AppColors.sell,
            value: _formatPrice(fundamentals.allTimeLow),
            date: fundamentals.allTimeLowDate,
            delta: '+${atlGainPct.toStringAsFixed(1)}% so voi ATL',
            deltaColor: AppColors.buy,
          ),
        ),
      ],
    );
  }
}

class _PriceRecordCard extends StatelessWidget {
  const _PriceRecordCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.value,
    required this.date,
    required this.delta,
    required this.deltaColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String value;
  final String date;
  final String delta;
  final Color deltaColor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(14),
      borderColor: color.withValues(alpha: 0.18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.micro.copyWith(
                  color: color,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              fontSize: 14,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
          Text(
            date,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 8),
          Text(
            delta,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.micro.copyWith(
              color: deltaColor,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartLink extends StatelessWidget {
  const _ChartLink({required this.pairId});

  final String pairId;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: TokenInfoPage.chartButtonKey,
      onTap: () => context.go(AppRoutePaths.pairDetail(pairId)),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _marketBlue.withValues(alpha: 0.12),
              borderRadius: AppRadii.cardRadius,
            ),
            child: const Icon(Icons.bar_chart_rounded, color: _marketBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Xem bieu do & giao dich',
                  style: AppTextStyles.body.copyWith(
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Chart, so lenh, giao dich gan day',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: AppColors.text3),
        ],
      ),
    );
  }
}

class _OnchainTab extends StatelessWidget {
  const _OnchainTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.bolt_rounded,
                    color: AppColors.buy,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Hoat dong mang luoi (24h)',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Dia chi hoat dong',
                      value: _formatCompact(f.activeAddresses24h.toDouble()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'Giao dich',
                      value: _formatCompact(f.txCount24h.toDouble()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _MiniStat(
                      label: 'Tong holders',
                      value: _formatCompact(f.holders.toDouble()),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MiniStat(
                      label: 'TVL',
                      value: f.tvl == null
                          ? 'N/A'
                          : _formatCompact(f.tvl!, prefix: r'$'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Thong tin mang luoi',
          accentColor: _marketBlue,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.public_rounded,
              iconColor: _marketBlue,
              label: 'Mang luoi',
              value: f.network,
            ),
            _InfoRowData(
              icon: Icons.shield_rounded,
              iconColor: AppColors.accent,
              label: 'Dong thuan',
              value: f.consensus,
            ),
            const _InfoRowData(
              icon: Icons.info_outline_rounded,
              iconColor: AppColors.warn,
              label: 'Hop dong token',
              value: 'Blockchain goc',
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.micro.copyWith(color: AppColors.text3),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.sectionTitle.copyWith(
              fontSize: 20,
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectTab extends StatelessWidget {
  const _ProjectTab({required this.snapshot});

  final MarketTokenInfoSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final f = snapshot.fundamentals;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.article_outlined,
                    color: _marketBlue,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Gioi thieu',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(f.description, style: AppTextStyles.body),
            ],
          ),
        ),
        const SizedBox(height: 14),
        const _SectionHeader(label: 'Lien ket', accentColor: _marketBlue),
        _ProjectLinks(fundamentals: f),
        const SizedBox(height: 14),
        const _SectionHeader(
          label: 'Chi so quan trong',
          accentColor: AppColors.buy,
        ),
        _InfoCard(
          rows: [
            _InfoRowData(
              icon: Icons.bar_chart_rounded,
              iconColor: _marketBlue,
              label: 'Von hoa',
              value: _formatCompact(snapshot.pair.marketCap, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.layers_rounded,
              iconColor: AppColors.accent,
              label: 'FDV',
              value: _formatCompact(f.fullyDilutedValuation, prefix: r'$'),
            ),
            _InfoRowData(
              icon: Icons.token_rounded,
              iconColor: AppColors.warn,
              label: 'Cung luu hanh',
              value: '${_formatCompact(f.circulatingSupply)} ${f.symbol}',
            ),
          ],
        ),
      ],
    );
  }
}

class _ProjectLinks extends StatelessWidget {
  const _ProjectLinks({required this.fundamentals});

  final TokenFundamentalsDraft fundamentals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _LinkRow(
          icon: Icons.public_rounded,
          label: 'Website',
          value: fundamentals.website,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.description_outlined,
          label: 'Whitepaper',
          value: fundamentals.whitepaper,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.code_rounded,
          label: 'GitHub',
          value: fundamentals.github,
        ),
        const SizedBox(height: 8),
        _LinkRow(
          icon: Icons.alternate_email_rounded,
          label: 'Twitter',
          value: fundamentals.twitter,
        ),
      ],
    );
  }
}

class _LinkRow extends StatelessWidget {
  const _LinkRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: _marketBlue, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.medium,
                  ),
                ),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.open_in_new_rounded,
            color: AppColors.text3,
            size: 15,
          ),
        ],
      ),
    );
  }
}

class _Disclaimer extends StatelessWidget {
  const _Disclaimer();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.warn08,
        border: Border.all(color: AppColors.warningBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: AppColors.warn,
              size: 14,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Thong tin mang tinh tham khao, khong phai loi khuyen dau tu. Hay tu nghien cuu truoc khi dua ra quyet dinh.',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.warn,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatPrice(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}

String _formatCompact(double value, {String prefix = ''}) {
  final abs = value.abs();
  if (abs >= 1000000000) {
    return '$prefix${_formatNumber(value / 1000000000)}B';
  }
  if (abs >= 1000000) {
    return '$prefix${_formatNumber(value / 1000000)}M';
  }
  if (abs >= 1000) {
    return '$prefix${_formatNumber(value / 1000)}K';
  }
  return '$prefix${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)}';
}

String _formatNumber(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  final raw = parts[0];
  final buffer = StringBuffer();
  for (var i = 0; i < raw.length; i += 1) {
    if (i > 0 && (raw.length - i) % 3 == 0) buffer.write(',');
    buffer.write(raw[i]);
  }
  return '${buffer.toString()}.${parts[1]}';
}
