import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakneapp/main.dart';
import 'package:rakneapp/src/core/storage/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Counter screen renders categories and updates totals',
      (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const RakneApp(),
      ),
    );
    await tester.pumpAndSettle();

    for (final label in ['Barn', 'Ungdom', 'Vuxen', 'Pensionär']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(find.text('Total: 0'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Öka barn'));
    await tester.pumpAndSettle();

    expect(find.text('Total: 1'), findsOneWidget);
  });
}
