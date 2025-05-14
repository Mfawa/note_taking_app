import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../models/category.dart';

final categoriesProvider = StateNotifierProvider<CategoriesNotifier, List<Category>>((ref) {
  return CategoriesNotifier(ref);
});

final themeProvider = StateProvider<bool>((ref) => false);

class CategoriesNotifier extends StateNotifier<List<Category>> {
  final Ref ref;
  late final Box<Category> _categoriesBox;

  CategoriesNotifier(this.ref) : super([]) {
    _categoriesBox = Hive.box<Category>('categories');
    state = _categoriesBox.values.toList();
    if (state.isEmpty) _initializeDefaultCategories();
  }

  void _initializeDefaultCategories() {
    state = [
      Category('General', Colors.blue),
      Category('Work', Colors.green),
      Category('Personal', Colors.orange),
    ];
    _categoriesBox.addAll(state);
  }

  addCategory(Category category) {
    _categoriesBox.add(category);
    state = _categoriesBox.values.toList();
  }
}
