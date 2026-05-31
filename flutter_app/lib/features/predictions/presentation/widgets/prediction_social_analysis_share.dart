part of '../pages/prediction_social_page.dart';

class _SentimentCard extends StatelessWidget {
  const _SentimentCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Community Sentiment',
            style: AppTextStyles.body.copyWith(fontWeight: AppTextStyles.bold),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 190,
            child: CustomPaint(
              painter: PredictionSocialSentimentPiePainter(snapshot.sentiment),
              child: const SizedBox.expand(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final item in snapshot.sentiment)
                Expanded(child: PredictionSocialSentimentLegend(item: item)),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContributorsSection extends StatelessWidget {
  const _ContributorsSection({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Nguoi dong gop hang dau',
      accentColor: _predictionPrimary,
      children: [
        for (var i = 0; i < snapshot.contributors.length; i += 1)
          _ContributorCard(rank: i, contributor: snapshot.contributors[i]),
      ],
    );
  }
}

class _SocialShareButtons extends StatelessWidget {
  const _SocialShareButtons({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Chia se qua mang xa hoi',
      accentColor: _predictionPrimary,
      children: [
        Row(
          children: const [
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Twitter',
                color: AppColors.brandTwitter,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: PredictionSocialShareButton(
                label: 'Facebook',
                color: AppColors.brandFacebook,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CopyLinkCard extends StatelessWidget {
  const _CopyLinkCard({
    required this.snapshot,
    required this.copied,
    required this.onCopy,
  });

  final PredictionSocialSnapshot snapshot;
  final bool copied;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sao chep lien ket',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 38,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.bg,
                    border: Border.all(color: AppColors.border),
                    borderRadius: AppRadii.mdRadius,
                  ),
                  child: Text(
                    snapshot.shareUrl,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text2),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                key: PredictionSocialPage.copyLinkKey,
                height: 38,
                child: ElevatedButton.icon(
                  onPressed: onCopy,
                  icon: Icon(
                    copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 14,
                  ),
                  label: Text(copied ? 'Copied' : 'Copy'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: copied
                        ? AppColors.buy
                        : _predictionPrimary,
                    foregroundColor: AppColors.onAccent,
                    textStyle: AppTextStyles.micro.copyWith(
                      fontWeight: AppTextStyles.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadii.mdRadius,
                    ),
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

class _ShareStatsCard extends StatelessWidget {
  const _ShareStatsCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: PredictionSocialMetric(
              label: 'Total Shares',
              value: '1,247',
            ),
          ),
          Expanded(
            child: PredictionSocialMetric(
              label: 'Views from Shares',
              value: '4,892',
              valueColor: AppColors.buy,
            ),
          ),
        ],
      ),
    );
  }
}

class _SharePreviewCard extends StatelessWidget {
  const _SharePreviewCard({required this.snapshot});

  final PredictionSocialSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      label: 'Preview',
      accentColor: _predictionPrimary,
      children: [
        VitCard(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_predictionPrimary, AppColors.accent],
                  ),
                  borderRadius: AppRadii.mdRadius,
                ),
                child: const Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.onAccent,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.eventTitle,
                      style: AppTextStyles.body.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Join the prediction market and share your insights with the community.',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text2,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'app.example.com',
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ContributorCard extends StatelessWidget {
  const _ContributorCard({required this.rank, required this.contributor});

  final int rank;
  final PredictionContributorDraft contributor;

  @override
  Widget build(BuildContext context) {
    return VitCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.workspace_premium_rounded,
            color: _rankColor(rank),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      contributor.name,
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    _SmallBadge(
                      label: _tierLabel(contributor.tier),
                      color: _tierColor(contributor.tier),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${contributor.comments} comments - ${contributor.upvotes} upvotes',
                  style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SentimentTrendCard extends StatelessWidget {
  const _SentimentTrendCard();

  @override
  Widget build(BuildContext context) {
    return VitCard(
      variant: VitCardVariant.inner,
      borderColor: AppColors.buy20,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sentiment Trend',
            style: AppTextStyles.caption.copyWith(
              fontWeight: AppTextStyles.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Bullish sentiment tang 12% trong 24h qua. Cho thay su lac quan tang len.',
            style: AppTextStyles.micro.copyWith(
              color: AppColors.text2,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

Color _stanceColor(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => AppColors.buy,
    PredictionSocialStance.bearish => AppColors.sell,
    PredictionSocialStance.neutral => AppColors.text3,
  };
}

String _stanceLabel(PredictionSocialStance stance) {
  return switch (stance) {
    PredictionSocialStance.bullish => 'Bullish',
    PredictionSocialStance.bearish => 'Bearish',
    PredictionSocialStance.neutral => 'Neutral',
  };
}

Color _tierColor(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => AppColors.tierPlatinum,
    PredictionSocialTier.gold => AppColors.warn,
    PredictionSocialTier.silver => AppColors.medalSilverMuted,
    PredictionSocialTier.bronze => AppColors.medalBronzeMuted,
  };
}

String _tierLabel(PredictionSocialTier tier) {
  return switch (tier) {
    PredictionSocialTier.platinum => 'PLATINUM',
    PredictionSocialTier.gold => 'GOLD',
    PredictionSocialTier.silver => 'SILVER',
    PredictionSocialTier.bronze => 'BRONZE',
  };
}

Color _rankColor(int rank) {
  return switch (rank) {
    0 => AppColors.warn,
    1 => AppColors.medalSilverMuted,
    _ => AppColors.medalBronzeMuted,
  };
}
