# Räknarapp

En produktionsredo Flutter-boilerplate för dörrvakter som snabbt behöver räkna besökare i fyra kategorier och följa statistiken i stapeldiagram.

## Krav
- Flutter (senaste stabila kanalen)
- Dart SDK enligt `environment` i `pubspec.yaml`

## Kom igång
```bash
flutter pub get
flutter run
```

### Kodkvalitet
```bash
flutter analyze
flutter test
```

## Paket
- [go_router](https://pub.dev/packages/go_router) – enkel och deklarativ routing
- [flutter_riverpod](https://pub.dev/packages/flutter_riverpod) – reaktiv statehantering
- [fl_chart](https://pub.dev/packages/fl_chart) – stapeldiagram
- [shared_preferences](https://pub.dev/packages/shared_preferences) – lokal persistens
- [flutter_lints](https://pub.dev/packages/flutter_lints) – linterregler

## Mappstruktur
```
lib/
  main.dart
  src/
    core/
      routing/app_router.dart
      storage/prefs.dart
      theme/app_theme.dart
    features/
      counter/
        application/counter_controller.dart
        domain/category.dart
        presentation/counter_screen.dart
      stats/
        presentation/stats_screen.dart
```

## Skärmar
- **CounterScreen** – 2x2-grid med kategorierna Barn, Ungdom, Vuxen och Pensionär. Stora +/−-knappar, färg- och ikonindikatorer samt liveuppdaterad totalsiffra. App-baren innehåller en ikon som öppnar statistiksidan.
- **StatsScreen** – stapeldiagram över alla kategorier, total och procent per kategori, knapp för att rensa alla värden (med bekräftelse) samt tydlig navigation tillbaka till räknaren.

Persistenta värden lagras lokalt via `shared_preferences`, och hela appen använder Material 3 med ett färgschema baserat på indigo.
