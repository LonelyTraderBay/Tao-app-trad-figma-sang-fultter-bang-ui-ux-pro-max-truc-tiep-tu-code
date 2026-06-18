part of 'trading_bots_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy, required this.onCreate});

  final TradeBotStrategy strategy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final risk = _riskStyle(strategy.risk);
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BotIcon(icon: strategy.icon, color: color),
              const SizedBox(width: AppSpacing.x4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            strategy.name,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.baseMedium.copyWith(
                              fontWeight: AppTextStyles.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.x3),
                        VitStatusPill(
                          label: risk.$1,
                          status: _riskStatus(strategy.risk),
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.x2),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Row(
            children: [
              _StrategyDetail(
                label: 'Lợi nhuận kỳ vọng',
                value: strategy.avgReturn,
                valueColor: AppColors.buy,
              ),
              const SizedBox(width: AppSpacing.x3),
              _StrategyDetail(
                label: 'Phù hợp với',
                value: strategy.suitableFor,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          VitCtaButton(
            key: TradingBotsPage.strategyCreateKey(strategy.id),
            onPressed: onCreate,
            height: AppSpacing.inputHeight,
            leading: const Icon(Icons.add_rounded),
            child: Text('Tạo Bot ${strategy.name}'),
          ),
        ],
      ),
    );
  }
}

class _StrategyDetail extends StatelessWidget {
  const _StrategyDetail({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VitCard(
        padding: AppSpacing.tradeBotCardPadding,
        variant: VitCardVariant.inner,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.micro),
            const SizedBox(height: AppSpacing.x1),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontWeight: AppTextStyles.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BotInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: AppSpacing.tradeBotCardPadding,
      borderColor: AppColors.warn.withValues(alpha: .20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: AppSpacing.tradeBotCheckboxIcon,
          ),
          const SizedBox(width: AppSpacing.x3),
          Expanded(
            child: Text(
              'Lưu ý quan trọng: Bot giao dịch không đảm bảo lợi nhuận. '
              'Hiệu suất trong quá khứ không đại diện cho kết quả tương lai.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                height: AppSpacing.tradeBotLineHeightLoose,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyBots extends StatelessWidget {
  const _EmptyBots({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: AppSpacing.x6),
        const VitCard(
          width: AppSpacing.launchpadBox64,
          height: AppSpacing.launchpadBox64,
          variant: VitCardVariant.inner,
          alignment: Alignment.center,
          child: Icon(
            Icons.smart_toy_outlined,
            color: AppColors.text3,
            size: AppSpacing.iconLg,
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        Text(
          'Chưa có bot nào đang chạy',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: AppSpacing.x4),
        _BotActionButton(
          label: 'Tạo Bot mới',
          icon: Icons.add_rounded,
          color: _botPrimary,
          onTap: onAdd,
        ),
      ],
    );
  }
}

class _CreateBotSheet extends StatefulWidget {
  const _CreateBotSheet({required this.strategy});

  final TradeBotStrategy strategy;

  @override
  State<_CreateBotSheet> createState() => _CreateBotSheetState();
}

class _CreateBotSheetState extends State<_CreateBotSheet> {
  bool _agreed = false;

  @override
  Widget build(BuildContext context) {
    final strategy = widget.strategy;
    final color = Color(strategy.colorHex);
    return VitSheetPanel(
      title: strategy.name,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                _BotIcon(icon: strategy.icon, color: color),
                const SizedBox(width: AppSpacing.x4),
                Expanded(
                  child: Text(
                    strategy.suitableFor,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
                VitIconButton(
                  onPressed: () => Navigator.pop(context, false),
                  icon: Icons.close_rounded,
                  tooltip: 'Close',
                  variant: VitIconButtonVariant.transparent,
                  size: VitIconButtonSize.md,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            VitCard(
              padding: AppSpacing.tradeBotCardPadding,
              variant: VitCardVariant.inner,
              borderColor: color.withValues(alpha: .22),
              child: Text(
                strategy.longDescription,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(height: AppSpacing.x4),
            for (final param in strategy.params) ...[
              _ParamPreview(param: param, color: color),
              const SizedBox(height: AppSpacing.x4),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  key: TradingBotsPage.sheetAgreeKey,
                  value: _agreed,
                  onChanged: (value) =>
                      setState(() => _agreed = value ?? false),
                  activeColor: color,
                  checkColor: AppColors.onAccent,
                  side: const BorderSide(color: AppColors.borderSolid),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    'Tôi hiểu các rủi ro và đồng ý với điều khoản sử dụng Bot',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.text2,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.x4),
            VitCtaButton(
              key: TradingBotsPage.sheetCreateKey,
              onPressed: _agreed ? () => Navigator.pop(context, true) : null,
              height: AppSpacing.inputHeight,
              variant: _agreed
                  ? VitCtaButtonVariant.primary
                  : VitCtaButtonVariant.secondary,
              child: Text(
                _agreed ? 'Khởi chạy ${strategy.name}' : 'Nhập thông số Bot',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ParamPreview extends StatelessWidget {
  const _ParamPreview({required this.param, required this.color});

  final TradeBotParam param;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          param.unit == null ? param.label : '${param.label} (${param.unit})',
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.formFieldLabelGap),
        VitCard(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.inputHeight - AppSpacing.formFieldLabelGap,
          ),
          alignment: Alignment.centerLeft,
          padding: AppSpacing.tradeBotActionButtonPadding(false),
          variant: VitCardVariant.inner,
          borderColor: color.withValues(alpha: .26),
          child: Text(
            param.defaultValue,
            style: AppTextStyles.baseMedium.copyWith(
              fontFeatures: AppTextStyles.tabularFigures,
            ),
          ),
        ),
      ],
    );
  }
}
