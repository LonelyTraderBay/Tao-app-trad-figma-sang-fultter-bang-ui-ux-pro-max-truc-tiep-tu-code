import 'package:flutter_test/flutter_test.dart';

typedef RoutePathCase = MapEntry<String, String>;

RoutePathCase c(String actual, String expected) => MapEntry(actual, expected);

void routePathContractTest(String description, List<RoutePathCase> cases) {
  test(description, () {
    for (final entry in cases) {
      expect(entry.key, entry.value, reason: entry.value);
    }
  });
}
