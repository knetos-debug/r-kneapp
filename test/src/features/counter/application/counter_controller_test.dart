import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakneapp/src/core/storage/prefs.dart';
import 'package:rakneapp/src/features/counter/application/counter_controller.dart';
import 'package:rakneapp/src/features/counter/domain/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  Future<ProviderContainer> createContainer() async {
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('increment increases category and total', () async {
    final container = await createContainer();
    final controller = container.read(counterControllerProvider.notifier);

    controller.inc(Category.barn);

    final state = container.read(counterControllerProvider);
    expect(state.barn, 1);
    expect(state.total, 1);

    final prefs = container.read(sharedPreferencesProvider);
    await Future<void>.delayed(Duration.zero);
    expect(prefs.getInt(Category.barn.storageKey), 1);
  });

  test('decrement never goes below zero', () async {
    final container = await createContainer();
    final controller = container.read(counterControllerProvider.notifier);

    controller.dec(Category.vuxen);
    expect(container.read(counterControllerProvider).vuxen, 0);

    controller.inc(Category.vuxen);
    controller.dec(Category.vuxen);
    expect(container.read(counterControllerProvider).vuxen, 0);
  });

  test('resetAll clears all values and persistence', () async {
    final container = await createContainer();
    final controller = container.read(counterControllerProvider.notifier);

    controller
      ..inc(Category.barn)
      ..inc(Category.ungdom)
      ..inc(Category.vuxen)
      ..inc(Category.pensionar);

    await controller.resetAll();

    final state = container.read(counterControllerProvider);
    expect(state.total, 0);
    final prefs = container.read(sharedPreferencesProvider);
    expect(prefs.getInt(Category.barn.storageKey), isNull);
  });
}
