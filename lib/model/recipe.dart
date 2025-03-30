class Recipe {
  final int id;
  final String name;
  final List<String> ingredients;
  final String image;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.image,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      image: json['image'],
    );
  }
}
