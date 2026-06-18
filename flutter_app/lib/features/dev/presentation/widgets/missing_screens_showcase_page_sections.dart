part of '../pages/missing_screens_showcase_page.dart';

class _ShowcaseTitle extends StatelessWidget {
  const _ShowcaseTitle({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const _IconBadge(
          icon: Icons.layers_outlined,
          color: AppColors.onAccent,
          background: AppColors.primary,
        ),
        const SizedBox(width: AppSpacing.x3),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.sectionTitleXs.copyWith(
                  fontWeight: AppTextStyles.bold,
                ),
              ),
              Text(
                snapshot.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.captionSm.copyWith(color: AppColors.text2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewScreensSection extends StatelessWidget {
  const _NewScreensSection({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: MissingScreensShowcasePage.newSectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.newScreensIntro,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final screen in snapshot.newScreens) ...[
          _NewScreenCard(screen: screen, onTap: () => context.go(screen.route)),
          if (screen != snapshot.newScreens.last)
            const SizedBox(height: AppSpacing.x4),
        ],
      ],
    );
  }
}

class _V2ScreensSection extends StatelessWidget {
  const _V2ScreensSection({required this.snapshot});

  final MissingScreensShowcaseSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: MissingScreensShowcasePage.v2SectionKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          snapshot.v2Intro,
          style: AppTextStyles.caption.copyWith(color: AppColors.text2),
        ),
        const SizedBox(height: AppSpacing.x4),
        for (final page in snapshot.v2Pages) ...[
          _V2PageCard(page: page, onTap: () => context.go(page.route)),
          if (page != snapshot.v2Pages.last)
            const SizedBox(height: AppSpacing.x4),
        ],
        const SizedBox(height: AppSpacing.x5),
        Text(
          'Prototype Connections (On Tap → Navigate)',
          style: AppTextStyles.baseMedium.copyWith(
            fontWeight: AppTextStyles.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.x3),
        VitCard(
          radius: VitCardRadius.lg,
          clip: true,
          child: Column(
            children: [
              for (final flow in snapshot.flowConnections) ...[
                _FlowRow(flow: flow, onTap: () => context.go(flow.fromRoute)),
                if (flow != snapshot.flowConnections.last) const _Divider(),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.x4),
        VitCard(
          padding: AppSpacing.devCardPadding,
          radius: VitCardRadius.md,
          borderColor: AppColors.primary20,
          child: Text(
            'Header back buttons giữ hành vi history và các dynamic preview dùng route mẫu an toàn.',
            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}

class _NewScreenCard extends StatelessWidget {
  const _NewScreenCard({required this.screen, required this.onTap});

  final DevShowcaseScreenDraft screen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(screen.id);

    return VitCard(
      key: MissingScreensShowcasePage.screenKey(screen.id),
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.lg,
      borderColor: _borderForId(screen.id),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: _iconForId(screen.id),
                color: accent,
                background: _backgroundForId(screen.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screen.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.baseMedium.copyWith(
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      screen.route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              _PreviewPill(color: accent),
            ],
          ),
          const SizedBox(height: AppSpacing.x4),
          Text(
            screen.description,
            style: AppTextStyles.caption.copyWith(color: AppColors.text2),
          ),
          const SizedBox(height: AppSpacing.x3),
          Wrap(
            spacing: AppSpacing.x2,
            runSpacing: AppSpacing.x2,
            children: [
              for (final state in screen.states) _StateChip(label: state),
            ],
          ),
        ],
      ),
    );
  }
}

class _V2PageCard extends StatelessWidget {
  const _V2PageCard({required this.page, required this.onTap});

  final DevShowcaseV2PageDraft page;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(page.id);

    return VitCard(
      key: MissingScreensShowcasePage.v2PageKey(page.id),
      padding: AppSpacing.devCardPadding,
      radius: VitCardRadius.lg,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              _IconBadge(
                icon: _iconForId(page.id),
                color: accent,
                background: _backgroundForId(page.id),
              ),
              const SizedBox(width: AppSpacing.x3),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      page.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.text1,
                        fontWeight: AppTextStyles.bold,
                      ),
                    ),
                    Text(
                      page.route,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.micro.copyWith(
                        color: AppColors.text3,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.text3,
                size: AppSpacing.iconMd,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.x3),
          for (final change in page.changes) ...[
            _ChangeRow(text: change, color: accent),
            if (change != page.changes.last)
              const SizedBox(height: AppSpacing.x2),
          ],
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({required this.flow, required this.onTap});

  final DevShowcaseFlowDraft flow;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = _accentForId(flow.id);

    return InkWell(
      key: MissingScreensShowcasePage.flowKey(flow.id),
      onTap: onTap,
      child: Padding(
        padding: AppSpacing.devCardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                DecoratedBox(
                  decoration: ShapeDecoration(
                    color: accent,
                    shape: const CircleBorder(),
                  ),
                  child: const SizedBox(
                    width: AppSpacing.x3,
                    height: AppSpacing.x3,
                  ),
                ),
                SizedBox(
                  width: AppSpacing.x1,
                  height: AppSpacing.x4,
                  child: ColoredBox(color: _backgroundForId(flow.id)),
                ),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: accent,
                  size: AppSpacing.iconSm,
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.x2,
                    children: [
                      Text(
                        flow.from,
                        style: AppTextStyles.captionSm.copyWith(
                          color: AppColors.text1,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.text3,
                        size: AppSpacing.iconSm,
                      ),
                      Text(
                        flow.to,
                        style: AppTextStyles.captionSm.copyWith(
                          color: accent,
                          fontWeight: AppTextStyles.medium,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    flow.trigger,
                    style: AppTextStyles.micro.copyWith(color: AppColors.text3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
