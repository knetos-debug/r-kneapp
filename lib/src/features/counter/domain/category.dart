import 'package:flutter/material.dart';

enum Category { barn, ungdom, vuxen, pensionar }

extension CategoryX on Category {
  String get label => switch (this) {
        Category.barn => 'Barn',
        Category.ungdom => 'Ungdom',
        Category.vuxen => 'Vuxen',
        Category.pensionar => 'Pensionär',
      };

  IconData get icon => switch (this) {
        Category.barn => Icons.child_care,
        Category.ungdom => Icons.school,
        Category.vuxen => Icons.badge,
        Category.pensionar => Icons.elderly,
      };

  String get storageKey => switch (this) {
        Category.barn => 'count_barn',
        Category.ungdom => 'count_ungdom',
        Category.vuxen => 'count_vuxen',
        Category.pensionar => 'count_pensionar',
      };

  Color color(ColorScheme scheme) => switch (this) {
        Category.barn => scheme.primary,
        Category.ungdom => scheme.secondary,
        Category.vuxen => scheme.tertiary,
        Category.pensionar => scheme.primaryContainer,
      };
}
