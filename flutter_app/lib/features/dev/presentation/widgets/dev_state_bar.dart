import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_module_accents.dart';
import 'package:vit_trade_flutter/features/dev/domain/entities/dev_tools_entities.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared dev-tool screen-state switch used by top-level dev pages
/// (design system, missing screens showcase, performance monitor, route
/// checker) to preview live/loading/empty/error/offline states.
enum DevUiMode { live, loading, empty, error, offline }

class DevStateBar extends StatelessWidget {
  const DevStateBar({
    super.key,
    required this.supportedStates,
    required this.active,
    required this.onChanged,
  });

  final Set<DevScreenState> supportedStates;
  final DevUiMode active;
  final ValueChanged<DevUiMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final items = <VitPresetChipItem<DevUiMode>>[
      const VitPresetChipItem(value: DevUiMode.live, label: 'Live'),
      if (supportedStates.contains(DevScreenState.loading))
        const VitPresetChipItem(value: DevUiMode.loading, label: 'Loading'),
      if (supportedStates.contains(DevScreenState.empty))
        const VitPresetChipItem(value: DevUiMode.empty, label: 'Empty'),
      if (supportedStates.contains(DevScreenState.error))
        const VitPresetChipItem(value: DevUiMode.error, label: 'Error'),
      if (supportedStates.contains(DevScreenState.offline))
        const VitPresetChipItem(value: DevUiMode.offline, label: 'Offline'),
    ];

    return VitPageSection(
      label: 'Screen states',
      children: [
        VitPresetChipRow<DevUiMode>(
          items: items,
          selectedValue: active,
          onTap: onChanged,
          accentColor: AppModuleAccents.dev,
        ),
      ],
    );
  }
}
