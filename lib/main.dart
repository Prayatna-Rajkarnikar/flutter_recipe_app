import 'package:flutter/material.dart';
import 'package:is_wear/is_wear.dart';
import 'package:recipe_app/screens/recipe_list_screen.dart';
import 'package:recipe_app/screens/wear_recipe_tags.dart';

late final bool isWear;

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // isWear = (await IsWear().check()) ?? false;

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: isWear ? WearRecipeTags() : RecipeListScreen(),
          home: RecipeListScreen(),
    ),
  );
}
