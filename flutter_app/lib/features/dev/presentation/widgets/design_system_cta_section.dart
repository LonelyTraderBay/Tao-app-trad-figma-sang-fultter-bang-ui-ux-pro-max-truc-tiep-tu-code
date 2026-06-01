import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_spacing.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/features/dev/presentation/widgets/design_system_common.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

class DesignSystemCtaSection extends StatelessWidget {
  const DesignSystemCtaSection({
    super.key,
    required this.sectionKey,
    required this.ctaDemoKey,
    required this.demos,
  });

  final Key sectionKey;
  final Key Function(String id) ctaDemoKey;
  final List<DesignCtaDemoDraft> demos;

  @override
  Widget build(BuildContext context) {
    return VitPageSection(
      key: sectionKey,
      label: 'CTAButton Component',
      children: [
        for (final demo in demos)
          _CtaDemo(demoKey: ctaDemoKey(demo.id), demo: demo),
        Row(
          children: [
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.success,
                onPressed: () {},
                child: const Text('Mua'),
              ),
            ),
            const SizedBox(width: AppSpacing.x3),
            Expanded(
              child: VitCtaButton(
                variant: VitCtaButtonVariant.danger,
                onPressed: () {},
                child: const Text('Bán'),
              ),
            ),
          ],
        ),
        VitCtaButton(
          variant: VitCtaButtonVariant.primary,
          leading: const Icon(Icons.bolt_rounded),
          onPressed: () {},
          child: const Text('Launchpad Subscribe'),
        ),
      ],
    );
  }
}

class _CtaDemo extends StatelessWidget {
  const _CtaDemo({required this.demoKey, required this.demo});

  final Key demoKey;
  final DesignCtaDemoDraft demo;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: demoKey,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DesignSystemCaption('variant="${demo.variant}"'),
        const SizedBox(height: AppSpacing.x2),
        VitCtaButton(
          variant: designSystemVariantFromString(demo.variant),
          loading: demo.loading,
          onPressed: demo.disabled ? null : () {},
          leading: designSystemLeadingForCta(demo.id),
          child: Text(demo.label),
        ),
      ],
    );
  }
}
