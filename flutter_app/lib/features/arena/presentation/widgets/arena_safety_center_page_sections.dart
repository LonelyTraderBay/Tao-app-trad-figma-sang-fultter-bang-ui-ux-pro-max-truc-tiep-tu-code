part of '../pages/arena_safety_center_page.dart';

class _SafetyHero extends StatelessWidget {
  const _SafetyHero({required this.snapshot});

  final ArenaSafetyCenterSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitModuleHeroCard(
      accentColor: AppColors.buy,
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        children: [
          const _ToneIcon(icon: Icons.shield_outlined, color: AppColors.buy),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  snapshot.bannerTitle,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  snapshot.bannerDescription,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.text2,
                    height: 1.45,
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

class _SafetySection extends StatelessWidget {
  const _SafetySection({
    required this.title,
    required this.accentColor,
    required this.children,
  });

  final String title;
  final Color accentColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 18,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: AppRadii.xsRadius,
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.baseMedium.copyWith(
                  color: AppColors.text1,
                  fontWeight: AppTextStyles.bold,
                  height: 1.25,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.x3),
        for (final child in children) ...[
          child,
          if (child != children.last) const SizedBox(height: AppSpacing.x3),
        ],
      ],
    );
  }
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule});

  final ArenaSafetyRuleDraft rule;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(rule.kind);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToneIcon(icon: _kindIcon(rule.kind), color: color),
          const SizedBox(width: AppSpacing.x4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.text1,
                    fontWeight: AppTextStyles.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.x1),
                Text(
                  rule.description,
                  style: AppTextStyles.caption.copyWith(
                    fontSize: 12,
                    color: AppColors.text2,
                    height: 1.35,
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

class _BannedContentCard extends StatelessWidget {
  const _BannedContentCard({required this.items});

  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final item in items) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.cancel_outlined,
                  size: 15,
                  color: AppColors.sell,
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Text(
                    item,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.text1,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
            if (item != items.last) const SizedBox(height: AppSpacing.x3),
          ],
        ],
      ),
    );
  }
}

class _ViolationProcessCard extends StatelessWidget {
  const _ViolationProcessCard({required this.items});

  final List<ArenaSafetyProcessDraft> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        children: [
          for (final item in items)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 30,
                  child: Column(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: AppColors.buy10,
                          borderRadius: AppRadii.xlRadius,
                          border: Border.all(color: AppColors.buy20),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${item.step}',
                          style: AppTextStyles.micro.copyWith(
                            color: AppColors.buy,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                      ),
                      if (item != items.last)
                        Container(width: 1, height: 28, color: AppColors.buy20),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.x3),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: item == items.last ? 0 : AppSpacing.x3,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.text1,
                            fontWeight: AppTextStyles.bold,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.x1),
                        Text(
                          item.description,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.text2,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.info});

  final ArenaSafetyInfoDraft info;

  @override
  Widget build(BuildContext context) {
    final color = _kindColor(info.kind);
    return VitCard(
      padding: const EdgeInsets.all(AppSpacing.x4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(_kindIcon(info.kind), color: color, size: 18),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      info.title,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.x1),
                    Text(
                      info.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: AppSpacing.x3),
          for (final item in info.items) ...[
            _SafetyCheckRow(item: item),
            if (item != info.items.last) const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _SafetyCheckRow extends StatelessWidget {
  const _SafetyCheckRow({required this.item});

  final ArenaSafetyCheckDraft item;

  @override
  Widget build(BuildContext context) {
    final color = item.allowed ? AppColors.buy : AppColors.sell;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          item.allowed ? Icons.check_circle_outline : Icons.cancel_outlined,
          color: color,
          size: 14,
        ),
        const SizedBox(width: AppSpacing.x2),
        Expanded(
          child: Text(
            item.text,
            style: AppTextStyles.caption.copyWith(
              color: item.allowed ? AppColors.text1 : AppColors.text2,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}
