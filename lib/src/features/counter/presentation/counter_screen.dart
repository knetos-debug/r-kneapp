import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakneapp/src/features/counter/application/counter_controller.dart';
import 'package:rakneapp/src/features/counter/domain/category.dart';
import 'package:rakneapp/src/features/stats/presentation/stats_screen.dart';

class CounterScreen extends ConsumerWidget {
  const CounterScreen({super.key});

  static const routeName = 'counter';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterControllerProvider);
    final controller = ref.read(counterControllerProvider.notifier);
    final categories = Category.values;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Räknare'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Öppna statistik',
            onPressed: () => context.goNamed(StatsScreen.routeName),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const crossAxisCount = 2;
            final maxWidth = constraints.maxWidth;
            final childAspectRatio = maxWidth < 400
                ? 0.72
                : maxWidth < 600
                    ? 0.85
                    : 1.0;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: GridView.builder(
                      itemCount: categories.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: childAspectRatio,
                      ),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final count = state.valueFor(category);
                        return _CategoryCard(
                          category: category,
                          count: count,
                          onIncrement: () => controller.inc(category),
                          onDecrement: count == 0
                              ? null
                              : () => controller.dec(category),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _TotalCard(total: state.total),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.count,
    required this.onIncrement,
    required this.onDecrement,
  });

  final Category category;
  final int count;
  final VoidCallback onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categoryColor = category.color(colorScheme);
    final contrastColor =
        ThemeData.estimateBrightnessForColor(categoryColor) == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(category.icon, color: categoryColor),
                    const SizedBox(width: 8),
                    Text(
                      category.label,
                      style: textTheme.titleMedium,
                    ),
                  ],
                ),
                Text(
                  '$count',
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Tooltip(
              message: 'Öka ${category.label.toLowerCase()}',
              child: Semantics(
                button: true,
                label: 'Öka ${category.label.toLowerCase()}',
                child: FilledButton(
                  onPressed: onIncrement,
                  style: FilledButton.styleFrom(
                    backgroundColor: categoryColor,
                    foregroundColor: contrastColor,
                    minimumSize: const Size.fromHeight(56),
                  ),
                  child: Text(
                    '+',
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Tooltip(
              message: 'Minska ${category.label.toLowerCase()}',
              child: Semantics(
                button: true,
                label: 'Minska ${category.label.toLowerCase()}',
                child: OutlinedButton(
                  onPressed: onDecrement,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                  ),
                  child: Text(
                    '−',
                    style: textTheme.headlineMedium,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalCard extends StatelessWidget {
  const _TotalCard({required this.total});

  final int total;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Text(
          'Total: $total',
          textAlign: TextAlign.center,
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
