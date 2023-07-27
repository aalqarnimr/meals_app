import 'package:flutter/material.dart';

class Category {
  const Category(
      {required this.id, required this.title, this.color = Colors.orange});

  final String title;
  final String id;
  final Color color;

  // List<Meal> findMeals(List<Meal> allMeals) {
  //   List<Meal> categoryMeals = [];
  //   for (final meal in allMeals) {
  //     if (meal.categories.contains(id)) {
  //       categoryMeals.add(meal);
  //     }
  //   }
  //   return categoryMeals;
  // }
}
