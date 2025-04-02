import 'package:flutter/material.dart';
import 'package:recipe_app/screens/recipe_list_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RecipeListScreen(),
    ),
  );
}
