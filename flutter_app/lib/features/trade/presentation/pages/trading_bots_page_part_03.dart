part of 'trading_bots_page.dart';

class _StrategyCard extends StatelessWidget {
  const _StrategyCard({required this.strategy, required this.onCreate});

  final TradeBotStrategy strategy;
  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    final color = Color(strategy.colorHex);
    final risk = _riskStyle(strategy.risk);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BotIcon(icon: strategy.icon, color: color),
              const SizedBox(width: 12),
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: risk.$2,
                            borderRadius: AppRadii.smRadius,
                          ),
                          child: Text(
                            risk.$1,
                            style: AppTextStyles.micro.copyWith(
                              color: risk.$3,
                              fontWeight: AppTextStyles.bold,
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      strategy.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _StrategyDetail(
                label: 'Lợi nhuận kỳ vọng',
                value: strategy.avgReturn,
                valueColor: AppColors.buy,
              ),
              const SizedBox(width: 8),
              _StrategyDetail(
                label: 'Phù hợp với',
                value: strategy.suitableFor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          InkWell(
            key: TradingBotsPage.strategyCreateKey(strategy.id),
            onTap: onCreate,
            borderRadius: AppRadii.cardRadius,
            child: Container(
              height: AppSpacing.inputHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: .68)],
                ),
                borderRadius: AppRadii.cardRadius,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: .25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.add_rounded,
                    color: AppColors.onAccent,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Tạo Bot ${strategy.name}',
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: AppTextStyles.bold,
                    ),
                  ),
                ],
              ),
            ),
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
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: _chipBackground,
          borderRadius: AppRadii.cardRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: AppTextStyles.micro.copyWith(fontSize: 10)),
            const SizedBox(height: 4),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.caption.copyWith(
                color: valueColor ?? AppColors.text1,
                fontSize: 12,
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
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panelBackground,
        borderRadius: AppRadii.cardRadius,
        border: Border.all(color: AppColors.warn.withValues(alpha: .20)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warn,
            size: 16,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lưu ý quan trọng: Bot giao dịch không đảm bảo lợi nhuận. '
              'Hiệu suất trong quá khứ không đại diện cho kết quả tương lai.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.text2,
                fontSize: 12,
                height: 1.5,
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
        const SizedBox(height: 32),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: _chipBackground,
            borderRadius: AppRadii.cardRadius,
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            color: AppColors.text3,
            size: 32,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Chưa có bot nào đang chạy',
          style: AppTextStyles.caption.copyWith(color: AppColors.text3),
        ),
        const SizedBox(height: 12),
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
    final bottom = MediaQuery.paddingOf(context).bottom;
    return SafeArea(
      top: false,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * .85,
        ),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: AppColors.borderSolid)),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 20 + bottom),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderSolid,
                    borderRadius: AppRadii.xsRadius,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  _BotIcon(icon: strategy.icon, color: color),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strategy.name,
                          style: AppTextStyles.sectionTitle.copyWith(
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          strategy.suitableFor,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context, false),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.text2,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .08),
                  borderRadius: AppRadii.cardRadius,
                  border: Border.all(color: color.withValues(alpha: .22)),
                ),
                child: Text(
                  strategy.longDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              for (final param in strategy.params) ...[
                _ParamPreview(param: param, color: color),
                const SizedBox(height: 12),
              ],
              InkWell(
                key: TradingBotsPage.sheetAgreeKey,
                onTap: () => setState(() => _agreed = !_agreed),
                borderRadius: AppRadii.smRadius,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: _agreed ? color : AppColors.transparent,
                        borderRadius: AppRadii.xsRadius,
                        border: Border.all(
                          color: _agreed ? color : AppColors.borderSolid,
                        ),
                      ),
                      child: _agreed
                          ? const Icon(
                              Icons.check_rounded,
                              color: AppColors.onAccent,
                              size: 16,
                            )
                          : null,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tôi hiểu các rủi ro và đồng ý với điều khoản sử dụng Bot',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.text2,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              InkWell(
                key: TradingBotsPage.sheetCreateKey,
                onTap: _agreed ? () => Navigator.pop(context, true) : null,
                borderRadius: AppRadii.inputRadius,
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _agreed ? null : _chipBackground,
                    gradient: _agreed
                        ? LinearGradient(
                            colors: [color, color.withValues(alpha: .70)],
                          )
                        : null,
                    borderRadius: AppRadii.inputRadius,
                  ),
                  child: Text(
                    _agreed
                        ? 'Khởi chạy ${strategy.name}'
                        : 'Nhập thông số Bot',
                    style: AppTextStyles.baseMedium.copyWith(
                      color: _agreed ? AppColors.onAccent : AppColors.text3,
                      fontWeight: AppTextStyles.bold,
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
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text2,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          constraints: const BoxConstraints(minHeight: 46),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: _chipBackground,
            borderRadius: AppRadii.inputRadius,
            border: Border.all(color: color.withValues(alpha: .26)),
          ),
          child: Text(
            param.defaultValue,
            style: AppTextStyles.baseMedium.copyWith(
              fontFamily: param.type == 'number' ? 'monospace' : null,
            ),
          ),
        ),
      ],
    );
  }
}
