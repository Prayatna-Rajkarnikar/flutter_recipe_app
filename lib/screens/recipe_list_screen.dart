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
  late Future<List<String>> recipeTags;
  String? selectedTag;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    recipes = ApiService().fetchRecipes();
    recipeTags = ApiService().fetchRecipeTags();
  }

  void _searchRecipe(String query) {
    setState(() {
      recipes = ApiService().searchRecipe(query);
    });
  }

  void _filterByTag(String tag) {
    setState(() {
      selectedTag = tag;
      recipes = ApiService().searchRecipe(tag);
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Builder(
            builder:
                (context) => IconButton(
                  onPressed: () => Scaffold.of(context).openEndDrawer(),
                  icon: Icon(Icons.filter_list_rounded),
                ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: FutureBuilder<List<String>>(
          future: recipeTags,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Failed to load tags"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No tags available"));
            }
            return ListView(
              padding: EdgeInsets.all(16),
              children:
                  snapshot.data!.map((tag) {
                    return ListTile(
                      title: Text(tag),
                      onTap: () => _filterByTag(tag),
                    );
                  }).toList(),
            );
          },
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) => _searchRecipe(query),
          ),
          Expanded(
            child: FutureBuilder(
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
          ),
        ],
      ),
    );
  }
}
