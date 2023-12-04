// Importing the dart:convert package for JSON serialization and deserialization
import 'dart:convert';

// Function to convert a JSON string to an Ingredientlist object
Ingredientlist ingredientlistFromJson(String str) => Ingredientlist.fromJson(json.decode(str));

// Function to convert an Ingredientlist object to a JSON string
String ingredientlistToJson(Ingredientlist data) => json.encode(data.toJson());

// Class representing the structure of an Ingredientlist, used for JSON serialization and deserialization
class Ingredientlist {
  // List of DrinkFromIngredientList objects representing drinks in the ingredient list
  List<DrinkFromIngredientList> drinks;

  // Constructor to initialize an Ingredientlist object with a list of drinks
  Ingredientlist({
    required this.drinks,
  });

  // Factory method to create an Ingredientlist object from a JSON map
  factory Ingredientlist.fromJson(Map<String, dynamic> json) => Ingredientlist(
    drinks: List<DrinkFromIngredientList>.from(json["drinks"].map((x) => DrinkFromIngredientList.fromJson(x))),
  );

  // Method to convert an Ingredientlist object to a JSON map
  Map<String, dynamic> toJson() => {
    // Converting the list of drinks to a list of dynamic
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

// Class representing the structure of a drink in the ingredient list, used for JSON serialization and deserialization
class DrinkFromIngredientList {
  String strIngredient1;

  // Constructor to initialize a DrinkFromIngredientList object with an ingredient name
  DrinkFromIngredientList({
    required this.strIngredient1,
  });

  // Factory method to create a DrinkFromIngredientList object from a JSON map
  factory DrinkFromIngredientList.fromJson(Map<String, dynamic> json) => DrinkFromIngredientList(
    strIngredient1: json["strIngredient1"],
  );

  // Method to convert a DrinkFromIngredientList object to a JSON map
  Map<String, dynamic> toJson() => {
    "strIngredient1": strIngredient1,
  };
}
