import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vit_trade_flutter/core/storage/key_value_store.dart';

void main() {
  test('InMemoryKeyValueStore round-trip string/bool/stringList', () async {
    final store = InMemoryKeyValueStore();

    expect(store.getString('a'), isNull);
    await store.setString('a', 'gia-tri');
    expect(store.getString('a'), 'gia-tri');

    expect(store.getBool('b'), isNull);
    await store.setBool('b', true);
    expect(store.getBool('b'), isTrue);

    expect(store.getStringList('c'), isNull);
    await store.setStringList('c', ['x', 'y']);
    expect(store.getStringList('c'), ['x', 'y']);

    await store.remove('a');
    expect(store.getString('a'), isNull);
    // remove khóa không tồn tại không được ném lỗi.
    await store.remove('khong-ton-tai');
  });

  test('InMemoryKeyValueStore không rò rỉ tham chiếu danh sách', () async {
    final store = InMemoryKeyValueStore();
    final input = ['x'];
    await store.setStringList('c', input);
    input.add('y');
    expect(store.getStringList('c'), ['x']);

    final output = store.getStringList('c')!..add('z');
    expect(output, ['x', 'z']);
    expect(store.getStringList('c'), ['x']);
  });

  test('InMemoryKeyValueStore seed giá trị ban đầu', () {
    final store = InMemoryKeyValueStore(seed: {'flag': true, 'name': 'vit'});
    expect(store.getBool('flag'), isTrue);
    expect(store.getString('name'), 'vit');
  });

  test('keyValueStoreProvider mặc định là in-memory', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    expect(container.read(keyValueStoreProvider), isA<InMemoryKeyValueStore>());
  });
}
