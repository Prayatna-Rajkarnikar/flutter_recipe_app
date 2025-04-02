import 'package:flutter/material.dart';
import 'package:recipe_app/model/recipe.dart';
import 'package:recipe_app/screens/recipe_detail_screen.dart';
import 'package:recipe_app/service/api_service.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  late Future<List<Recipe>> recipes;

  @override
  void initState() {
    super.initState();
    recipes = ApiService().fetchRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: recipes,
        builder: (context, snapshot) {
          print("Snapshot Connection State: ${snapshot.connectionState}");
          print("Snapshot Has Data: ${snapshot.hasData}");
          print("Snapshot Error: ${snapshot.error}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          print("Snapshot Data: ${snapshot.data}");
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text("No data found"));
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final recipe = snapshot.data![index];
              return Padding(
                padding: EdgeInsets.all(16.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                RecipeDetailScreen(recipeId: recipe.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Card(
                      child: Column(
                        children: [
                          Image(image: NetworkImage(recipe.image)),
                          Text(recipe.name),
                          Text(recipe.tags.join(", ")),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
