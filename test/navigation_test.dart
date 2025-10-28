import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rakneapp/main.dart';
import 'package:rakneapp/src/core/storage/prefs.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('navigates between counter and stats screens', (tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const RakneApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Räknare'), findsOneWidget);
    expect(find.text('Barn'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel('Öka barn'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Öppna statistik'));
    await tester.pumpAndSettle();

    expect(find.text('Statistik'), findsOneWidget);
    expect(find.text('Total: 1'), findsOneWidget);

    await tester.tap(find.text('Rensa allt'));
    await tester.pumpAndSettle();
    expect(find.text('Rensa alla värden?'), findsOneWidget);

    await tester.tap(find.text('Rensa'));
    await tester.pumpAndSettle();

    expect(find.text('Total: 0'), findsOneWidget);

    await tester.tap(find.text('Tillbaka till räknaren'));
    await tester.pumpAndSettle();

    expect(find.text('Räknare'), findsOneWidget);
    expect(find.text('Total: 0'), findsOneWidget);
  });
}
