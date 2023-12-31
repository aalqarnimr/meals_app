import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/category.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

import '../models/meal.dart';
import 'filters.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key,
      required this.onToggleFavorite,
      required this.favoriteMeals,
      required this.filters});
  final void Function(Meal meal) onToggleFavorite;
  final List<Meal> favoriteMeals;
  final Map<Filter, bool> filters;

  void _selectCategory(BuildContext context, Category category) {
    final categoryMeals = dummyMeals
        .where((meal) =>
            meal.categories.contains(category.id) &&
            (meal.isGlutenFree || !filters[Filter.glutenFree]!) &&
            (meal.isLactoseFree || !filters[Filter.lactoseFree]!) &&
            (meal.isVegetarian || !filters[Filter.vegetarian]!) &&
            (meal.isVegan || !filters[Filter.vegan]!))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          title: category.title,
          meals: categoryMeals,
          onToggleFavorite: onToggleFavorite,
          favoriteMeals: favoriteMeals,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 3 / 2,
      ),
      children: [
        for (final category in availableCategories)
          CategoryGridItem(
            category: category,
            onSelectCategory: _selectCategory,
          )
      ],
    );
  }
}
