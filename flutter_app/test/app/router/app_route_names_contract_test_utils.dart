import 'package:flutter_test/flutter_test.dart';

typedef RouteNameCase = MapEntry<String, String>;

RouteNameCase n(String actual, String expected) => MapEntry(actual, expected);

void routeNameContractTest(String description, List<RouteNameCase> cases) {
  test(description, () {
    for (final entry in cases) {
      expect(entry.key, entry.value, reason: entry.value);
    }
  });
}
