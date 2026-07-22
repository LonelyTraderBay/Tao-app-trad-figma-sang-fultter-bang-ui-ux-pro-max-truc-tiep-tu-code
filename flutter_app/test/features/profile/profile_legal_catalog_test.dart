import 'package:flutter_test/flutter_test.dart';
import 'package:vit_trade_flutter/features/profile/domain/profile_legal_catalog.dart';

void main() {
  test('STEP-P1.4 ProfileLegalCatalog exposes 39 GOM items in 5 groups', () {
    expect(ProfileLegalCatalog.groups.map((g) => g.id), [
      'copy',
      'bots',
      'p2p',
      'arena',
      'launchpad',
    ]);
    expect(ProfileLegalCatalog.groups[0].items, hasLength(29));
    expect(ProfileLegalCatalog.groups[1].items, hasLength(6));
    expect(ProfileLegalCatalog.groups[2].items, hasLength(2));
    expect(ProfileLegalCatalog.groups[3].items, hasLength(1));
    expect(ProfileLegalCatalog.groups[4].items, hasLength(1));
    expect(ProfileLegalCatalog.itemCount, 39);
    expect(
      ProfileLegalCatalog.groups
          .expand((g) => g.items)
          .map((item) => item.route)
          .every((route) => route.startsWith('/')),
      isTrue,
    );
  });
}
