// Importing the dart:convert package for JSON serialization and deserialization
import 'dart:convert';

// Function to convert a JSON string to a DrinkDetail object
DrinkDetail drinkDetailFromJson(String str) => DrinkDetail.fromJson(json.decode(str));

// Function to convert a DrinkDetail object to a JSON string using null safety
String drinkDetailNullsafeToJson(DrinkDetail data) => json.encode(data.toJson());

// Class representing the structure of a DrinkDetail, used for JSON serialization and deserialization
class DrinkDetail {
  // List of maps to store drink details, with keys and values being strings
  List<Map<String, String?>> drinks;

  // Constructor to initialize a DrinkDetail object with a list of drinks
  DrinkDetail({
    required this.drinks,
  });

  // Factory method to create a DrinkDetail object from a JSON map
  factory DrinkDetail.fromJson(Map<String, dynamic> json) => DrinkDetail(
    // Converting the list of drinks from the JSON map
    drinks: List<Map<String, String?>>.from(json["drinks"].map((x) => Map.from(x).map((k, v) => MapEntry<String, String?>(k, v)))),
  );

  // Method to convert a DrinkDetail object to a JSON map
  Map<String, dynamic> toJson() => {
    // Converting the list of drinks to a list of dynamic
    "drinks": List<dynamic>.from(drinks.map((x) => Map.from(x).map((k, v) => MapEntry<String, dynamic>(k, v)))),
  };
}
