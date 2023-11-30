// To parse this JSON data, do
//
//     final ingredientlist = ingredientlistFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;


Ingredientlist ingredientlistFromJson(String str) => Ingredientlist.fromJson(json.decode(str));

String ingredientlistToJson(Ingredientlist data) => json.encode(data.toJson());

class Ingredientlist {
  List<DrinkFromIngredientList> drinks;
  //List<String> ingredients = [""];

  /*
  void populateIngredients(){
    for (Drink drink in drinks){
      ingredients.add(drink.strIngredient1);
    }
  }
  */

  Ingredientlist({
    required this.drinks,
  });

  factory Ingredientlist.fromJson(Map<String, dynamic> json) => Ingredientlist(
    drinks: List<DrinkFromIngredientList>.from(json["drinks"].map((x) => DrinkFromIngredientList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

class DrinkFromIngredientList {
  String strIngredient1;

  DrinkFromIngredientList({
    required this.strIngredient1,
  });

  factory DrinkFromIngredientList.fromJson(Map<String, dynamic> json) => DrinkFromIngredientList(
    strIngredient1: json["strIngredient1"],
  );

  Map<String, dynamic> toJson() => {
    "strIngredient1": strIngredient1,
  };
}