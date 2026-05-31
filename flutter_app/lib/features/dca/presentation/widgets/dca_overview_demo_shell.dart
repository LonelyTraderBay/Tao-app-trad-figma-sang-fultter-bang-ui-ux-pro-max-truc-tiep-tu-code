part of '../pages/dca_overview_demo.dart';

class _LoadingToggle extends StatelessWidget {
  const _LoadingToggle({required this.active, required this.onTap});

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: DCAOverviewDemo.loadingToggleKey,
      onTap: onTap,
      borderRadius: AppRadii.xlRadius,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: active ? AppColors.sell15 : AppColors.primary15,
          borderRadius: AppRadii.xlRadius,
          border: Border.all(
            color: active ? AppColors.sell20 : AppColors.primary20,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.x4,
            vertical: AppSpacing.x2,
          ),
          child: Text(
            active ? 'Hide Loading' : 'Show Loading',
            style: AppTextStyles.caption.copyWith(
              color: active ? AppColors.sell : AppColors.primary,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
      ),
    );
  }
}

class _DemoSection extends StatelessWidget {
  const _DemoSection({
    super.key,
    required this.title,
    required this.description,
    required this.child,
  });

  final String title;
  final String description;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: AppTextStyles.sectionTitle.copyWith(fontSize: 18)),
        const SizedBox(height: AppSpacing.x2),
        Text(
          description,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        child,
      ],
    );
  }
}

class _DcaOverviewCardPreview extends StatefulWidget {
  const _DcaOverviewCardPreview({
    required this.scenario,
    this.isLoading = false,
    this.compact = false,
  });

  final DcaOverviewDemoScenario scenario;
  final bool isLoading;
  final bool compact;

  @override
  State<_DcaOverviewCardPreview> createState() =>
      _DcaOverviewCardPreviewState();
}

class _DcaOverviewCardPreviewState extends State<_DcaOverviewCardPreview> {
  bool _balanceHidden = false;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      key: DCAOverviewDemo.cardKey(widget.scenario.id),
      variant: VitCardVariant.hero,
      radius: VitCardRadius.lg,
      padding: EdgeInsets.all(
        widget.compact ? AppSpacing.x4 : AppSpacing.contentPad,
      ),
      child: widget.isLoading
          ? const _OverviewSkeleton()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _HeaderRow(
                  balanceHidden: _balanceHidden,
                  onToggle: () {
                    HapticFeedback.selectionClick();
                    setState(() => _balanceHidden = !_balanceHidden);
                  },
                ),
                const SizedBox(height: AppSpacing.x3),
                _ValueRow(
                  data: widget.scenario.data,
                  sparkline: widget.scenario.sparkline,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x3),
                _ProfitRow(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x5),
                _MetricGrid(
                  data: widget.scenario.data,
                  balanceHidden: _balanceHidden,
                ),
                const SizedBox(height: AppSpacing.x4),
                _NextExecutionRow(data: widget.scenario.data),
                if (widget.scenario.showActions) ...[
                  const SizedBox(height: AppSpacing.x4),
                  _ActionRow(scenarioId: widget.scenario.id),
                ],
              ],
            ),
    );
  }
}

class _HeaderRow extends StatelessWidget {
  const _HeaderRow({required this.balanceHidden, required this.onToggle});

  final bool balanceHidden;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tổng danh mục DCA (VND)',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.portfolioTextDim,
              fontWeight: AppTextStyles.bold,
            ),
          ),
        ),
        IconButton(
          visualDensity: VisualDensity.compact,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: onToggle,
          icon: Icon(
            balanceHidden
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.portfolioTextMuted,
            size: 18,
          ),
        ),
      ],
    );
  }
}

class _ValueRow extends StatelessWidget {
  const _ValueRow({
    required this.data,
    required this.sparkline,
    required this.balanceHidden,
  });

  final DcaOverviewDemoData data;
  final List<double> sparkline;
  final bool balanceHidden;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              balanceHidden
                  ? '••••••'
                  : '₫${_formatFullVnd(data.currentValueVnd)}',
              maxLines: 1,
              style: AppTextStyles.heroNumber.copyWith(
                fontSize: 31,
                fontWeight: FontWeight.w900,
                height: 1,
                color: AppColors.text1,
              ),
            ),
          ),
        ),
        if (sparkline.length >= 2) ...[
          const SizedBox(width: AppSpacing.x4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: AppSpacing.buttonHero + AppSpacing.x3,
                height: AppSpacing.buttonCompact + AppSpacing.x2,
                child: CustomPaint(
                  painter: _SparklinePainter(
                    values: sparkline,
                    lineColor: data.isProfit ? AppColors.buy : AppColors.sell,
                    fillColor: data.isProfit
                        ? AppColors.buy15
                        : AppColors.sell15,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.x1),
              Text(
                '90 ngày',
                style: AppTextStyles.micro.copyWith(
                  color: AppColors.portfolioTextMuted,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
