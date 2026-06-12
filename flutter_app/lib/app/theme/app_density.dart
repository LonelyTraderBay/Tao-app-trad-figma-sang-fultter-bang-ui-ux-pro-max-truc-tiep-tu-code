enum VitDensity { compact, standard, relaxed }

extension VitDensityMetrics on VitDensity {
  double get controlHeight {
    switch (this) {
      case VitDensity.compact:
        return 44;
      case VitDensity.standard:
        return 52;
      case VitDensity.relaxed:
        return 58;
    }
  }

  double get verticalSpace {
    switch (this) {
      case VitDensity.compact:
        return 8;
      case VitDensity.standard:
        return 13;
      case VitDensity.relaxed:
        return 21;
    }
  }

  double get cardHorizontalPadding {
    switch (this) {
      case VitDensity.compact:
        return 12;
      case VitDensity.standard:
        return 16;
      case VitDensity.relaxed:
        return 21;
    }
  }
}
