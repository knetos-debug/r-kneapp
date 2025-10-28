import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rakneapp/src/features/counter/application/counter_controller.dart';
import 'package:rakneapp/src/features/counter/domain/category.dart';
import 'package:rakneapp/src/features/counter/presentation/counter_screen.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  static const routeName = 'stats';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(counterControllerProvider);
    final controller = ref.read(counterControllerProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Tillbaka till räknaren',
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 260,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: _BarChart(state: state),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total: ${state.total}',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      ...Category.values.map(
                        (category) => _CategoryStatRow(
                          category: category,
                          count: state.valueFor(category),
                          total: state.total,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Tooltip(
                message: 'Rensa alla räknare',
                child: Semantics(
                  button: true,
                  label: 'Rensa alla räknare',
                  child: FilledButton.icon(
                    onPressed: state.total == 0
                        ? null
                        : () => _confirmReset(context, controller),
                    style: FilledButton.styleFrom(
                      backgroundColor: colorScheme.error,
                      foregroundColor: colorScheme.onError,
                      minimumSize: const Size.fromHeight(56),
                    ),
                    icon: const Icon(Icons.delete_forever),
                    label: const Text('Rensa allt'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => context.goNamed(CounterScreen.routeName),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Tillbaka till räknaren'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    CounterController controller,
  ) async {
    final shouldReset = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rensa alla värden?'),
          content: const Text('Detta nollställer samtliga kategorier.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Avbryt'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Rensa'),
            ),
          ],
        );
      },
    );

    if (shouldReset == true) {
      await controller.resetAll();
    }
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.state});

  final CounterState state;

  @override
  Widget build(BuildContext context) {
    final highest = Category.values
        .map((category) => state.valueFor(category))
        .fold<int>(0, max);
    final interval = highest <= 4 ? 1.0 : (highest / 4).ceilToDouble();
    final maxY = highest == 0
        ? 4.0
        : max(highest.toDouble() + interval, highest * 1.2);
    final colorScheme = Theme.of(context).colorScheme;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        barTouchData: BarTouchData(enabled: false),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) => FlLine(
            color: colorScheme.outlineVariant,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              interval: interval,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= Category.values.length) {
                  return const SizedBox.shrink();
                }
                final category = Category.values[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    category.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < Category.values.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: state.valueFor(Category.values[i]).toDouble(),
                  width: 32,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  color: Category.values[i].color(colorScheme),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CategoryStatRow extends StatelessWidget {
  const _CategoryStatRow({
    required this.category,
    required this.count,
    required this.total,
  });

  final Category category;
  final int count;
  final int total;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final categoryColor = category.color(colorScheme);
    final contrastColor =
        ThemeData.estimateBrightnessForColor(categoryColor) == Brightness.dark
            ? Colors.white
            : Colors.black;
    final percentage = total == 0 ? 0 : ((count / total) * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: categoryColor,
            foregroundColor: contrastColor,
            child: Icon(category.icon),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${category.label} $count (${percentage}%)',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }
}
