part of 'trading_bots_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy, required this.onCreate});

  final TradeBotStrategy strategy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    return VitCard(
      padding: TradeSpacingTokens.tradeBotCardPadding,
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
                          label: _riskStyle(strategy.risk).$1,
                          status: _riskStatus(strategy.risk),
                          size: VitStatusPillSize.sm,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSpacing.pageRhythmCompactInnerGap,
                    ),
                    Text(
                      strategy.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              VitAccentPill(
                label: strategy.avgReturn,
                accentColor: AppColors.buy,
                size: VitStatusPillSize.sm,
              ),
              VitAccentPill(
                label: strategy.suitableFor,
                accentColor: AppColors.text2,
                size: VitStatusPillSize.sm,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
          VitCtaButton(
            key: TradingBotsPage.strategyCreateKey(strategy.id),
            onPressed: onCreate,
            height: AppSpacing.inputHeight,
            leading: const Icon(Icons.add_rounded),
            child: Text('Tạo bot'),
          ),
        ],
      ),
    );
  }
}

class _RiskDisclaimer extends StatelessWidget {
  const _RiskDisclaimer();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Bot không đảm bảo lợi nhuận. Hiệu suất quá khứ không đại diện kết quả tương lai.',
      style: AppTextStyles.micro.copyWith(color: AppColors.text3),
      textAlign: TextAlign.center,
    );
  }
}

class _EmptyBots extends StatelessWidget {
  const _EmptyBots({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return VitEmptyState(
      title: 'Chưa có bot nào',
      message: 'Khám phá chiến lược phù hợp để khởi chạy bot đầu tiên.',
      icon: Icons.smart_toy_outlined,
      actionLabel: 'Khám phá chiến lược',
      actionKey: TradingBotsPage.addBotKey,
      onAction: onAdd,
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
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            VitCard(
              padding: TradeSpacingTokens.tradeBotCardPadding,
              variant: VitCardVariant.inner,
              borderColor: color.withValues(alpha: .22),
              child: Text(
                strategy.longDescription,
                style: AppTextStyles.caption.copyWith(color: AppColors.text2),
              ),
            ),
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
            for (final param in strategy.params) ...[
              _ParamPreview(param: param, color: color),
              const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
            const SizedBox(height: AppSpacing.pageRhythmStandardSectionGap),
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
        // card-tile: allow-start — fixed surface, not horizontal strip tile
        VitCard(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.inputHeight - AppSpacing.formFieldLabelGap,
          ),
          alignment: Alignment.centerLeft,
          padding: TradeSpacingTokens.tradeBotActionButtonPadding(false),
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
