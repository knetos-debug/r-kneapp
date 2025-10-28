import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakneapp/src/core/storage/prefs.dart';
import 'package:rakneapp/src/features/counter/domain/category.dart';

final counterControllerProvider =
    NotifierProvider<CounterController, CounterState>(CounterController.new);

class CounterState {
  const CounterState({
    this.barn = 0,
    this.ungdom = 0,
    this.vuxen = 0,
    this.pensionar = 0,
  });

  final int barn;
  final int ungdom;
  final int vuxen;
  final int pensionar;

  int get total => barn + ungdom + vuxen + pensionar;

  CounterState copyWith({
    int? barn,
    int? ungdom,
    int? vuxen,
    int? pensionar,
  }) {
    return CounterState(
      barn: barn ?? this.barn,
      ungdom: ungdom ?? this.ungdom,
      vuxen: vuxen ?? this.vuxen,
      pensionar: pensionar ?? this.pensionar,
    );
  }

  int valueFor(Category category) => switch (category) {
        Category.barn => barn,
        Category.ungdom => ungdom,
        Category.vuxen => vuxen,
        Category.pensionar => pensionar,
      };

  Map<String, int> toStorageMap() {
    return <String, int>{
      Category.barn.storageKey: barn,
      Category.ungdom.storageKey: ungdom,
      Category.vuxen.storageKey: vuxen,
      Category.pensionar.storageKey: pensionar,
    };
  }
}

class CounterController extends Notifier<CounterState> {
  late final PrefsRepository _prefsRepository;

  @override
  CounterState build() {
    _prefsRepository = ref.read(prefsRepositoryProvider);
    return CounterState(
      barn: _prefsRepository.getCount(Category.barn.storageKey),
      ungdom: _prefsRepository.getCount(Category.ungdom.storageKey),
      vuxen: _prefsRepository.getCount(Category.vuxen.storageKey),
      pensionar: _prefsRepository.getCount(Category.pensionar.storageKey),
    );
  }

  void inc(Category category) {
    state = _updatedState(category, state.valueFor(category) + 1);
    _persist();
  }

  void dec(Category category) {
    final current = state.valueFor(category);
    if (current == 0) {
      return;
    }
    state = _updatedState(category, current - 1);
    _persist();
  }

  Future<void> resetAll() async {
    state = const CounterState();
    await _prefsRepository.clearCounts(
      Category.values.map((category) => category.storageKey),
    );
  }

  CounterState _updatedState(Category category, int value) {
    return switch (category) {
      Category.barn => state.copyWith(barn: value),
      Category.ungdom => state.copyWith(ungdom: value),
      Category.vuxen => state.copyWith(vuxen: value),
      Category.pensionar => state.copyWith(pensionar: value),
    };
  }

  void _persist() {
    final values = state.toStorageMap();
    unawaited(_prefsRepository.setCounts(values));
  }
}
