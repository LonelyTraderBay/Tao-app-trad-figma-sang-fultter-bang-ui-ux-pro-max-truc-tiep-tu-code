part of '../pages/bot_guide_page.dart';

class _StepsBlock extends StatelessWidget {
  const _StepsBlock({required this.color, required this.steps});

  final Color color;
  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How It Works:',
          style: AppTextStyles.caption.copyWith(
            color: AppColors.text1,
            fontSize: 13,
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: 8),
        for (var i = 0; i < steps.length; i++) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '${i + 1}.',
                  style: AppTextStyles.caption.copyWith(
                    color: color,
                    fontSize: 12,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  steps[i],
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
          if (i != steps.length - 1) const SizedBox(height: 7),
        ],
      ],
    );
  }
}

class _BulletsBlock extends StatelessWidget {
  const _BulletsBlock({
    required this.title,
    required this.titleColor,
    required this.background,
    required this.items,
  });

  final String title;
  final Color titleColor;
  final Color background;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.micro.copyWith(
              color: titleColor,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 4,
                  height: 4,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: titleColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text2,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}

class _BestForBlock extends StatelessWidget {
  const _BestForBlock({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _guidePanel2,
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BEST FOR:',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text3,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleBlock extends StatelessWidget {
  const _ExampleBlock({required this.color, required this.example});

  final Color color;
  final TradeBotGuideExample example;

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Setup:', example.setup, AppColors.text1),
      ('Duration:', example.duration, AppColors.text1),
      ('Result:', example.result, AppColors.text1),
      ('Profit:', example.profit, _guideGreen),
    ];
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .08),
        border: Border.all(color: color.withValues(alpha: .30)),
        borderRadius: AppRadii.inputRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Example',
            style: AppTextStyles.micro.copyWith(
              color: color,
              fontSize: 11,
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 8),
          for (var i = 0; i < rows.length; i++) ...[
            if (i == 3)
              const Divider(height: 13, thickness: 1, color: AppColors.divider),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 62,
                  child: Text(
                    rows[i].$1,
                    style: AppTextStyles.micro.copyWith(
                      color: AppColors.text3,
                      fontSize: 11,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    rows[i].$2,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.micro.copyWith(
                      color: rows[i].$3,
                      fontSize: i == 3 ? 13 : 11,
                      fontWeight: AppTextStyles.bold,
                      fontFamily: 'Roboto',
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (i != rows.length - 1 && i != 2) const SizedBox(height: 6),
          ],
        ],
      ),
    );
  }
}
