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

    await tester.tap(find.byTooltip('Öppna statistik'));
    await tester.pumpAndSettle();

    expect(find.text('Statistik'), findsOneWidget);

    await tester.tap(find.text('Tillbaka till räknaren'));
    await tester.pumpAndSettle();

    expect(find.text('Räknare'), findsOneWidget);
  });
}
