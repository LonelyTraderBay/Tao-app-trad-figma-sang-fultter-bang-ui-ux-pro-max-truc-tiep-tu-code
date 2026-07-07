import 'package:flutter/material.dart';

final class AppColors {
  AppColors._();

  static const Color bg = Color(0xFF07090D);
  static const Color surface = Color(0xFF10141B);
  static const Color surface2 = Color(0xFF171C24);
  static const Color surface3 = Color(0xFF222936);
  static const Color border = Color(0x0FFFFFFF);
  static const Color borderSolid = Color(0xFF2D3440);

  static const Color primary = Color(0xFFE58A00);
  static const Color primaryDark = Color(0xFFB96000);
  static const Color primarySoft = Color(0xFFF5A524);
  static const Color buy = Color(0xFF10B981);
  static const Color buyDark = Color(0xFF059669);
  static const Color sell = Color(0xFFEF4444);
  static const Color sellDark = Color(0xFFDC2626);
  static const Color sellDeep = Color(0xFF991B1B);
  static const Color sellSoft = Color(0xFFFCA5A5);
  // TOKEN-WARN-01: warn used to conflate "this is a warning/risk signal" with
  // "soft brand orange" (primarySoft). riskWarning is now the canonical color
  // for real warning/risk UI; moduleAccentAmber is the canonical color for
  // module brand identity that previously borrowed warn for that purpose.
  @Deprecated(
    'Superseded by AppColors.riskWarning or AppColors.moduleAccentAmber '
    'after TOKEN-WARN-01. warn conflated "warning" and "soft brand orange" — '
    'pick the token matching actual intent at each call site.',
  )
  static const Color warn = primarySoft;
  static const Color riskWarning = Color(0xFFF0A63A);
  static const Color moduleAccentAmber = primarySoft;
  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color info = Color(0xFF3B82F6);
  static const Color caution = Color(0xFFF59E0B);
  static const Color riskHigh = Color(0xFFF97316);
  static const Color medalGold = Color(0xFFFFD700);
  static const Color medalSilver = Color(0xFFC0C0C0);
  static const Color medalSilverMuted = Color(0xFF9CA3AF);
  static const Color medalSilverBlue = Color(0xFF94A3B8);
  static const Color medalSilverBlue10 = Color(0x1A94A3B8);
  static const Color medalBronze = Color(0xFFCD7F32);
  static const Color medalBronzeMuted = Color(0xFFD97706);
  static const Color medalBronzeMuted10 = Color(0x1AD97706);
  static const Color tierPlatinum = Color(0xFFE5E7EB);
  static const Color brandTwitter = Color(0xFF1DA1F2);
  static const Color brandFacebook = Color(0xFF1877F2);

  static const Color text1 = Color(0xFFF5F7FA);
  static const Color text2 = Color(0xFFA7AFBF);
  static const Color text3 = Color(0xFF667085);
  static const Color textDisabled = Color(0xFF566175);
  static const Color textDisabledBlue = Color(0xFF65718A);
  static const Color textMutedBlue = Color(0xFF8791A6);
  static const Color textSoftBlue = Color(0xFF9AA4B8);
  static const Color textMutedDense = Color(0xFF7B8497);
  static const Color textMutedLight = Color(0xFF98A2B3);
  static const Color textSoftLight = Color(0xFFAEB7CC);
  static const Color receiptTextMuted = Color(0xFFA9B1C6);
  static const Color receiptTextActive = Color(0xFFC8D2E8);
  static const Color attributionText = Color(0xFF64708A);
  static const Color chartAxisStrong = Color(0xFF475569);
  static const Color chartTrack = Color(0xFF20283A);
  static const Color chartTrackRisk = Color(0xFF202B45);
  static const Color chartLightMid = Color(0xFFE9EDF5);
  static const Color chartLightLow = Color(0xFFDDE3EE);

  static const Color navInactive = text3;
  static const Color navActive = primary;
  static const Color navBg = bg;
  static const Color navBorder = border;
  static const Color navCenterIcon = Color(0xFFFFFFFF);
  static const Color onAccent = navCenterIcon;
  static const Color transparent = Color.fromARGB(0, 0, 0, 0);

  static const Color searchBg = surface2;
  static const Color searchBorder = borderSolid;
  static const Color searchPlaceholder = text3;

  static const Color statusBarText = text1;
  static const Color statusBarIcon = text1;
  static const Color statusBarIconDim = Color(0x59F5F7FA);
  static const Color statusBattery = Color(0xFF34D399);

  static const Color frameBg = bg;
  static const Color dynamicIslandBg = Color.fromARGB(255, 0, 0, 0);
  static const Color phoneChromeShadow = Color.fromARGB(204, 0, 0, 0);
  static const Color phoneSensor = Color.fromARGB(255, 10, 10, 10);
  static const Color phoneLensStart = Color(0xFF1A2540);
  static const Color phoneLensMid = Color(0xFF0A0E1A);
  static const Color phoneLensEnd = dynamicIslandBg;
  static const Color modalScrim = Color(0x99000000);
  static const Color modalScrimStrong = Color(0xF2080C14);
  static const Color qrDark = Color(0xFF111111);
  static const Color qrNavy = Color(0xFF111827);
  static const Color heroNavy = Color(0xFF0E1D49);
  static const Color surfacePressed = Color(0xFF121928);
  static const Color surfaceNeutralLight = Color(0xFFF3F4F6);
  static const Color surfaceSuccessLight = Color(0xFFEFFDF5);
  static const Color surfaceSuccessSoft = Color(0xFFF0FDF4);
  static const Color surfaceDangerLight = Color(0xFFFFF1F1);
  static const Color surfaceWarningLight = Color(0xFFFFF7E8);
  static const Color surfaceInfoLight = Color(0xFFEFF6FF);
  static const Color surfaceAccentLight = Color(0xFFF5F3FF);
  static const Color surfaceNavy = Color(0xFF1E263A);
  static const Color surfaceNavyDeep = Color(0xFF111B2D);
  static const Color surfaceNavyDarker = Color(0xFF1D2635);
  static const Color surfaceNavyStroke = Color(0xFF384255);
  static const Color surfaceTradeDeep = Color(0xFF201926);
  static const Color controlBorderDisabled = Color(0xFF2C3545);
  static const Color homeBar = Color(0x38F5F7FA);
  static const Color overlayScrim = Color(0x33000000);
  static const Color overlayScrimSoft = Color(0x1A000000);
  static const Color overlayStroke = Color(0x14FFFFFF);
  static const Color overlaySubtle = Color(0x0AFFFFFF);

  static const Color cardBg = surface;
  static const Color cardBorder = Color(0x12FFFFFF);
  static const Color hoverBg = Color(0x0CFFFFFF);
  static const Color divider = Color(0x0DFFFFFF);
  static const Color dividerBlueSubtle = Color(0x141E293B);

  static const Color portfolioBorder = Color(0x26E58A00);
  static const Color portfolioTextDim = Color(0xB3FFFFFF);
  static const Color portfolioTextMuted = Color(0x73FFFFFF);
  static const Color portfolioBtnGhost = Color(0x1FFFFFFF);
  static const Color portfolioBtnGhostBorder = Color(0x26FFFFFF);
  static const Color portfolioBtnGhostText = onAccent;

  static const Color sectionLabel = Color(0xFF4A5568);
  static const Color toggleTrackOff = Color(0x52787880);

  static const Color warningBg = Color(0x14F5A524);
  static const Color warningBorder = Color(0x33F5A524);
  static const Color warningBorderStrong = Color(0x665A3A00);
  static const Color warningBorderDark = Color(0xFF92400E);
  @Deprecated(
    'Superseded by AppColors.riskWarning after TOKEN-WARN-01. warningText '
    'aliased warn, which conflated warning with soft brand orange.',
  )
  static const Color warningText = warn;
  static const Color infoTextStrong = Color(0xFF1E3A8A);
  static const Color accentTextStrong = Color(0xFF4C1D95);
  static const Color successAccentSoft = Color(0xFF6EE7B7);
  static const Color successAccentBright = Color(0xFF00DCA5);
  static const Color crashAccent = Color(0xFFE879F9);
  static const Color taxOptionBorder = Color(0xFF314166);
  static const Color analyticsBorder = Color(0xFF26303F);
  static const Color disputeDangerBg = Color(0x221F2937);

  static const Color primary08 = Color(0x14E58A00);
  static const Color primary12 = Color(0x1FE58A00);
  static const Color primary15 = Color(0x26E58A00);
  static const Color primary20 = Color(0x33E58A00);
  static const Color primary30 = Color(0x4DE58A00);
  static const Color primary40 = Color(0x66E58A00);
  static const Color primary60 = Color(0x99E58A00);

  static const Color buy10 = Color(0x1A10B981);
  static const Color buy12 = Color(0x1F10B981);
  static const Color buy15 = Color(0x2610B981);
  static const Color buy20 = Color(0x3310B981);
  static const Color buyTransparent = transparent;

  static const Color sell10 = Color(0x1AEF4444);
  static const Color sell15 = Color(0x26EF4444);
  static const Color sell20 = Color(0x33EF4444);
  static const Color sell33 = Color(0x55EF4444);

  @Deprecated('Superseded by AppColors.riskWarning08 after TOKEN-WARN-01')
  static const Color warn08 = warningBg;
  @Deprecated('Superseded by AppColors.riskWarning10 after TOKEN-WARN-01')
  static const Color warn10 = Color(0x1AF5A524);
  @Deprecated('Superseded by AppColors.riskWarning15 after TOKEN-WARN-01')
  static const Color warn15 = Color(0x26F5A524);
  static const Color riskWarning08 = Color(0x14F0A63A);
  static const Color riskWarning10 = Color(0x1AF0A63A);
  static const Color riskWarning15 = Color(0x26F0A63A);
  static const Color caution10 = Color(0x1AF59E0B);
  static const Color caution20 = Color(0x33F59E0B);

  static const Color accent06 = Color(0x0F8B5CF6);
  static const Color accent08 = Color(0x148B5CF6);
  static const Color accent10 = Color(0x1A8B5CF6);
  static const Color accent12 = Color(0x1F8B5CF6);
  static const Color accent15 = Color(0x268B5CF6);
  static const Color accent20 = Color(0x338B5CF6);
  static const Color accent30 = Color(0x4D8B5CF6);
}
