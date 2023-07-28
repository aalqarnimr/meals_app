import 'package:flutter/material.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../models/meal.dart';

const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> filters = kInitialFilters;

  @override
  void initState() {
    super.initState();
    print('reached');
    _loadMeals();
  }

  Future<void> _loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      String encodedMealsString = (prefs.getString('favoriteMeals') ?? '[]');
      final List<dynamic> decodedMeals = json.decode(encodedMealsString);
      for (final meal in decodedMeals) {
        _favoriteMeals.add(Meal.fromJson(meal));
      }
    });
  }

  void _toggleFavoriteStatus(Meal meal) async {
    final isExisting = _favoriteMeals
        .where((favoriteMeal) => favoriteMeal.id == meal.id)
        .isNotEmpty;
    final prefs = await SharedPreferences.getInstance();
    if (isExisting) {
      setState(() {
        final itemMeal = _favoriteMeals
            .where((favoriteMeal) => favoriteMeal.id == meal.id)
            .toList()[0];
        print(itemMeal);
        _favoriteMeals.remove(itemMeal);
      });
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
    }
    String strJsonString = json.encode(_favoriteMeals);
    prefs.setString('favoriteMeals', strJsonString);
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.pop(context);
    if (identifier == 'filters') {
      final result = await Navigator.push<Map<Filter, bool>>(
        context,
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            choosenFilters: filters,
          ),
        ),
      );
      setState(() {
        filters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activeScreen = CategoriesScreen(
      onToggleFavorite: _toggleFavoriteStatus,
      favoriteMeals: _favoriteMeals,
      filters: filters,
    );
    var activePageTitle = 'Categories';
    if (_selectedPageIndex == 1) {
      activeScreen = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleFavoriteStatus,
        favoriteMeals: _favoriteMeals,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activeScreen,
      bottomNavigationBar: BottomNavigationBar(
        onTap: _selectPage,
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorites'),
        ],
      ),
    );
  }
}
