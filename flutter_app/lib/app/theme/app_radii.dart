import 'package:flutter/material.dart';

/// Canonical border-radius tokens for VitTrade.
///
/// Primary UI tiers:
/// - [input] / [inputRadius] — 14px interactive controls (CTA, tab, chip, input)
/// - [card] / [cardRadius] — 16px standard cards
/// - [cardLarge] / [cardLargeRadius] — 24px hero/large cards and sheet tops
/// - [sm] / [smRadius] — 8px micro surfaces (avatar, delta chip, icon bg)
/// - [pill] / [pillRadius] — 999 status/accent pills
final class AppRadii {
  const AppRadii._();

  /// Micro tier alias — prefer [sm] for new code.
  @Deprecated('Use AppRadii.sm (8px) for micro surfaces')
  static const double xs = sm;

  static const double hairline = 2;
  static const double swatch = 3;
  static const double badge = 6;
  static const double sm = 8;

  /// Legacy header chrome — prefer [input] for interactive controls.
  @Deprecated('Use AppRadii.input for interactive controls')
  static const double headerAction = 10;

  /// Legacy nested/chart panel — do not use for new cards or controls.
  @Deprecated('Use AppRadii.card or AppRadii.sm for new UI')
  static const double md = 13;

  static const double input = 14;
  static const double card = 16;
  static const double lg = 21;
  static const double cardLarge = 24;
  static const double xl = 34;
  static const double device = 55;
  static const double pill = 999;
  static const double sheetTop = 22;
  static const double avatar = 999;
  static const double chart = 13;
  static const double chartBar = 4;
  static const double dynamicIsland = 22;
  static const double statusSignal = 0.75;
  static const double predictionDetailChartVolumeBar = hairline;
  static const double predictionDetailOrderBookRow = chartBar;
  static const double disputeBubble = 16;
  static const double disputeBubbleTail = 4;

  @Deprecated('Use AppRadii.smRadius for micro surfaces')
  static const BorderRadius xsRadius = smRadius;
  @Deprecated('Use AppRadii.smCorner for micro surfaces')
  static const Radius xsCorner = smCorner;
  static const BorderRadius hairlineRadius = BorderRadius.all(
    Radius.circular(hairline),
  );
  static const Radius hairlineCorner = Radius.circular(hairline);
  static const BorderRadius swatchRadius = BorderRadius.all(
    Radius.circular(swatch),
  );
  static const Radius swatchCorner = Radius.circular(swatch);
  static const BorderRadius badgeRadius = BorderRadius.all(
    Radius.circular(badge),
  );
  static const Radius statusBarCorner = Radius.circular(
    walletHistoryStatusBadge,
  );
  static const Radius statusSignalCorner = Radius.circular(statusSignal);
  static const BorderRadius statusSignalRadius = BorderRadius.all(
    statusSignalCorner,
  );
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const Radius smCorner = Radius.circular(sm);
  @Deprecated('Use AppRadii.inputRadius for interactive controls')
  static const BorderRadius headerActionRadius = BorderRadius.all(
    Radius.circular(headerAction),
  );
  @Deprecated('Use AppRadii.cardRadius or AppRadii.smRadius for new UI')
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(input),
  );
  static const Radius inputCorner = Radius.circular(input);
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const Radius lgCorner = Radius.circular(lg);
  static const BorderRadius cardLargeRadius = BorderRadius.all(
    Radius.circular(cardLarge),
  );
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius pillRadius = BorderRadius.all(
    Radius.circular(pill),
  );
  static const BorderRadius sheetTopRadius = BorderRadius.only(
    topLeft: Radius.circular(sheetTop),
    topRight: Radius.circular(sheetTop),
  );
  static const BorderRadius sheetTopLargeRadius = BorderRadius.only(
    topLeft: Radius.circular(cardLarge),
    topRight: Radius.circular(cardLarge),
  );
  static const double walletHistoryTradeBadge = 6;
  static const BorderRadius walletHistoryTradeBadgeRadius = BorderRadius.all(
    Radius.circular(walletHistoryTradeBadge),
  );
  static const double walletHistoryStatusBadge = 4;
  static const BorderRadius walletHistoryStatusBadgeRadius = BorderRadius.all(
    Radius.circular(walletHistoryStatusBadge),
  );
  static const BorderRadius avatarRadius = BorderRadius.all(
    Radius.circular(avatar),
  );
  static const BorderRadius chartRadius = BorderRadius.all(
    Radius.circular(chart),
  );
  static const Radius chartBarCorner = Radius.circular(chartBar);
  static const BorderRadius predictionDetailChartVolumeBarRadius =
      BorderRadius.all(Radius.circular(predictionDetailChartVolumeBar));
  static const BorderRadius predictionDetailOrderBookRowRadius =
      BorderRadius.all(Radius.circular(predictionDetailOrderBookRow));
  static const BorderRadius dynamicIslandRadius = BorderRadius.all(
    Radius.circular(dynamicIsland),
  );
  static const BorderRadius statusBatteryBodyRadius = BorderRadius.all(
    statusBarCorner,
  );
  static const BorderRadius statusBatteryFillRadius = hairlineRadius;
  static const BorderRadius statusBatteryTerminalRadius = BorderRadius.only(
    topRight: hairlineCorner,
    bottomRight: hairlineCorner,
  );
  static const BorderRadius deviceRadius = BorderRadius.all(
    Radius.circular(device),
  );
  static const Radius disputeBubbleCorner = Radius.circular(disputeBubble);
  static const Radius disputeBubbleTailCorner = Radius.circular(
    disputeBubbleTail,
  );

  static BorderRadius disputeMessageBubbleRadius({required bool isUser}) =>
      BorderRadius.only(
        topLeft: disputeBubbleCorner,
        topRight: disputeBubbleCorner,
        bottomLeft: isUser ? disputeBubbleCorner : disputeBubbleTailCorner,
        bottomRight: isUser ? disputeBubbleTailCorner : disputeBubbleCorner,
      );
}
