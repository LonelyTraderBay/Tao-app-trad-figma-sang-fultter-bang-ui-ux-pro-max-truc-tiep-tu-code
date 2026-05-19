import 'package:flutter/material.dart';

final class AppRadii {
  const AppRadii._();

  static const double xs = 5;
  static const double sm = 8;
  static const double md = 13;
  static const double input = 14;
  static const double card = 16;
  static const double lg = 21;
  static const double cardLarge = 24;
  static const double xl = 34;
  static const double device = 55;

  static const BorderRadius xsRadius = BorderRadius.all(Radius.circular(xs));
  static const BorderRadius smRadius = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius mdRadius = BorderRadius.all(Radius.circular(md));
  static const BorderRadius inputRadius = BorderRadius.all(
    Radius.circular(input),
  );
  static const BorderRadius cardRadius = BorderRadius.all(
    Radius.circular(card),
  );
  static const BorderRadius lgRadius = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius cardLargeRadius = BorderRadius.all(
    Radius.circular(cardLarge),
  );
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(xl));
  static const BorderRadius deviceRadius = BorderRadius.all(
    Radius.circular(device),
  );
}
