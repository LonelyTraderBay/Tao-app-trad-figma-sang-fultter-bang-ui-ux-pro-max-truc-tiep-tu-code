/// Domain-safe semantic accent tone. Pure Dart - no Flutter dependency.
/// Resolved to a real [Color] only at the presentation edge, via
/// `AccentToneColors.resolve()` in `app/theme/accent_tone_colors.dart`.
enum AccentTone {
  buy,
  buyDark,
  sell,
  warn,
  warn10,
  info,
  accent,
  primary,
  primarySoft,
  caution,
  text1,
  text2,
  text3,
  medalSilverBlue,
  medalSilverBlue10,
  medalBronzeMuted,
  medalBronzeMuted10,
  tierPlatinum,
}
