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
import '../../../shared/layout/vit_page_layout.dart';
import '../data/trade_repository.dart';

const _tradeBlue = Color(0xFF3B82F6);
const _tradeBlueDark = Color(0xFF2563EB);
const _cardBg = Color(0xFF171C24);
const _chipBg = Color(0xFF1D263B);
const _inactiveFormatBg = Color(0xFF202536);

class TradeHistoryExportPage extends ConsumerStatefulWidget {
  const TradeHistoryExportPage({super.key, this.shellRenderMode});

  static const exportKey = Key('sc054_export');
  static const newExportKey = Key('sc054_new_export');
  static const downloadKey = Key('sc054_download');

  static Key formatKey(String id) => Key('sc054_format_$id');
  static Key periodKey(String id) => Key('sc054_period_$id');
  static Key includeKey(String id) => Key('sc054_include_$id');

  final ShellRenderMode? shellRenderMode;

  @override
  ConsumerState<TradeHistoryExportPage> createState() =>
      _TradeHistoryExportPageState();
}

class _TradeHistoryExportPageState
    extends ConsumerState<TradeHistoryExportPage> {
  late String _format;
  late String _period;
  late List<TradeExportInclude> _includes;
  bool _isExporting = false;
  TradeExportResult? _result;

  @override
  void initState() {
    super.initState();
    final snapshot = ref.read(tradeRepositoryProvider).getTradeExport();
    _format = snapshot.formats.first.id;
    _period = '30d';
    _includes = snapshot.includes.toList(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    final snapshot = ref.watch(tradeRepositoryProvider).getTradeExport();
    final mode = widget.shellRenderMode ?? defaultShellRenderMode();
    final bottomChrome = mode.usesVisualQaFrame
        ? DeviceMetrics.bottomChrome
        : DeviceMetrics.nativeBottomChrome;

    return VitPageLayout(
      variant: VitPageVariant.flush,
      semanticLabel: 'SC-054 TradeHistoryExportPage',
      child: Material(
        type: MaterialType.transparency,
        child: Column(
          children: [
            VitHeader(
              title: 'Xuất lịch sử giao dịch',
              showBack: true,
              onBack: () => context.go(AppRoutePaths.trade),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.fromLTRB(
                        20,
                        14,
                        20,
                        bottomChrome + 126,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SummaryCard(stats: snapshot.stats),
                          const SizedBox(height: 24),
                          _Section(
                            title: 'Định dạng file',
                            child: _FormatSelector(
                              formats: snapshot.formats,
                              activeFormat: _format,
                              onChanged: (format) {
                                setState(() {
                                  _format = format;
                                  _result = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 26),
                          _Section(
                            title: 'Khoảng thời gian',
                            child: _PeriodSelector(
                              periods: snapshot.periods,
                              activePeriod: _period,
                              onChanged: (period) {
                                setState(() {
                                  _period = period;
                                  _result = null;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 26),
                          _Section(
                            title: 'Bao gồm dữ liệu',
                            child: _IncludeList(
                              includes: _includes,
                              onToggle: _toggleInclude,
                            ),
                          ),
                          const SizedBox(height: 18),
                          const _TaxNote(),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: bottomChrome,
                    child: _ExportFooter(
                      format: _format,
                      period: _period,
                      isExporting: _isExporting,
                      result: _result,
                      onExport: _handleExport,
                      onNewExport: () => setState(() => _result = null),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleInclude(String id) {
    setState(() {
      _result = null;
      _includes = [
        for (final item in _includes)
          item.id == id ? item.copyWith(checked: !item.checked) : item,
      ];
    });
  }

  Future<void> _handleExport() async {
    if (_isExporting) return;
    setState(() {
      _isExporting = true;
      _result = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 220));
    final request = TradeExportRequest(
      format: _format,
      period: _period,
      includeIds: [
        for (final item in _includes)
          if (item.checked) item.id,
      ],
    );
    final result = ref.read(tradeRepositoryProvider).createTradeExport(request);
    if (!mounted) return;
    setState(() {
      _isExporting = false;
      _result = result;
    });
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.stats});

  final TradeExportStats stats;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 15),
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng lệnh',
                    value: _formatInteger(stats.totalTrades),
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng KL giao dịch',
                    value: _formatCompact(stats.totalVolume),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _SummaryMetric(
                    label: 'Tổng phí',
                    value: _formatMoney(stats.totalFees),
                    color: AppColors.primarySoft,
                    small: true,
                  ),
                ),
                Expanded(
                  child: _SummaryMetric(
                    label: 'Lãi/Lỗ ròng',
                    value: '+${_formatMoney(stats.netPnl)}',
                    color: AppColors.buy,
                    small: true,
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

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text1,
    this.small = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool small;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.micro.copyWith(
            color: AppColors.text3,
            height: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.caption.copyWith(
            color: color,
            fontSize: small ? 14 : 16,
            fontFamily: 'monospace',
            fontWeight: AppTextStyles.bold,
            height: 1,
            fontFeatures: AppTextStyles.tabularFigures,
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

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
                color: _tradeBlue,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: AppTextStyles.micro.copyWith(
                color: const Color(0xFF98A2B3),
                fontSize: 12,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _FormatSelector extends StatelessWidget {
  const _FormatSelector({
    required this.formats,
    required this.activeFormat,
    required this.onChanged,
  });

  final List<TradeExportFormat> formats;
  final String activeFormat;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < formats.length; i++) ...[
          Expanded(
            child: _FormatCard(
              key: TradeHistoryExportPage.formatKey(formats[i].id),
              format: formats[i],
              active: activeFormat == formats[i].id,
              onTap: () => onChanged(formats[i].id),
            ),
          ),
          if (i < formats.length - 1) const SizedBox(width: 12),
        ],
      ],
    );
  }
}

class _FormatCard extends StatelessWidget {
  const _FormatCard({
    super.key,
    required this.format,
    required this.active,
    required this.onTap,
  });

  final TradeExportFormat format;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _tradeBlue : const Color(0xFFAEB7CC);
    final icon = format.id == 'csv'
        ? Icons.table_chart_outlined
        : Icons.description_outlined;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 110,
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        decoration: BoxDecoration(
          color: active ? _tradeBlue.withValues(alpha: .12) : _inactiveFormatBg,
          border: Border.all(
            color: active ? _tradeBlue.withValues(alpha: .7) : Colors.white12,
            width: active ? 1.2 : 1,
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 12),
            Text(
              format.label,
              style: AppTextStyles.body.copyWith(
                color: active ? _tradeBlue : AppColors.text1,
                fontWeight: AppTextStyles.bold,
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              format.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                fontSize: 11,
                height: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({
    required this.periods,
    required this.activePeriod,
    required this.onChanged,
  });

  final List<TradeExportPeriod> periods;
  final String activePeriod;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        for (final period in periods)
          _PeriodChip(
            key: TradeHistoryExportPage.periodKey(period.id),
            period: period,
            active: activePeriod == period.id,
            onTap: () => onChanged(period.id),
          ),
      ],
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    super.key,
    required this.period,
    required this.active,
    required this.onTap,
  });

  final TradeExportPeriod period;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? _tradeBlue.withValues(alpha: .14) : _chipBg,
          border: Border.all(
            color: active ? _tradeBlue.withValues(alpha: .8) : Colors.white12,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 17),
          child: SizedBox(
            height: 36,
            child: Center(
              widthFactor: 1,
              child: Text(
                period.label,
                style: AppTextStyles.caption.copyWith(
                  color: active ? _tradeBlue : AppColors.text2,
                  fontWeight: active
                      ? AppTextStyles.bold
                      : AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _IncludeList extends StatelessWidget {
  const _IncludeList({required this.includes, required this.onToggle});

  final List<TradeExportInclude> includes;
  final ValueChanged<String> onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _cardBg,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: AppRadii.cardRadius,
      ),
      child: Column(
        children: [
          for (var i = 0; i < includes.length; i++)
            _IncludeRow(
              key: TradeHistoryExportPage.includeKey(includes[i].id),
              include: includes[i],
              isLast: i == includes.length - 1,
              onTap: () => onToggle(includes[i].id),
            ),
        ],
      ),
    );
  }
}

class _IncludeRow extends StatelessWidget {
  const _IncludeRow({
    super.key,
    required this.include,
    required this.isLast,
    required this.onTap,
  });

  final TradeExportInclude include;
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 41,
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isLast ? Colors.transparent : AppColors.divider,
            ),
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                include.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.medium,
                  height: 1,
                ),
              ),
            ),
            _CheckBox(checked: include.checked),
          ],
        ),
      ),
    );
  }
}

class _CheckBox extends StatelessWidget {
  const _CheckBox({required this.checked});

  final bool checked;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: checked ? AppColors.buy : Colors.transparent,
        border: Border.all(
          color: checked ? AppColors.buy : const Color(0xFF34446A),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: checked
          ? const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 14,
            )
          : null,
    );
  }
}

class _TaxNote extends StatelessWidget {
  const _TaxNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      decoration: BoxDecoration(
        color: _tradeBlue.withValues(alpha: .06),
        border: Border.all(color: _tradeBlue.withValues(alpha: .18)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 1),
            child: Icon(Icons.info_outline, color: _tradeBlue, size: 14),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              'File xuất phục vụ mục đích lưu trữ và khai thuế. Không phải tài liệu '
              'chính thức về thuế. Tham khảo ý kiến chuyên gia thuế cho trường hợp cụ thể.',
              style: AppTextStyles.micro.copyWith(
                color: _tradeBlue,
                fontSize: 11,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExportFooter extends StatelessWidget {
  const _ExportFooter({
    required this.format,
    required this.period,
    required this.isExporting,
    required this.result,
    required this.onExport,
    required this.onNewExport,
  });

  final String format;
  final String period;
  final bool isExporting;
  final TradeExportResult? result;
  final VoidCallback onExport;
  final VoidCallback onNewExport;

  @override
  Widget build(BuildContext context) {
    final exported = result != null;

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.surface2,
        border: Border(top: BorderSide(color: AppColors.divider)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, exported ? 12 : 16, 20, 14),
        child: exported
            ? Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 42,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.buy.withValues(alpha: .08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.check_circle_outline,
                          color: AppColors.buy,
                          size: 17,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'File đã sẵn sàng tải xuống',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.medium,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _FooterButton(
                          key: TradeHistoryExportPage.newExportKey,
                          label: 'Tạo mới',
                          foreground: AppColors.text2,
                          background: AppColors.surface3,
                          borderColor: AppColors.borderSolid,
                          onTap: onNewExport,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: _FooterButton(
                          key: TradeHistoryExportPage.downloadKey,
                          label: 'Tải ${format.toUpperCase()}',
                          icon: Icons.file_download_outlined,
                          foreground: Colors.white,
                          gradient: const LinearGradient(
                            colors: [AppColors.buy, Color(0xFF059669)],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : _FooterButton(
                key: TradeHistoryExportPage.exportKey,
                label: isExporting
                    ? 'Đang tạo file...'
                    : 'Xuất ${format.toUpperCase()} ($period)',
                icon: isExporting
                    ? Icons.schedule_outlined
                    : Icons.file_download_outlined,
                foreground: isExporting ? AppColors.text3 : Colors.white,
                gradient: isExporting
                    ? null
                    : const LinearGradient(
                        colors: [_tradeBlue, _tradeBlueDark],
                      ),
                background: isExporting ? AppColors.surface3 : null,
                onTap: isExporting ? null : onExport,
              ),
      ),
    );
  }
}

class _FooterButton extends StatelessWidget {
  const _FooterButton({
    super.key,
    required this.label,
    required this.foreground,
    this.onTap,
    this.icon,
    this.background,
    this.gradient,
    this.borderColor,
  });

  final String label;
  final Color foreground;
  final VoidCallback? onTap;
  final IconData? icon;
  final Color? background;
  final Gradient? gradient;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: gradient == null ? background : null,
          gradient: gradient,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: foreground, size: 17),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.body.copyWith(
                  color: foreground,
                  fontWeight: AppTextStyles.bold,
                  height: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatInteger(int value) {
  final text = value.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) buffer.write(',');
    buffer.write(text[i]);
  }
  return buffer.toString();
}

String _formatCompact(double value) {
  if (value >= 1000000) {
    return '\$${(value / 1000000).toStringAsFixed(2)}M';
  }
  if (value >= 1000) return '\$${(value / 1000).toStringAsFixed(1)}K';
  return _formatMoney(value);
}

String _formatMoney(double value) {
  final fixed = value.toStringAsFixed(2);
  final parts = fixed.split('.');
  return '\$${_formatInteger(int.parse(parts[0]))}.${parts[1]}';
}
