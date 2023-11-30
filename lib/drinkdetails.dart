// To parse this JSON data, do
//
//     final drinkDetail = drinkDetailFromJson(jsonString);

import 'dart:convert';

DrinkDetail drinkDetailFromJson(String str) => DrinkDetail.fromJson(json.decode(str));

String drinkDetailToJson(DrinkDetail data) => json.encode(data.toJson());

class DrinkDetail {
  List<DrinkFromDetail> drinks;

  DrinkDetail({
    required this.drinks,
  });

  factory DrinkDetail.fromJson(Map<String, dynamic> json) => DrinkDetail(
    drinks: List<DrinkFromDetail>.from(json["drinks"].map((x) => DrinkFromDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
  };
}


class DrinkFromDetail {
  String strDrink;
  String strDrinkThumb;
  String idDrink;
  String strInstructions;
  String strIngredient1 = "";
  String strIngredient2 = "";
  String strIngredient3 = "";
  String strIngredient4 = "";
  String strIngredient5 = "";
  String strIngredient6 = "";
  String strIngredient7 = "";
  String strIngredient8 = "";
  String strIngredient9 = "";
  String strIngredient10 = "";
  String strIngredient11 = "";
  String strIngredient12 = "";
  String strIngredient13 = "";
  String strIngredient14 = "";
  String strIngredient15 = "";




  DrinkFromDetail({
    required this.strDrink,
    required this.strDrinkThumb,
    required this.idDrink,
    required this.strInstructions,
    required this.strIngredient1,
    required this.strIngredient2,
    required this.strIngredient3,
    required this.strIngredient4,
    required this.strIngredient5,
    required this.strIngredient6,
    required this.strIngredient7,
    required this.strIngredient8,
    required this.strIngredient9,
    required this.strIngredient10,
    required this.strIngredient11,
    required this.strIngredient12,
    required this.strIngredient13,
    required this.strIngredient14,
    required this.strIngredient15,
  });

  factory DrinkFromDetail.fromJson(Map<String, dynamic> json) => DrinkFromDetail(
    strDrink: json["strDrink"],
    strDrinkThumb: json["strDrinkThumb"],
    idDrink: json["idDrink"],
    strInstructions: json["strInstructions"],
    strIngredient1: json["strIngredient1"],
    strIngredient2: json["strIngredient2"],
    strIngredient3: json["strIngredient3"],
    strIngredient4: json["strIngredient4"],
    strIngredient5: json["strIngredient5"],
    strIngredient6: json["strIngredient6"],
    strIngredient7: json["strIngredient7"],
    strIngredient8: json["strIngredient8"],
    strIngredient9: json["strIngredient9"],
    strIngredient10: json["strIngredient10"],
    strIngredient11: json["strIngredient11"],
    strIngredient12: json["strIngredient12"],
    strIngredient13: json["strIngredient13"],
    strIngredient14: json["strIngredient14"],
    strIngredient15: json["strIngredient15"],

  );

  Map<String, dynamic> toJson() => {
    "strDrink": strDrink,
    "strDrinkThumb": strDrinkThumb,
    "idDrink": idDrink,
    "strInstructions": strInstructions,
    "strIngredient1": strIngredient1,
    "strIngredient2": strIngredient2,
    "strIngredient3": strIngredient3,
    "strIngredient4": strIngredient4,
    "strIngredient5": strIngredient5,
    "strIngredient6": strIngredient6,
    "strIngredient7": strIngredient7,
    "strIngredient8": strIngredient8,
    "strIngredient9": strIngredient9,
    "strIngredient10": strIngredient10,
    "strIngredient11": strIngredient11,
    "strIngredient12": strIngredient12,
    "strIngredient13": strIngredient13,
    "strIngredient14": strIngredient14,
    "strIngredient15": strIngredient15,

  };
}