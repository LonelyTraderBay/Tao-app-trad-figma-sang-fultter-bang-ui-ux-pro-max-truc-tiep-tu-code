import 'package:flutter/material.dart';

import 'package:vit_trade_flutter/app/theme/app_page_rhythm.dart';
import 'package:vit_trade_flutter/app/theme/tablet_dashboard_widths.dart';
import 'package:vit_trade_flutter/shared/layout/vit_page_content.dart';
import 'package:vit_trade_flutter/shared/widgets/widgets.dart';

/// Shared two-column tablet-dashboard scaffold for screens with a dedicated
/// tablet layout (Home, Wallet, Markets, Trade, Profile) — see
/// `docs/02_FLUTTER_MIGRATION/standards/Tablet-Adaptive-Standard.md`.
///
/// Below [twoColumnMinWidth], falls back to a single scrolling column
/// (still tablet shell, still nav rail, just not side-by-side) holding
/// [primaryChildren] followed by [secondaryChildren] (R3). At/above that
/// width, renders the true two-column dashboard: [primaryChildren] as the
/// main column, flush against the page background (its own sections already
/// carry their own card framing), and [secondaryChildren] as a sidebar
/// column framed as a distinct panel (R7).
///
/// This is the canonical explanation of the constraint-safety shape
/// mandated by R4/R5 of the Standard above:
///
/// * **R4 — independent-scroll columns.** Each column wraps its own
///   `SingleChildScrollView` inside the `Row`'s `Expanded` — never one
///   `SingleChildScrollView` wrapping the whole `Row`. A `Row` of unbounded
///   natural height inside a single outer scrollview breaks once any child
///   needs a bounded height; two independently height-bounded scrolling
///   columns is the supported shape.
/// * **R5 — width cap *inside* each column's `SingleChildScrollView`
///   child** (`Align` + `ConstrainedBox` wrapping that column's
///   `VitPageContent`) — never on the outer `Row`/`Expanded`.
///   `SingleChildScrollView` is what loosens *only* the height axis while
///   keeping width bounded; that's the one place a width cap can actually
///   narrow a column without also loosening the `Row`'s own tight-height
///   stretch, which independent scrolling depends on. A `ConstrainedBox`
///   placed directly on a tightly-constrained ancestor (e.g. `Expanded`
///   itself) is a no-op — tight incoming constraints always win over a
///   descendant's tighter bound.
///
/// R6: the two-column path uses `VitContentPadding.relaxed` +
/// `VitPageRhythm.relaxed`; the single-column fallback keeps `.compact`.
/// R8: [primaryColumnMaxWidth]/[secondaryColumnMaxWidth] default to the
/// per-column pixel widths confirmed not to overflow at the shared
/// threshold on multiple independent content sets — override these
/// constructor params locally on a page that empirically needs a different
/// number instead of editing [TabletDashboardWidths] (its own doc comment:
/// overridable defaults, not hard-shared state).
class VitTwoColumnTabletDashboard extends StatelessWidget {
  const VitTwoColumnTabletDashboard({
    super.key,
    required this.primaryChildren,
    required this.secondaryChildren,
    this.twoColumnMinWidth = TabletDashboardWidths.twoColumnMinWidth,
    this.primaryColumnMaxWidth = TabletDashboardWidths.primaryColumnMaxWidth,
    this.secondaryColumnMaxWidth =
        TabletDashboardWidths.secondaryColumnMaxWidth,
  });

  /// Main-column content. Flush against the page background at the
  /// two-column width; rendered first in the single-column fallback.
  final List<Widget> primaryChildren;

  /// Sidebar-panel content. Framed in a `VitCard` at the two-column width
  /// (R7); appended after [primaryChildren] in the single-column fallback.
  final List<Widget> secondaryChildren;

  /// Below this content width, falls back to a single scrolling column
  /// (R3). Defaults to [TabletDashboardWidths.twoColumnMinWidth] — only
  /// override after empirically re-verifying against the page's own
  /// content (R3, R8), not by guessing.
  final double twoColumnMinWidth;

  /// Caps the primary column's own width at/above [twoColumnMinWidth]
  /// (R8).
  final double primaryColumnMaxWidth;

  /// Caps the secondary column's own width at/above [twoColumnMinWidth]
  /// (R8).
  final double secondaryColumnMaxWidth;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < twoColumnMinWidth) {
          return SingleChildScrollView(
            child: VitPageContent(
              padding: VitContentPadding.compact,
              rhythm: VitPageRhythm.compact,
              children: [...primaryChildren, ...secondaryChildren],
            ),
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: primaryColumnMaxWidth,
                    ),
                    child: VitPageContent(
                      padding: VitContentPadding.relaxed,
                      rhythm: VitPageRhythm.relaxed,
                      children: primaryChildren,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: secondaryColumnMaxWidth,
                    ),
                    child: VitCard(
                      variant: VitCardVariant.inner,
                      radius: VitCardRadius.standard,
                      padding: EdgeInsets.zero,
                      child: VitPageContent(
                        padding: VitContentPadding.relaxed,
                        rhythm: VitPageRhythm.relaxed,
                        children: secondaryChildren,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
