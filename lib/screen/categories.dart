import 'package:flutter/material.dart';
import 'package:meal/data/dummy_data.dart';
import 'package:meal/model/category.dart';
import 'package:meal/screen/meals.dart';
import 'package:meal/model/meal.dart';
import 'package:meal/widget/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen(
      {super.key, required this.onToggleFav, required this.availableMeals});
  final void Function(Meal meal) onToggleFav;
  final List<Meal> availableMeals;
  void _selectedCategory(BuildContext context, Category category) {
    final filteredscreen = availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealsScreen(
          onToggleFav: onToggleFav,
          title: category.title,
          meals: filteredscreen,
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
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 3 / 2),
      children: [
        //avalableCategories.map((categor=>CategoryGridItem(category:category)))
        for (final category in availableCategories)
          CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectedCategory(context, category);
              })
      ],
    );
  }
}
