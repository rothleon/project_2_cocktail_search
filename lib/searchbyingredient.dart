// Importing the dart:convert package for JSON serialization and deserialization
import 'dart:convert';

// Function to convert a JSON string to a SearchByIngredient object
SearchByIngredient searchbyingredientFromJson(String str) => SearchByIngredient.fromJson(json.decode(str));

// Function to convert a SearchByIngredient object to a JSON string
String searchbyingredientToJson(SearchByIngredient data) => json.encode(data.toJson());

// Class representing the structure of a SearchByIngredient, used for JSON serialization and deserialization
class SearchByIngredient {
  // List of DrinkFromSearch objects representing drinks in the search result
  List<DrinkFromSearch> drinks;

  // Constructor to initialize a SearchByIngredient object with a list of drinks
  SearchByIngredient({
    required this.drinks,
  });

  // Factory method to create a SearchByIngredient object from a JSON map
  factory SearchByIngredient.fromJson(Map<String, dynamic> json) => SearchByIngredient(
    drinks: List<DrinkFromSearch>.from(json["drinks"].map((x) => DrinkFromSearch.fromJson(x))),
  );

  // Method to convert a SearchByIngredient object to a JSON map
  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

// Class representing the structure of a drink in the search result, used for JSON serialization and deserialization
class DrinkFromSearch {
  // Drink name as a string
  String strDrink;

  // URL of the drink's thumbnail image as a string
  String strDrinkThumb;

  // ID of the drink as a string
  String idDrink;

  // Constructor to initialize a DrinkFromSearch object with drink details
  DrinkFromSearch({
    required this.strDrink,
    required this.strDrinkThumb,
    required this.idDrink,
  });

  // Factory method to create a DrinkFromSearch object from a JSON map
  factory DrinkFromSearch.fromJson(Map<String, dynamic> json) => DrinkFromSearch(
    strDrink: json["strDrink"],
    strDrinkThumb: json["strDrinkThumb"],
    idDrink: json["idDrink"],
  );

  // Method to convert a DrinkFromSearch object to a JSON map
  Map<String, dynamic> toJson() => {
    "strDrink": strDrink,
    "strDrinkThumb": strDrinkThumb,
    "idDrink": idDrink,
  };
}
