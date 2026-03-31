import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScrenn extends StatefulWidget {
  const CategoriesScrenn({super.key, required this.availableMeals});
  final List<Meal> availableMeals;

  @override
  State<CategoriesScrenn> createState() => _CategoriesScrennState();
}

class _CategoriesScrennState extends State<CategoriesScrenn>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = widget.availableMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => Meals(meals: filteredMeals, title: category.title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: GridView(
        padding: EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        children: [
          for (final category in availableCategories)
            CategoryGridItem(
              category: category,
              onSelectCategory: () {
                _selectCategory(context, category);
              },
            ),
        ],
      ),

      // builder: (context, child) => SlideTransition(
      //   position: Tween(begin: Offset(0, 0.3), end: Offset(0, 0)).animate(
      //     CurvedAnimation(
      //       parent: _animationController,
      //       curve: Curves.easeInOut,
      //     ),
      //   ),
      //   child: child,
      // ),
      builder: (context, child) => SlideTransition(
        position: _animationController.drive(
          Tween(begin: Offset(0, 0.3), end: Offset(0, 0)),
        ),
        child: child,
      ),

      // builder: (context, child) => Padding(
      //   padding: EdgeInsets.only(top: 100 - _animationController.value * 100),
      //   child: child,
      // ),
    );
  }
}
