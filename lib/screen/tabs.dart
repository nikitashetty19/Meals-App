import 'package:flutter/material.dart';
import 'package:meal/data/dummy_data.dart';
import 'package:meal/model/meal.dart';
import 'package:meal/screen/categories.dart';
import 'package:meal/screen/filters.dart';
import 'package:meal/screen/meals.dart';
import 'package:meal/widget/main_drawer.dart';

Map<Filters, bool> kselectedFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegan: false,
  Filters.vegetarian: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;
  Map<Filters, bool> _selectedFilters = kselectedFilters;
  final List<Meal> _favouriteMeals = [];
  void selectedPage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(context).clearSnackBars;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  void _toggleFavMealStatus(Meal meal) {
    final isPresent = _favouriteMeals.contains(meal);
    if (isPresent) {
      setState(() {
        _favouriteMeals.remove(meal);
      });

      _showInfo('Meal removed from favorites');
    } else {
      setState(() {
        _favouriteMeals.add(meal);
      });
      _showInfo('Meal marked as favorites');
    }
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filters, bool>>(
        //pushreplecement-filter screen is not pushed as stackof screen but replaced with the currently active tab screen
        MaterialPageRoute(
          builder: (ctx) => FilterScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      setState(() {
        _selectedFilters = result ?? kselectedFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeal = dummyMeals.where((meal) {
      if (_selectedFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
        return false;
      }
      if (_selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filters.vegan]! && !meal.isVegan) {
        return false;
      }
      if (_selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      return true;
    }).toList();
    Widget activePage = CategoriesScreen(
      onToggleFav: _toggleFavMealStatus,
      availableMeals: availableMeal,
    );
    String activeTitle = 'Categories';
    if (_selectedIndex == 1) {
      activePage = MealsScreen(
        meals: _favouriteMeals,
        onToggleFav: _toggleFavMealStatus,
      );
      activeTitle = 'Your Favorites';
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(activeTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap: selectedPage,
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.set_meal,
              ),
              label: 'Categories'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
              ),
              label: 'Favourites'),
        ],
      ),
    );
  }
}
