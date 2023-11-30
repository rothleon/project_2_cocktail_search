// To parse this JSON data, do
//
//     final searchbyingredient = searchbyingredientFromJson(jsonString);

import 'dart:convert';
import 'package:http/http.dart' as http;

SearchByIngredient searchbyingredientFromJson(String str) => SearchByIngredient.fromJson(json.decode(str));

String searchbyingredientToJson(SearchByIngredient data) => json.encode(data.toJson());

class SearchByIngredient {
  List<DrinkFromSearch> drinks;

  SearchByIngredient({
    required this.drinks,
  });

  factory SearchByIngredient.fromJson(Map<String, dynamic> json) => SearchByIngredient(
    drinks: List<DrinkFromSearch>.from(json["drinks"].map((x) => DrinkFromSearch.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}

class DrinkFromSearch {
  String strDrink;
  String strDrinkThumb;
  String idDrink;

  DrinkFromSearch({
    required this.strDrink,
    required this.strDrinkThumb,
    required this.idDrink,
  });

  factory DrinkFromSearch.fromJson(Map<String, dynamic> json) => DrinkFromSearch(
    strDrink: json["strDrink"],
    strDrinkThumb: json["strDrinkThumb"],
    idDrink: json["idDrink"],
  );

  Map<String, dynamic> toJson() => {
    "strDrink": strDrink,
    "strDrinkThumb": strDrinkThumb,
    "idDrink": idDrink,
  };
}
