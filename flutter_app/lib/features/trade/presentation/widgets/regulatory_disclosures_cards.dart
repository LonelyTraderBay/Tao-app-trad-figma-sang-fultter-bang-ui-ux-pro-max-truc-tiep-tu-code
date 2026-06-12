part of '../pages/regulatory_disclosures_page.dart';

class _DisclosureCard extends StatelessWidget {
  const _DisclosureCard({
    required this.block,
    this.color,
    this.tint,
    this.icon,
    this.numbered = false,
  });

  final TradeRegulatoryDisclosureBlock block;
  final Color? color;
  final Color? tint;
  final IconData? icon;
  final bool numbered;

  @override
  Widget build(BuildContext context) {
    final accent = color ?? AppColors.text1;
    return VitCard(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      variant: tint == null ? VitCardVariant.standard : VitCardVariant.inner,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: accent, size: 14),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  block.title,
                  style: AppTextStyles.caption.copyWith(
                    color: accent,
                    fontWeight: AppTextStyles.bold,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          if (block.body.isNotEmpty) ...[
            const SizedBox(height: 7),
            Text(
              block.body,
              style: AppTextStyles.micro.copyWith(
                color: color ?? AppColors.text3,
                height: 1.45,
              ),
            ),
          ],
          if (block.items.isNotEmpty) ...[
            if (block.body.isNotEmpty) const SizedBox(height: 8),
            for (var index = 0; index < block.items.length; index++) ...[
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Text(
                  numbered || block.items[index].startsWith(RegExp(r'\d\.'))
                      ? block.items[index]
                      : '* ${block.items[index]}',
                  style: AppTextStyles.micro.copyWith(
                    color: color ?? AppColors.text3,
                    height: 1.5,
                  ),
                ),
              ),
              if (index != block.items.length - 1) const SizedBox(height: 2),
            ],
          ],
        ],
      ),
    );
  }
}

class _CommitmentCard extends StatelessWidget {
  const _CommitmentCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
      borderColor: _legalPrimary,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: _legalPrimary,
            size: 14,
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.micro.copyWith(
                color: _legalPrimary,
                fontWeight: AppTextStyles.bold,
                height: 1.42,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningList extends StatelessWidget {
  const _WarningList({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.ghost,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      borderColor: AppColors.warningBorder,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: _legalAmber,
                size: 14,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.micro.copyWith(
                  color: _legalAmber,
                  fontWeight: AppTextStyles.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          for (final item in items) ...[
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                '* $item',
                style: AppTextStyles.micro.copyWith(
                  color: _legalAmber,
                  height: 1.4,
                ),
              ),
            ),
            if (item != items.last) const SizedBox(height: 2),
          ],
        ],
      ),
    );
  }
}

class _LeverageRules extends StatelessWidget {
  const _LeverageRules({required this.rules});

  final List<TradeRegulatoryDisclosureBlock> rules;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Leverage Restrictions by Region',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.text1,
              fontWeight: AppTextStyles.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 11),
          for (final rule in rules) ...[
            Text(
              rule.title,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text2,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              rule.body,
              style: AppTextStyles.micro.copyWith(
                color: AppColors.text3,
                height: 1.3,
              ),
            ),
            if (rule != rules.last) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
