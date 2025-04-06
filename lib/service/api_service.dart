import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:recipe_app/model/recipe.dart';

class ApiService {
  Future<List<Recipe>> fetchRecipes() async {
    final response = await http.get(Uri.parse("https://dummyjson.com/recipes"));
    if (response.statusCode == 200) {
      print("Api rep: ${response.body}");
      final jsonData = jsonDecode(response.body);
      final List<dynamic> recipeList = jsonData['recipes'];
      print("Count: ${recipeList.length}");
      return recipeList.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load recipes");
    }
  }

  Future<Recipe> fetchRecipeDetail(int id) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/recipes/$id"),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return Recipe.fromJson(jsonData);
    } else {
      throw Exception("Failed to get recipe detail");
    }
  }

  Future<List<Recipe>> searchRecipe(String query) async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/recipes/search?q=$query"),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> searchResult = jsonData['recipes'];
      return searchResult.map((json) => Recipe.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load searched recipes");
    }
  }

  Future<List<String>> fetchRecipeTags() async {
    final response = await http.get(
      Uri.parse("https://dummyjson.com/recipes/tags"),
    );

    if (response.statusCode == 200) {
      final List<dynamic> tags = jsonDecode(response.body);
      return tags.map((tag) => tag.toString()).toList();
    } else {
      throw Exception("Failed to load recipe tags");
    }
  }
  Future<List<Recipe>> filterRecipesByTag(String tag) async {
    final allRecipes = await fetchRecipes(); // fetch all
    return allRecipes.where((recipe) => recipe.tags.contains(tag)).toList();
  }
}



