import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'src/no_data_import_in_presentation_rule.dart';

/// Entrypoint required by `custom_lint` — every plugin package must define a
/// top-level `createPlugin` in `lib/<package_name>.dart`.
PluginBase createPlugin() => _VitTradeLints();

class _VitTradeLints extends PluginBase {
  @override
  List<LintRule> getLintRules(CustomLintConfigs configs) => const [
    NoDataImportInPresentationRule(),
  ];
}
