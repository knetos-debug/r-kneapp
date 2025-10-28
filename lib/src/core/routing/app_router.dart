import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakneapp/src/features/counter/presentation/counter_screen.dart';
import 'package:rakneapp/src/features/stats/presentation/stats_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: CounterScreen.routeName,
        builder: (context, state) => const CounterScreen(),
      ),
      GoRoute(
        path: '/stats',
        name: StatsScreen.routeName,
        builder: (context, state) => const StatsScreen(),
      ),
    ],
  );
});
