import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/core/storage/secure_store.dart';

void main() {
  test('InMemorySecureStore read/write/delete', () async {
    final store = InMemorySecureStore();

    expect(await store.read('token'), isNull);
    await store.write('token', 'gia-tri-mat');
    expect(await store.read('token'), 'gia-tri-mat');

    await store.delete('token');
    expect(await store.read('token'), isNull);
    // delete khóa không tồn tại không được ném lỗi.
    await store.delete('khong-ton-tai');
  });

  test('InMemorySecureStore seed giá trị ban đầu', () async {
    final store = InMemorySecureStore(seed: {'token': 'seeded'});
    expect(await store.read('token'), 'seeded');
  });

  test('secureStoreProvider mặc định là in-memory', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(secureStoreProvider), isA<InMemorySecureStore>());
  });
}
